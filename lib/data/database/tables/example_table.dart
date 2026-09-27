import 'package:drift/drift.dart';

// ---------------------------------------------------------------------------
// EXAMPLE TABLE
// ---------------------------------------------------------------------------
// Rename this file and class to match your domain model (e.g., tasks_table.dart).
// Column types: text(), integer(), boolean(), dateTime(), blob(), real().
// ---------------------------------------------------------------------------

class ExampleTable extends Table {
  /// Primary key — UUID string generated in the repository layer.
  TextColumn get id => text()();

  /// Human-readable label.
  TextColumn get title => text()();

  /// Optional description.
  TextColumn get description => text().nullable()();

  /// Whether the item is active/visible.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// Creation timestamp (stored as UTC milliseconds since epoch).
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
