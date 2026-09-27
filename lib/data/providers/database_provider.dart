import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../repositories/example_repository.dart';

// ---------------------------------------------------------------------------
// DATABASE & REPOSITORY PROVIDERS
// ---------------------------------------------------------------------------
// Add one Provider<XxxRepository> for each repository you create.
// All providers read from `databaseProvider` to share a single DB connection.
// ---------------------------------------------------------------------------

/// Singleton database instance. Closed automatically when provider is disposed.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Example repository provider — replace / duplicate for each entity.
final exampleRepositoryProvider = Provider<ExampleRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ExampleRepository(db.exampleDao);
});
