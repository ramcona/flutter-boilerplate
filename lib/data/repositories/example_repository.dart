import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../database/daos/example_dao.dart';

// ---------------------------------------------------------------------------
// EXAMPLE REPOSITORY
// ---------------------------------------------------------------------------
// Repositories are the single source of truth for each domain entity.
// They own UUID generation, validation, and data-layer orchestration.
// They NEVER import Flutter widgets or providers.
// ---------------------------------------------------------------------------

class ExampleRepository {
  ExampleRepository(this._dao);

  final ExampleDao _dao;
  static const _uuid = Uuid();

  /// Live stream of all items.
  Stream<List<ExampleItem>> watchAll() => _dao.watchAll();

  /// Fetch a single item by ID (one-shot).
  Future<ExampleItem?> getById(String id) => _dao.getById(id);

  /// Create a new item.
  Future<void> add(String title, {String? description}) async {
    final entry = ExampleTableCompanion.insert(
      id: _uuid.v4(),
      title: title,
      description: Value(description),
    );
    await _dao.insertItem(entry);
  }

  /// Update an existing item.
  Future<void> update(ExampleItem item) async {
    await _dao.updateItem(item.toCompanion(true));
  }

  /// Delete an item by UUID.
  Future<void> delete(String id) async {
    await _dao.deleteById(id);
  }
}
