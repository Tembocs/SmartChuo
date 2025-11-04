import 'package:equatable/equatable.dart';
import '../models/table_row_data.dart';

/// Events for the FlexibleTable
abstract class FlexibleTableEvent extends Equatable {
  const FlexibleTableEvent();

  @override
  List<Object?> get props => [];
}

/// Event to change the current page
class ChangePageEvent extends FlexibleTableEvent {
  final int page;

  const ChangePageEvent(this.page);

  @override
  List<Object?> get props => [page];
}

/// Event to change the number of rows per page
class ChangeRowsPerPageEvent extends FlexibleTableEvent {
  final int rowsPerPage;

  const ChangeRowsPerPageEvent(this.rowsPerPage);

  @override
  List<Object?> get props => [rowsPerPage];
}

/// Event to update the data
class UpdateDataEvent extends FlexibleTableEvent {
  final List<TableRowData> data;

  const UpdateDataEvent(this.data);

  @override
  List<Object?> get props => [data];
}

/// Event to select/deselect a row
class ToggleRowSelectionEvent extends FlexibleTableEvent {
  final String rowId;

  const ToggleRowSelectionEvent(this.rowId);

  @override
  List<Object?> get props => [rowId];
}

/// Event to select/deselect all rows
class ToggleAllRowsSelectionEvent extends FlexibleTableEvent {
  final bool selected;

  const ToggleAllRowsSelectionEvent(this.selected);

  @override
  List<Object?> get props => [selected];
}
