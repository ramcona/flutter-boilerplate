import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/example_table.dart';

part 'example_dao.g.dart';

// ---------------------------------------------------------------------------
// EXAMPLE DAO
// ---------------------------------------------------------------------------
// One DAO per table group. Keep queries here — do NOT put business logic.
// Business logic (e.g., UUID generation, validation) goes in the Repository.
// ---------------------------------------------------------------------------

@DriftAccessor(tables: [ExampleTable])
class ExampleDao extends DatabaseAccessor<AppDatabase>
    with _$ExampleDaoMixin {
  ExampleDao(super.db);

  /// Live stream of all active items, newest first.
  Stream<List<ExampleItem>> watchAll() =>
      (select(exampleTable)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  /// Fetch a single item by its UUID (nullable one-shot).
  Future<ExampleItem?> getById(String id) =>
      (select(exampleTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// Insert a new row.
  Future<void> insertItem(ExampleTableCompanion entry) =>
      into(exampleTable).insert(entry);

  /// Replace an existing row (full update).
  Future<void> updateItem(ExampleTableCompanion entry) =>
      update(exampleTable).replace(entry);

  /// Hard-delete a row by UUID.
  Future<void> deleteById(String id) =>
      (delete(exampleTable)..where((t) => t.id.equals(id))).go();
}
