import 'dart:math';
import 'package:flutter/material.dart';
import 'package:compound/core/data/app_database.dart';
import 'package:drift/drift.dart';

class MockDataGenerator {
  static Future<void> generateMockData(AppDatabase db) async {
    // 1. Flush existing data first to have a clean slate
    await db.flushDatabase();

    // 2. Set the install date to May 1st, 2026
    // This is important because the UI might restrict navigation before install date
    await db.into(db.appSettings).insert(AppSettingsCompanion.insert(
      installDate: DateTime(2026, 5, 1),
    ));

    // 3. Define habits with specific 24h contiguous schedule
    final habitConfigs = [
      ('Sleep', Icons.nightlight_round, '8 hours', 0, 8),
      ('Meditation', Icons.self_improvement_rounded, '1 hour', 8, 9),
      ('Reading', Icons.menu_book_rounded, '1 hour', 9, 10),
      ('Deep Work', Icons.work_outline_rounded, '3 hours', 10, 13),
      ('Lunch & Rest', Icons.restaurant_rounded, '1 hour', 13, 14),
      ('Coding', Icons.code, '3 hours', 14, 17),
      ('Exercise', Icons.directions_run, '1 hour', 17, 18),
      ('Learning', Icons.school_rounded, '2 hours', 18, 20),
      ('Dinner', Icons.flatware_rounded, '1 hour', 20, 21),
      ('Wind Down', Icons.bedtime_outlined, '3 hours', 21, 24),
    ];

    final startOfMay = DateTime(2026, 5, 1);
    final yesterday = DateTime(2026, 5, 12);

    final random = Random();

    for (final config in habitConfigs) {
      final habitId = await db.createHabit(
        HabitsCompanion.insert(
          name: config.$1,
          iconCodePoint: config.$2.codePoint,
          goal: Value(config.$3),
          createdAt: startOfMay,
        ),
        // Schedule for every day of the week
        List.generate(7, (index) => HabitTimesCompanion.insert(
          habitId: 0, // placeholder
          dayOfWeek: index + 1,
          startHour: config.$4,
          startMinute: 0,
          endHour: config.$5 == 24 ? 23 : config.$5,
          endMinute: config.$5 == 24 ? 59 : 0,
        )),
      );

      // Get the times created for this habit to use their IDs
      final times = await (db.select(db.habitTimes)..where((t) => t.habitId.equals(habitId))).get();

      // 4. Generate logs from May 1 to May 12
      for (int i = 0; i <= yesterday.difference(startOfMay).inDays; i++) {
        final date = startOfMay.add(Duration(days: i));
        final dayOfWeek = date.weekday;
        
        final timeForDay = times.firstWhere((t) => t.dayOfWeek == dayOfWeek);

        // 90% completion rate
        final isCompleted = random.nextDouble() < 0.9;
        if (isCompleted) {
          // Emotions: 1: Orange, 2: Yellow, 3: Green
          final emotion = random.nextInt(3) + 1; 
          await db.toggleHabitLog(habitId, timeForDay.id, date, true, emotion: emotion);
        } else {
          await db.toggleHabitLog(habitId, timeForDay.id, date, false);
        }
      }
    }
  }
}
