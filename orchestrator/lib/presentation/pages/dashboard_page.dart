// DashboardPage: placeholder home content shown inside AppShell.
import 'package:flutter/material.dart';

import 'package:orchestrator/presentation/widgets/app_shell.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      child: Center(
        child: Text(
          'Dashboard',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
