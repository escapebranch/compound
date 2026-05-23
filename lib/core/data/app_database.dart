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

class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get goal => text().nullable()();
  IntColumn get iconCodePoint => integer()();
  DateTimeColumn get createdAt => dateTime()();
}

class HabitTimes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id)();
  IntColumn get dayOfWeek => integer()(); // 1 = Monday, 7 = Sunday
  IntColumn get startHour => integer()();
  IntColumn get startMinute => integer()();
  IntColumn get endHour => integer()();
  IntColumn get endMinute => integer()();
}

class HabitLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id)();
  IntColumn get habitTimeId => integer().references(HabitTimes, #id).nullable()();
  DateTimeColumn get date => dateTime()(); // Only the date part is used
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  IntColumn get emotion => integer().nullable()(); // 1: Orange, 2: Yellow, 3: Green
}

@DriftDatabase(tables: [AppSettings, Habits, HabitTimes, HabitLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(habits);
          await m.createTable(habitTimes);
        }
        if (from < 3) {
          await m.createTable(habitLogs);
        }
        if (from < 4) {
          await m.addColumn(habitLogs, habitLogs.emotion);
        }
      },
    );
  }

  // --- Habits CRUD ---

  Future<int> createHabit(HabitsCompanion habit, List<HabitTimesCompanion> times) async {
    return transaction(() async {
      final habitId = await into(habits).insert(habit);
      for (final time in times) {
        await into(habitTimes).insert(time.copyWith(habitId: Value(habitId)));
      }
      return habitId;
    });
  }

  Future<List<Habit>> getAllHabits() => select(habits).get();

  Stream<List<HabitWithTimes>> watchHabitsWithTimes() {
    return select(habits).watch().map((habits) {
      return habits.map((habit) {
        final times = select(habitTimes)..where((t) => t.habitId.equals(habit.id));
        return HabitWithTimes(habit, times.get());
      }).toList();
    }).asyncMap((list) async {
      final result = <HabitWithTimes>[];
      for (final item in list) {
        final times = await item.timesFuture;
        result.add(HabitWithTimes(item.habit, Future.value(times)));
      }
      return result;
    });
  }

  Future<List<HabitWithTimes>> getHabitsForDay(int dayOfWeek) async {
    final habitIdsWithTimes = await (select(habitTimes)..where((t) => t.dayOfWeek.equals(dayOfWeek))).get();
    final habitIds = habitIdsWithTimes.map((t) => t.habitId).toSet().toList();
    
    final habitsList = await (select(habits)..where((h) => h.id.isIn(habitIds))).get();
    
    final result = <HabitWithTimes>[];
    for (final habit in habitsList) {
      final times = habitIdsWithTimes.where((t) => t.habitId == habit.id).toList();
      result.add(HabitWithTimes(habit, Future.value(times)));
    }
    return result;
  }

  // --- Logs ---

  Future<void> toggleHabitLog(int habitId, int? habitTimeId, DateTime date, bool completed, {int? emotion}) async {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final query = select(habitLogs)
      ..where((l) => l.habitId.equals(habitId))
      ..where((l) => l.date.equals(dateOnly));
    
    if (habitTimeId != null) {
      query.where((l) => l.habitTimeId.equals(habitTimeId));
    } else {
      query.where((l) => l.habitTimeId.isNull());
    }

    final existing = await query.getSingleOrNull();
    if (existing != null) {
      await (update(habitLogs)..where((l) => l.id.equals(existing.id)))
          .write(HabitLogsCompanion(
            completed: Value(completed),
            emotion: Value(completed ? (emotion ?? existing.emotion) : null),
          ));
    } else {
      await into(habitLogs).insert(HabitLogsCompanion.insert(
        habitId: habitId,
        habitTimeId: Value(habitTimeId),
        date: dateOnly,
        completed: Value(completed),
        emotion: Value(completed ? emotion : null),
      ));
    }
  }

  Future<List<HabitLog>> getLogsForDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return (select(habitLogs)..where((l) => l.date.equals(dateOnly))).get();
  }

  Future<List<HabitLogWithTime>> getLogsWithTimesForMonth(int year, int month) async {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 0);
    
    final logs = await (select(habitLogs)
          ..where((l) => l.date.isBetweenValues(startOfMonth, endOfMonth))
          ..where((l) => l.completed.equals(true)))
        .get();
        
    final habitTimeIds = logs.map((l) => l.habitTimeId).whereType<int>().toSet().toList();
    final times = await (select(habitTimes)..where((t) => t.id.isIn(habitTimeIds))).get();
    
    return logs.map((log) {
      final time = times.firstWhere((t) => t.id == log.habitTimeId);
      return HabitLogWithTime(log, time);
    }).toList();
  }

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

  /// Delete all data from the database
  Future<void> flushDatabase() async {
    await transaction(() async {
      await delete(habitLogs).go();
      await delete(habitTimes).go();
      await delete(habits).go();
      await delete(appSettings).go();
    });
  }
}

class HabitWithTimes {
  final Habit habit;
  final Future<List<HabitTime>> timesFuture;

  HabitWithTimes(this.habit, this.timesFuture);
}

class HabitLogWithTime {
  final HabitLog log;
  final HabitTime time;
  HabitLogWithTime(this.log, this.time);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'compound.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
