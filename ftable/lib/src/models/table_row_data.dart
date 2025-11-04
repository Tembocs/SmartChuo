import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// Represents a row of data in the flexible table
///
/// Each row contains a map of cell data keyed by column keys
/// and optional styling configuration.
class TableRowData extends Equatable {
  /// Unique identifier for the row
  final String? id;

  /// Map of column key to cell widget or content
  final Map<String, Widget> cells;

  /// Background color for this row (overrides alternate colors)
  final Color? backgroundColor;

  /// Height of this specific row
  final double? height;

  /// Callback when the row is tapped
  final VoidCallback? onTap;

  /// Whether this row is selectable
  final bool selectable;

  /// Whether this row is currently selected
  final bool selected;

  const TableRowData({
    this.id,
    required this.cells,
    this.backgroundColor,
    this.height,
    this.onTap,
    this.selectable = false,
    this.selected = false,
  });

  /// Creates a copy of this row with updated properties
  TableRowData copyWith({
    String? id,
    Map<String, Widget>? cells,
    Color? backgroundColor,
    double? height,
    VoidCallback? onTap,
    bool? selectable,
    bool? selected,
  }) {
    return TableRowData(
      id: id ?? this.id,
      cells: cells ?? this.cells,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      height: height ?? this.height,
      onTap: onTap ?? this.onTap,
      selectable: selectable ?? this.selectable,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [
    id,
    cells,
    backgroundColor,
    height,
    selectable,
    selected,
  ];
}
