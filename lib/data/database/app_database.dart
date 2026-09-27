import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/example_table.dart';
import 'daos/example_dao.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// APP DATABASE
// ---------------------------------------------------------------------------
// Add your tables to the `tables` list and DAOs to `daos`.
// Run `flutter pub run build_runner build` after any schema change.
// Bump [schemaVersion] and add a migration in [migration] for upgrades.
// ---------------------------------------------------------------------------

@DriftDatabase(
  tables: [ExampleTable],
  daos: [ExampleDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Example migration for version 2:
        // if (from < 2) {
        //   await m.addColumn(exampleTable, exampleTable.newColumn);
        // }
      },
    );
  }
}

/// Opens the SQLite database from the device's documents directory.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
