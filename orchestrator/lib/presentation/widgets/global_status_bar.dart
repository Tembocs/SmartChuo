// GlobalStatusBar: lightweight status line shown at bottom of authenticated UI.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:orchestrator/presentation/bloc/auth/auth_bloc.dart';

class GlobalStatusBar extends StatelessWidget {
  const GlobalStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final user = state.user;
                  return Text(
                    user != null
                        ? 'Logged in as ${user.email}'
                        : 'Not logged in',
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                },
              ),
            ),
            Text(
              '${now.format(context)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
