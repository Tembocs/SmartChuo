// AuthBloc coordinates authentication flow between UI and AuthRepository.
// States are: unknown (initial), authenticated(user), unauthenticated(error?).
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:orchestrator/domain/models/user.dart';
import 'package:orchestrator/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo) : super(AuthState.unknown()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _repo;

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    final user = await _repo.currentUser();
    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(AuthState.unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    try {
      final user = await _repo.login(
        email: event.email,
        password: event.password,
      );
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.failure(e.toString()));
      emit(AuthState.unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final current = state;
    if (current.user != null) {
      await _repo.logout(current.user!.id);
    }
    emit(AuthState.unauthenticated());
  }
}
