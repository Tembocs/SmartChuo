// HomePage shown after successful login.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:orchestrator/presentation/bloc/auth/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartChuo Orchestrator'),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<AuthBloc>().add(const LogoutRequested()),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user = state.user;
            return Text(
              user != null ? 'Welcome, ${user.email}!' : 'Not logged in',
            );
          },
        ),
      ),
    );
  }
}
