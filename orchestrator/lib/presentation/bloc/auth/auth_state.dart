part of 'auth_bloc.dart';

/// Authentication states used by AuthBloc.
class AuthState extends Equatable {
  final bool isLoading;
  final User? user;
  final String? error;

  const AuthState._({this.isLoading = false, this.user, this.error});

  factory AuthState.unknown() => const AuthState._();
  factory AuthState.loading() => const AuthState._(isLoading: true);
  factory AuthState.unauthenticated() => const AuthState._(user: null);
  factory AuthState.failure(String error) => AuthState._(error: error);
  factory AuthState.authenticated(User u) => AuthState._(user: u);

  @override
  List<Object?> get props => [isLoading, user, error];
}
