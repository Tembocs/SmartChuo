// AppSidebar: minimal vertical navigation for authenticated area.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:orchestrator/presentation/bloc/auth/auth_bloc.dart';

/// Sidebar with basic navigation and logout action.
class AppSidebar extends StatelessWidget {
  final void Function(String path) onNavigate;

  const AppSidebar({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.dashboard,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'SmartChuo',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () => onNavigate('/home'),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () =>
                  context.read<AuthBloc>().add(const LogoutRequested()),
            ),
          ],
        ),
      ),
    );
  }
}
