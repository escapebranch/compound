import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// App Settings Table
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get installDate => dateTime()();
}

@DriftDatabase(tables: [AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Get the installation date, or set it if not exists
  Future<DateTime> getOrSetInstallDate() async {
    final existing = await select(appSettings).getSingleOrNull();
    if (existing != null) {
      return existing.installDate;
    }

    // First launch - store current date as install date
    final now = DateTime.now();
    await into(
      appSettings,
    ).insert(AppSettingsCompanion.insert(installDate: now));
    return now;
  }

  /// Get just the install year
  Future<int> getInstallYear() async {
    final installDate = await getOrSetInstallDate();
    return installDate.year;
  }

  /// Get just the install month
  Future<int> getInstallMonth() async {
    final installDate = await getOrSetInstallDate();
    return installDate.month;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'compound.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
