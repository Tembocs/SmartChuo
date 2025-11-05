// Dependency injection setup using get_it.
// Registers services, repositories, and blocs used across the app.
// Call configureDependencies() before runApp in main.dart.
import 'package:get_it/get_it.dart';

import '../../data/db/database_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Register the database service as a lazy singleton
  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService());

  // Initialize database before using it
  await getIt<DatabaseService>().init();

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(getIt()));

  // Blocs
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt()));
}
