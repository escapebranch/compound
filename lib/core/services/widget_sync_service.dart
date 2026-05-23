import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:compound/core/data/app_database.dart';
import 'package:compound/main.dart';

class WidgetSyncService {
  static const String _groupId = 'group.com.example.compound'; // Replace with your actual App Group ID
  static const String _androidWidgetName = 'CompoundWidgetProvider';
  static const String _iosWidgetName = 'CompoundWidget';

  static Future<void> syncTimeline([AppDatabase? db]) async {
    await HomeWidget.setAppGroupId(_groupId);
    final effectiveDb = db ?? database;
    final now = DateTime.now();
    final habitsWithTimes = await effectiveDb.getHabitsForDay(now.weekday);
    final logs = await effectiveDb.getLogsForDate(now);

    final List<Map<String, dynamic>> timelineData = [];

    for (var h in habitsWithTimes) {
      final times = await h.timesFuture;
      for (var t in times) {
        if (t.dayOfWeek == now.weekday) {
          final log = logs.where((l) => l.habitId == h.habit.id && l.habitTimeId == t.id && l.completed).firstOrNull;
          
          timelineData.add({
            'habitId': h.habit.id,
            'habitTimeId': t.id,
            'name': h.habit.name,
            'iconCodePoint': h.habit.iconCodePoint,
            'startHour': t.startHour,
            'startMinute': t.startMinute,
            'endHour': t.endHour,
            'endMinute': t.endMinute,
            'isCompleted': log != null,
            'emotion': log?.emotion,
          });
        }
      }
    }

    // Sort by start time
    timelineData.sort((a, b) {
      final aTime = a['startHour'] * 60 + a['startMinute'];
      final bTime = b['startHour'] * 60 + b['startMinute'];
      return aTime.compareTo(bTime);
    });

    final jsonString = jsonEncode(timelineData);

    await HomeWidget.saveWidgetData<String>('timeline_data', jsonString);
    await HomeWidget.updateWidget(
      name: _androidWidgetName,
      iOSName: _iosWidgetName,
    );
  }
}
