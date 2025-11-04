import 'package:equatable/equatable.dart';
import '../models/table_row_data.dart';

/// State for the FlexibleTable
class FlexibleTableState extends Equatable {
  /// All data rows
  final List<TableRowData> allData;

  /// Current page number (0-indexed)
  final int currentPage;

  /// Number of rows to display per page
  final int rowsPerPage;

  /// Currently displayed rows (after pagination)
  final List<TableRowData> displayedRows;

  /// Total number of pages
  final int totalPages;

  /// Total number of items
  final int totalItems;

  /// Set of selected row IDs
  final Set<String> selectedRowIds;

  const FlexibleTableState({
    required this.allData,
    required this.currentPage,
    required this.rowsPerPage,
    required this.displayedRows,
    required this.totalPages,
    required this.totalItems,
    required this.selectedRowIds,
  });

  /// Initial state factory
  factory FlexibleTableState.initial({
    List<TableRowData>? data,
    int rowsPerPage = 10,
  }) {
    final allData = data ?? [];
    final totalItems = allData.length;
    final totalPages = (totalItems / rowsPerPage).ceil();
    final displayedRows = allData.take(rowsPerPage).toList();

    return FlexibleTableState(
      allData: allData,
      currentPage: 0,
      rowsPerPage: rowsPerPage,
      displayedRows: displayedRows,
      totalPages: totalPages,
      totalItems: totalItems,
      selectedRowIds: {},
    );
  }

  /// Creates a copy of this state with updated properties
  FlexibleTableState copyWith({
    List<TableRowData>? allData,
    int? currentPage,
    int? rowsPerPage,
    List<TableRowData>? displayedRows,
    int? totalPages,
    int? totalItems,
    Set<String>? selectedRowIds,
  }) {
    return FlexibleTableState(
      allData: allData ?? this.allData,
      currentPage: currentPage ?? this.currentPage,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      displayedRows: displayedRows ?? this.displayedRows,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      selectedRowIds: selectedRowIds ?? this.selectedRowIds,
    );
  }

  /// Calculate displayed rows based on current page and rows per page
  FlexibleTableState withRecalculatedDisplay() {
    final startIndex = currentPage * rowsPerPage;
    final endIndex = (startIndex + rowsPerPage).clamp(0, totalItems);
    final displayed = allData.sublist(startIndex, endIndex);

    return copyWith(
      displayedRows: displayed,
      totalPages: (totalItems / rowsPerPage).ceil(),
    );
  }

  @override
  List<Object?> get props => [
    allData,
    currentPage,
    rowsPerPage,
    displayedRows,
    totalPages,
    totalItems,
    selectedRowIds,
  ];
}
