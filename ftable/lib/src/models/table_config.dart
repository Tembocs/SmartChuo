import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Configuration for grid line display in the table
enum GridLineDisplay {
  /// Show no grid lines
  none,

  /// Show only horizontal grid lines
  horizontal,

  /// Show only vertical grid lines
  vertical,

  /// Show all grid lines
  all,
}

/// Configuration options for the flexible table
///
/// This class defines all customizable aspects of the table's appearance
/// and behavior including colors, dimensions, pagination, and grid lines.
class TableConfig extends Equatable {
  /// Default row height in pixels
  final double rowHeight;

  /// Header row height in pixels
  final double headerHeight;

  /// Background color for the header row
  final Color? headerBackgroundColor;

  /// Text style for header cells
  final TextStyle? headerTextStyle;

  /// Primary background color for rows
  final Color? rowColor;

  /// Alternate background color for rows (for striped effect)
  final Color? alternateRowColor;

  /// Border color for grid lines
  final Color gridLineColor;

  /// Width of grid lines in pixels
  final double gridLineWidth;

  /// Which grid lines to display
  final GridLineDisplay gridLineDisplay;

  /// Whether to show pagination controls
  final bool enablePagination;

  /// Number of rows per page (when pagination is enabled)
  final int rowsPerPage;

  /// Options for rows per page selector
  final List<int> rowsPerPageOptions;

  /// Whether to show the total count of items
  final bool showItemCount;

  /// Padding inside each cell
  final EdgeInsets cellPadding;

  /// Whether cells should automatically show ellipsis on overflow
  final bool enableEllipsis;

  /// Border configuration for the entire table
  final BoxBorder? tableBorder;

  /// Elevation of the table
  final double elevation;

  /// Border radius for the table container
  final BorderRadius? borderRadius;

  const TableConfig({
    this.rowHeight = 48.0,
    this.headerHeight = 56.0,
    this.headerBackgroundColor,
    this.headerTextStyle,
    this.rowColor,
    this.alternateRowColor,
    this.gridLineColor = const Color(0xFFE0E0E0),
    this.gridLineWidth = 1.0,
    this.gridLineDisplay = GridLineDisplay.all,
    this.enablePagination = false,
    this.rowsPerPage = 10,
    this.rowsPerPageOptions = const [10, 25, 50, 100],
    this.showItemCount = true,
    this.cellPadding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 8.0,
    ),
    this.enableEllipsis = true,
    this.tableBorder,
    this.elevation = 0.0,
    this.borderRadius,
  });

  /// Creates a copy of this config with updated properties
  TableConfig copyWith({
    double? rowHeight,
    double? headerHeight,
    Color? headerBackgroundColor,
    TextStyle? headerTextStyle,
    Color? rowColor,
    Color? alternateRowColor,
    Color? gridLineColor,
    double? gridLineWidth,
    GridLineDisplay? gridLineDisplay,
    bool? enablePagination,
    int? rowsPerPage,
    List<int>? rowsPerPageOptions,
    bool? showItemCount,
    EdgeInsets? cellPadding,
    bool? enableEllipsis,
    BoxBorder? tableBorder,
    double? elevation,
    BorderRadius? borderRadius,
  }) {
    return TableConfig(
      rowHeight: rowHeight ?? this.rowHeight,
      headerHeight: headerHeight ?? this.headerHeight,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      rowColor: rowColor ?? this.rowColor,
      alternateRowColor: alternateRowColor ?? this.alternateRowColor,
      gridLineColor: gridLineColor ?? this.gridLineColor,
      gridLineWidth: gridLineWidth ?? this.gridLineWidth,
      gridLineDisplay: gridLineDisplay ?? this.gridLineDisplay,
      enablePagination: enablePagination ?? this.enablePagination,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      rowsPerPageOptions: rowsPerPageOptions ?? this.rowsPerPageOptions,
      showItemCount: showItemCount ?? this.showItemCount,
      cellPadding: cellPadding ?? this.cellPadding,
      enableEllipsis: enableEllipsis ?? this.enableEllipsis,
      tableBorder: tableBorder ?? this.tableBorder,
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  List<Object?> get props => [
    rowHeight,
    headerHeight,
    headerBackgroundColor,
    headerTextStyle,
    rowColor,
    alternateRowColor,
    gridLineColor,
    gridLineWidth,
    gridLineDisplay,
    enablePagination,
    rowsPerPage,
    rowsPerPageOptions,
    showItemCount,
    cellPadding,
    enableEllipsis,
    tableBorder,
    elevation,
    borderRadius,
  ];
}
