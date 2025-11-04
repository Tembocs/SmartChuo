import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/flexible_table_bloc.dart';
import '../bloc/flexible_table_event.dart';
import '../bloc/flexible_table_state.dart';
import '../models/table_column.dart';
import '../models/table_config.dart';
import '../models/table_row_data.dart';

/// A highly flexible and customizable data table widget for Flutter
///
/// Features:
/// - Horizontal and vertical scrolling
/// - Fixed header row
/// - Pinnable left and right columns
/// - Adjustable column widths and row heights
/// - Pagination support
/// - Configurable grid lines
/// - Alternate row colors
/// - Automatic text ellipsis on overflow
/// - Custom cell widgets
class FlexibleTable extends StatefulWidget {
  /// List of column definitions
  final List<TableColumn> columns;

  /// List of data rows (used when not using builder)
  final List<TableRowData>? data;

  /// Builder function for data rows (alternative to data list)
  final List<TableRowData> Function(BuildContext context)? dataBuilder;

  /// Table configuration options
  final TableConfig config;

  /// Callback when a row is tapped
  final void Function(TableRowData row)? onRowTap;

  /// Callback when column width is changed
  final void Function(String columnKey, double newWidth)? onColumnResize;

  const FlexibleTable({
    super.key,
    required this.columns,
    this.data,
    this.dataBuilder,
    this.config = const TableConfig(),
    this.onRowTap,
    this.onColumnResize,
  }) : assert(
         data != null || dataBuilder != null,
         'Either data or dataBuilder must be provided',
       );

  @override
  State<FlexibleTable> createState() => _FlexibleTableState();
}

class _FlexibleTableState extends State<FlexibleTable> {
  // Horizontal scroll controller for the center header (programmatic only)
  late ScrollController _horizontalHeaderController;
  // Horizontal scroll controller for the center body (user-driven)
  late ScrollController _horizontalBodyController;
  // Vertical scroll controller shared across left/center/right zones
  late ScrollController _verticalController;
  late FlexibleTableBloc _bloc;

  // Runtime adjustable column widths keyed by column key
  late Map<String, double> _columnWidths;

  @override
  void initState() {
    super.initState();
    _horizontalHeaderController = ScrollController();
    _horizontalBodyController = ScrollController();
    _verticalController = ScrollController();

    // Initialize column widths from the provided column definitions
    _columnWidths = {for (final c in widget.columns) c.key: c.width};

    // Keep header's horizontal position in sync with the body (one-way)
    _horizontalBodyController.addListener(() {
      if (_horizontalHeaderController.hasClients &&
          _horizontalHeaderController.offset !=
              _horizontalBodyController.offset) {
        _horizontalHeaderController.jumpTo(_horizontalBodyController.offset);
      }
    });

    final initialData = widget.dataBuilder != null
        ? widget.dataBuilder!(context)
        : widget.data!;

    _bloc = FlexibleTableBloc(
      initialData: initialData,
      rowsPerPage: widget.config.rowsPerPage,
    );
  }

  @override
  void didUpdateWidget(FlexibleTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data && widget.data != null) {
      _bloc.add(UpdateDataEvent(widget.data!));
    }

    // When columns change, refresh width map while preserving any adjusted widths
    if (widget.columns != oldWidget.columns) {
      final next = <String, double>{};
      for (final c in widget.columns) {
        next[c.key] = _columnWidths[c.key] ?? c.width;
      }
      _columnWidths = next;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _horizontalHeaderController.dispose();
    _horizontalBodyController.dispose();
    _verticalController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<FlexibleTableBloc, FlexibleTableState>(
        builder: (context, state) {
          return Column(
            children: [
              // Table (header + body)
              Expanded(child: _buildTableContent(state)),
              // Pagination controls (optional)
              if (widget.config.enablePagination)
                _buildPaginationControls(state),
            ],
          );
        },
      ),
    );
  }

  /// Build the main table content with scrolling
  Widget _buildTableContent(FlexibleTableState state) {
    final displayData = widget.config.enablePagination
        ? state.displayedRows
        : state.allData;

    // Split columns into pinned-left, center (scrollable), and pinned-right
    final leftColumns = widget.columns.where((c) => c.pinLeft).toList();
    final rightColumns = widget.columns.where((c) => c.pinRight).toList();
    final centerColumns = widget.columns
        .where((c) => !c.pinLeft && !c.pinRight)
        .toList();

    return Material(
      elevation: widget.config.elevation,
      borderRadius: widget.config.borderRadius,
      child: Container(
        decoration: BoxDecoration(
          border: widget.config.tableBorder,
          borderRadius: widget.config.borderRadius,
        ),
        child: Column(
          children: [
            // Fixed Header (pinned L + scrollable center + pinned R)
            _buildHeaderRow(
              leftColumns: leftColumns,
              centerColumns: centerColumns,
              rightColumns: rightColumns,
            ),
            // Scrollable Body
            Expanded(
              child: _buildBody(
                leftColumns: leftColumns,
                centerColumns: centerColumns,
                rightColumns: rightColumns,
                rows: displayData,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the fixed header row
  Widget _buildHeaderRow({
    required List<TableColumn> leftColumns,
    required List<TableColumn> centerColumns,
    required List<TableColumn> rightColumns,
  }) {
    final centerWidth = centerColumns.fold<double>(
      0.0,
      (sum, c) => sum + (_columnWidths[c.key] ?? c.width),
    );

    return Container(
      height: widget.config.headerHeight,
      decoration: BoxDecoration(
        color:
            widget.config.headerBackgroundColor ??
            Theme.of(context).colorScheme.surfaceContainerHighest,
        border: _shouldShowGridLine(isHorizontal: true)
            ? Border(
                bottom: BorderSide(
                  color: widget.config.gridLineColor,
                  width: widget.config.gridLineWidth,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          // Left pinned headers
          if (leftColumns.isNotEmpty)
            Row(children: leftColumns.map(_buildHeaderCell).toList()),

          // Center scrollable headers
          if (centerColumns.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                controller: _horizontalHeaderController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: centerWidth,
                  height: widget.config.headerHeight,
                  child: Row(
                    children: centerColumns.map(_buildHeaderCell).toList(),
                  ),
                ),
              ),
            ),

          // Right pinned headers
          if (rightColumns.isNotEmpty)
            Row(children: rightColumns.map(_buildHeaderCell).toList()),
        ],
      ),
    );
  }

  /// Build a single header cell
  Widget _buildHeaderCell(TableColumn column) {
    final width = _columnWidths[column.key] ?? column.width;
    return Stack(
      children: [
        Container(
          width: width,
          padding: widget.config.cellPadding,
          decoration: BoxDecoration(
            border: _shouldShowGridLine(isVertical: true)
                ? Border(
                    right: BorderSide(
                      color: widget.config.gridLineColor,
                      width: widget.config.gridLineWidth,
                    ),
                  )
                : null,
          ),
          child: column.headerBuilder != null
              ? column.headerBuilder!(context)
              : Align(
                  alignment: column.alignment,
                  child: Text(
                    column.label,
                    style:
                        widget.config.headerTextStyle ??
                        Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: widget.config.enableEllipsis
                        ? TextOverflow.ellipsis
                        : null,
                  ),
                ),
        ),
        // Right-edge resize handle
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeLeftRight,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragUpdate: (details) {
                final current = _columnWidths[column.key] ?? column.width;
                double next = current + details.delta.dx;
                final minW = column.minWidth;
                final maxW = column.maxWidth ?? double.infinity;
                if (next < minW) next = minW;
                if (next > maxW) next = maxW;
                if (next != current) {
                  setState(() {
                    _columnWidths[column.key] = next;
                  });
                  widget.onColumnResize?.call(column.key, next);
                }
              },
              child: Container(
                width: 8,
                color: Colors.transparent,
                alignment: Alignment.centerRight,
                child: Container(
                  width: 1,
                  color: _shouldShowGridLine(isVertical: true)
                      ? widget.config.gridLineColor
                      : Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build the scrollable body with pinned columns
  Widget _buildBody({
    required List<TableColumn> leftColumns,
    required List<TableColumn> centerColumns,
    required List<TableColumn> rightColumns,
    required List<TableRowData> rows,
  }) {
    final centerWidth = centerColumns.fold<double>(
      0.0,
      (sum, c) => sum + (_columnWidths[c.key] ?? c.width),
    );
    return Scrollbar(
      controller: _verticalController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _verticalController,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left pinned column cells
            if (leftColumns.isNotEmpty)
              Column(
                children: List.generate(rows.length, (index) {
                  return _buildPinnedRow(
                    rowData: rows[index],
                    index: index,
                    columns: leftColumns,
                  );
                }),
              ),

            // Center horizontally scrollable cells
            if (centerColumns.isNotEmpty)
              Expanded(
                child: Scrollbar(
                  controller: _horizontalBodyController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _horizontalBodyController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: centerWidth,
                      child: Column(
                        children: List.generate(rows.length, (index) {
                          return _buildScrollableRow(
                            rowData: rows[index],
                            index: index,
                            columns: centerColumns,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),

            // Right pinned column cells
            if (rightColumns.isNotEmpty)
              Column(
                children: List.generate(rows.length, (index) {
                  return _buildPinnedRow(
                    rowData: rows[index],
                    index: index,
                    columns: rightColumns,
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }

  /// Build a single data row for a set of columns (used for pinned zones)
  Widget _buildPinnedRow({
    required TableRowData rowData,
    required int index,
    required List<TableColumn> columns,
  }) {
    final rowColor =
        rowData.backgroundColor ??
        (widget.config.alternateRowColor != null && index.isOdd
            ? widget.config.alternateRowColor
            : widget.config.rowColor);

    final rowHeight = rowData.height ?? widget.config.rowHeight;

    return InkWell(
      onTap:
          rowData.onTap ??
          (widget.onRowTap != null ? () => widget.onRowTap!(rowData) : null),
      child: Container(
        height: rowHeight,
        decoration: BoxDecoration(
          color: rowColor,
          border: _shouldShowGridLine(isHorizontal: true)
              ? Border(
                  bottom: BorderSide(
                    color: widget.config.gridLineColor,
                    width: widget.config.gridLineWidth,
                  ),
                )
              : null,
        ),
        child: Row(
          children: columns.map((c) => _buildDataCell(c, rowData)).toList(),
        ),
      ),
    );
  }

  /// Build a single data row for the scrollable center zone
  Widget _buildScrollableRow({
    required TableRowData rowData,
    required int index,
    required List<TableColumn> columns,
  }) {
    return _buildPinnedRow(rowData: rowData, index: index, columns: columns);
  }

  /// Build a single data cell
  Widget _buildDataCell(TableColumn column, TableRowData rowData) {
    final cellWidget = rowData.cells[column.key] ?? const SizedBox.shrink();

    return Container(
      width: _columnWidths[column.key] ?? column.width,
      padding: widget.config.cellPadding,
      decoration: BoxDecoration(
        border: _shouldShowGridLine(isVertical: true)
            ? Border(
                right: BorderSide(
                  color: widget.config.gridLineColor,
                  width: widget.config.gridLineWidth,
                ),
              )
            : null,
      ),
      child: Align(
        alignment: column.alignment,
        child: widget.config.enableEllipsis
            ? _EllipsisWrapper(child: cellWidget)
            : cellWidget,
      ),
    );
  }

  /// Build pagination controls
  Widget _buildPaginationControls(FlexibleTableState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: widget.config.gridLineColor,
            width: widget.config.gridLineWidth,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Item count
          if (widget.config.showItemCount)
            Text(
              'Total: ${state.totalItems} items',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          Row(
            children: [
              // Rows per page selector
              Text(
                'Rows per page:',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: state.rowsPerPage,
                items: widget.config.rowsPerPageOptions.map((count) {
                  return DropdownMenuItem<int>(
                    value: count,
                    child: Text(count.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _bloc.add(ChangeRowsPerPageEvent(value));
                  }
                },
              ),
              const SizedBox(width: 16),
              // Page info
              Text(
                'Page ${state.currentPage + 1} of ${state.totalPages}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 8),
              // Previous page button
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: state.currentPage > 0
                    ? () => _bloc.add(ChangePageEvent(state.currentPage - 1))
                    : null,
              ),
              // Next page button
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: state.currentPage < state.totalPages - 1
                    ? () => _bloc.add(ChangePageEvent(state.currentPage + 1))
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Check if grid line should be shown based on configuration
  bool _shouldShowGridLine({
    bool isHorizontal = false,
    bool isVertical = false,
  }) {
    switch (widget.config.gridLineDisplay) {
      case GridLineDisplay.none:
        return false;
      case GridLineDisplay.horizontal:
        return isHorizontal;
      case GridLineDisplay.vertical:
        return isVertical;
      case GridLineDisplay.all:
        return true;
    }
  }
}

/// Wrapper widget to handle text ellipsis for any child widget
class _EllipsisWrapper extends StatelessWidget {
  final Widget child;

  const _EllipsisWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    // If the child is already a Text widget, ensure it has ellipsis
    if (child is Text) {
      final text = child as Text;
      return Text(
        text.data ?? '',
        style: text.style,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }
    // Otherwise, wrap in a constrained box to prevent overflow
    return child;
  }
}
