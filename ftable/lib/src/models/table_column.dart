import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Defines a column in the flexible table
///
/// Each column has a key identifier, display label, width configuration,
/// and optional pinning behavior for fixed positioning.
class TableColumn extends Equatable {
  /// Unique identifier for the column
  final String key;

  /// Display label shown in the header
  final String label;

  /// Width of the column in pixels
  final double width;

  /// Minimum width constraint for the column
  final double minWidth;

  /// Maximum width constraint for the column
  final double? maxWidth;

  /// Whether this column is pinned to the left side
  final bool pinLeft;

  /// Whether this column is pinned to the right side
  final bool pinRight;

  /// Custom widget builder for the header cell
  final Widget Function(BuildContext context)? headerBuilder;

  /// Alignment of content within cells
  final Alignment alignment;

  const TableColumn({
    required this.key,
    required this.label,
    this.width = 150.0,
    this.minWidth = 50.0,
    this.maxWidth,
    this.pinLeft = false,
    this.pinRight = false,
    this.headerBuilder,
    this.alignment = Alignment.centerLeft,
  });

  /// Creates a copy of this column with updated properties
  TableColumn copyWith({
    String? key,
    String? label,
    double? width,
    double? minWidth,
    double? maxWidth,
    bool? pinLeft,
    bool? pinRight,
    Widget Function(BuildContext context)? headerBuilder,
    Alignment? alignment,
  }) {
    return TableColumn(
      key: key ?? this.key,
      label: label ?? this.label,
      width: width ?? this.width,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      pinLeft: pinLeft ?? this.pinLeft,
      pinRight: pinRight ?? this.pinRight,
      headerBuilder: headerBuilder ?? this.headerBuilder,
      alignment: alignment ?? this.alignment,
    );
  }

  @override
  List<Object?> get props => [
    key,
    label,
    width,
    minWidth,
    maxWidth,
    pinLeft,
    pinRight,
    alignment,
  ];
}
