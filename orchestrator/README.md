# Orchestrator (SmartChuo)

A Flutter-based orchestrator app that provides a shared login page and serves as the entry point for the SmartChuo suite.

## What’s inside

- State management: flutter_bloc + equatable
- Dependency injection: get_it
- Local database: sqlite3 (+ sqlite3_flutter_libs)
- Simple auth repository with SHA-256 password hashing and session rows
- Pages: Splash → Login → Home

Default credentials (seeded on first run):
- Email: `admin@smartchuo.local`
- Password: `admin123`

## How to run

From this directory:

1. Fetch packages and analyze
	- The analyzer is clean for this package and scoped runs are recommended in a monorepo.
2. Run the app
	- Choose your target (mobile, web, or desktop) and run as usual with Flutter tooling.

Notes:
- The SQLite database file is created in the platform’s application documents directory as `orchestrator.db`.

## Architecture overview

- `lib/core/di/injector.dart`: get_it registrations (DatabaseService, AuthRepository, AuthBloc). Call `configureDependencies()` before `runApp`.
- `lib/data/db/database_service.dart`: SQLite setup (tables: `users`, `sessions`) and seeding of the default admin. Uses SHA-256 for the seed password to match login verification.
- `lib/data/repositories/auth_repository.dart`: Login/logout/currentUser methods. Hashes input password and manages a simple session token.
- `lib/presentation/bloc/auth/*`: AuthBloc with events (AppStarted, LoginRequested, LogoutRequested) and states (unknown/loading/authenticated/unauthenticated/failure).
- `lib/presentation/pages/*`: Splash triggers `AppStarted`, Login shows the form, Home shows the current user and allows logout.
- `lib/main.dart`: Initializes DI, provides the bloc, sets up routes, and listens to AuthState to navigate.

## Conventions (per AGENTS.md)

- Use flutter_bloc + equatable for state management.
- Use get_it for DI.
- Use sqlite3 for local persistence.
- Keep documentation comments above the responsible code (applied across core files here).
- Don’t litter the repo root; all app files live under this package.

## Testing

- Basic bloc test provided in `test/auth_bloc_test.dart`.
- You can add more tests around failure states and logout/session behavior.

## Troubleshooting

- If you see unrelated analyzer errors from other packages in the monorepo, run analyzer/tests scoped to this package directory.
- If the default admin login fails, delete the `orchestrator.db` file from the app’s documents directory and relaunch (it will re-seed).
