import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:orchestrator/presentation/bloc/auth/auth_bloc.dart';
import 'package:orchestrator/data/repositories/auth_repository.dart' as real;
import 'package:orchestrator/domain/models/user.dart';

class _FakeRepo implements real.AuthRepository {
  @override
  Future<User?> currentUser() async => null;

  @override
  Future<User> login({required String email, required String password}) async {
    if (email == 'a@b.c' && password == 'p') {
      return const User(id: 1, email: 'a@b.c');
    }
    throw Exception('bad');
  }

  @override
  Future<void> logout(int userId) async {}
}

void main() {
  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits authenticated on successful login',
      build: () => AuthBloc(_FakeRepo()),
      act: (b) => b.add(const LoginRequested(email: 'a@b.c', password: 'p')),
      expect: () => [isA<AuthState>(), isA<AuthState>()],
      verify: (b) {
        expect(b.state.user, isNotNull);
      },
    );
  });
}
