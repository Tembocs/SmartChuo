// AppShell: shared scaffold for authenticated area with sidebar and status bar.
// Inspired by `guest_mngt` shell; provides a persistent layout.
import 'package:flutter/material.dart';
import 'global_status_bar.dart';
import 'sidebar.dart';

/// AppShell composes the main authenticated layout: sidebar + content + status.
class AppShell extends StatelessWidget {
  /// The page content to show in the main area.
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Main row with sidebar and content
          Expanded(
            child: Row(
              children: [
                AppSidebar(
                  onNavigate: (path) {
                    // For now, use imperative navigation via named routes.
                    if (ModalRoute.of(context)?.settings.name != path) {
                      Navigator.of(context).pushReplacementNamed(path);
                    }
                  },
                ),
                // Content area
                Expanded(child: child),
              ],
            ),
          ),
          // Global status bar at bottom
          const GlobalStatusBar(),
        ],
      ),
    );
  }
}
