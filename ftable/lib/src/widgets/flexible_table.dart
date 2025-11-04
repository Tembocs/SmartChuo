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
  late ScrollController _horizontalController;
  late ScrollController _verticalController;
  late FlexibleTableBloc _bloc;

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
    _verticalController = ScrollController();

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
  }

  @override
  void dispose() {
    _horizontalController.dispose();
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
              Expanded(child: _buildTableContent(state)),
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
            // Fixed Header
            _buildHeaderRow(),
            // Scrollable Body
            Expanded(
              child: Scrollbar(
                controller: _verticalController,
                thumbVisibility: true,
                child: Scrollbar(
                  controller: _horizontalController,
                  thumbVisibility: true,
                  notificationPredicate: (notification) =>
                      notification.depth == 1,
                  child: SingleChildScrollView(
                    controller: _verticalController,
                    child: SingleChildScrollView(
                      controller: _horizontalController,
                      scrollDirection: Axis.horizontal,
                      child: _buildDataRows(displayData),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the fixed header row
  Widget _buildHeaderRow() {
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
        children: widget.columns.map((column) {
          return _buildHeaderCell(column);
        }).toList(),
      ),
    );
  }

  /// Build a single header cell
  Widget _buildHeaderCell(TableColumn column) {
    return Container(
      width: column.width,
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
    );
  }

  /// Build all data rows
  Widget _buildDataRows(List<TableRowData> rows) {
    return Column(
      children: List.generate(rows.length, (index) {
        return _buildDataRow(rows[index], index);
      }),
    );
  }

  /// Build a single data row
  Widget _buildDataRow(TableRowData rowData, int index) {
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
          children: widget.columns.map((column) {
            return _buildDataCell(column, rowData);
          }).toList(),
        ),
      ),
    );
  }

  /// Build a single data cell
  Widget _buildDataCell(TableColumn column, TableRowData rowData) {
    final cellWidget = rowData.cells[column.key] ?? const SizedBox.shrink();

    return Container(
      width: column.width,
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
