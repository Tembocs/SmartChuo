import 'package:flutter_bloc/flutter_bloc.dart';
import 'flexible_table_event.dart';
import 'flexible_table_state.dart';

/// BLoC for managing the state of the FlexibleTable
///
/// This handles pagination, data updates, and row selection state.
class FlexibleTableBloc extends Bloc<FlexibleTableEvent, FlexibleTableState> {
  FlexibleTableBloc({List<dynamic>? initialData, int rowsPerPage = 10})
    : super(
        FlexibleTableState.initial(
          data: initialData?.cast(),
          rowsPerPage: rowsPerPage,
        ),
      ) {
    on<ChangePageEvent>(_onChangePage);
    on<ChangeRowsPerPageEvent>(_onChangeRowsPerPage);
    on<UpdateDataEvent>(_onUpdateData);
    on<ToggleRowSelectionEvent>(_onToggleRowSelection);
    on<ToggleAllRowsSelectionEvent>(_onToggleAllRowsSelection);
  }

  /// Handle page change event
  void _onChangePage(ChangePageEvent event, Emitter<FlexibleTableState> emit) {
    if (event.page >= 0 && event.page < state.totalPages) {
      emit(state.copyWith(currentPage: event.page).withRecalculatedDisplay());
    }
  }

  /// Handle rows per page change event
  void _onChangeRowsPerPage(
    ChangeRowsPerPageEvent event,
    Emitter<FlexibleTableState> emit,
  ) {
    emit(
      state
          .copyWith(
            rowsPerPage: event.rowsPerPage,
            currentPage: 0, // Reset to first page
          )
          .withRecalculatedDisplay(),
    );
  }

  /// Handle data update event
  void _onUpdateData(UpdateDataEvent event, Emitter<FlexibleTableState> emit) {
    final newTotalItems = event.data.length;
    final newTotalPages = (newTotalItems / state.rowsPerPage).ceil();
    final newCurrentPage = state.currentPage >= newTotalPages
        ? (newTotalPages - 1).clamp(0, newTotalPages)
        : state.currentPage;

    emit(
      state
          .copyWith(
            allData: event.data,
            totalItems: newTotalItems,
            totalPages: newTotalPages,
            currentPage: newCurrentPage,
          )
          .withRecalculatedDisplay(),
    );
  }

  /// Handle row selection toggle event
  void _onToggleRowSelection(
    ToggleRowSelectionEvent event,
    Emitter<FlexibleTableState> emit,
  ) {
    final selectedIds = Set<String>.from(state.selectedRowIds);
    if (selectedIds.contains(event.rowId)) {
      selectedIds.remove(event.rowId);
    } else {
      selectedIds.add(event.rowId);
    }
    emit(state.copyWith(selectedRowIds: selectedIds));
  }

  /// Handle select/deselect all rows event
  void _onToggleAllRowsSelection(
    ToggleAllRowsSelectionEvent event,
    Emitter<FlexibleTableState> emit,
  ) {
    if (event.selected) {
      final allIds = state.allData
          .where((row) => row.id != null)
          .map((row) => row.id!)
          .toSet();
      emit(state.copyWith(selectedRowIds: allIds));
    } else {
      emit(state.copyWith(selectedRowIds: {}));
    }
  }
}
