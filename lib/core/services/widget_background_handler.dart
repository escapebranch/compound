import 'package:home_widget/home_widget.dart';
import 'package:compound/core/data/app_database.dart';
import 'package:compound/core/services/widget_sync_service.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
  if (uri?.host == 'log_habit') {
    final habitId = int.tryParse(uri?.queryParameters['habitId'] ?? '');
    final habitTimeId = int.tryParse(uri?.queryParameters['habitTimeId'] ?? '');
    final emotion = int.tryParse(uri?.queryParameters['emotion'] ?? '');

    if (habitId != null && emotion != null) {
      final db = AppDatabase();
      await db.toggleHabitLog(habitId, habitTimeId, DateTime.now(), true, emotion: emotion);
      await WidgetSyncService.syncTimeline(db);
      await db.close();
    }
  }
}
