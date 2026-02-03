import 'dart:ui';
import 'package:flutter/material.dart';

/// Calendar Grid Widget
///
/// A transposed calendar grid that displays days of the week
/// vertically and weeks horizontally. Each day cell is a
/// rounded container showing the date.
class CalendarGrid extends StatelessWidget {
  final DateTime currentDate;

  const CalendarGrid({super.key, required this.currentDate});

  static const List<String> _daysOfWeek = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final weekData = _generateMonthData(currentDate);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _daysOfWeek.map((day) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                children: [
                  // Day Label - Rotated
                  Transform.rotate(
                    angle: 1.57, // ~90 degrees
                    child: SizedBox(
                      width: 30,
                      child: Text(
                        day,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontVariations: [const FontVariation('wght', 700)],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Dates for this day
                  Expanded(
                    child: Row(
                      children: weekData[day]!.map((date) {
                        return Expanded(
                          child: date == null
                              ? const SizedBox()
                              : _buildDateCell(
                                  date: date,
                                  colorScheme: colorScheme,
                                  textTheme: textTheme,
                                ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildDateCell({
    required int date,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final isToday = _isToday(date);

    return Center(
      child: Container(
        width: 50,
        height: 60,
        decoration: BoxDecoration(
          color: isToday
              ? colorScheme.onSurface
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: isToday
              ? null
              : Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
          boxShadow: isToday
              ? [
                  BoxShadow(
                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          date.toString().padLeft(2, '0'),
          style: textTheme.titleLarge?.copyWith(
            color: isToday ? colorScheme.surface : colorScheme.onSurface,
            fontVariations: [const FontVariation('wght', 900)],
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  bool _isToday(int date) {
    final now = DateTime.now();
    return now.year == currentDate.year &&
        now.month == currentDate.month &&
        now.day == date;
  }

  Map<String, List<int?>> _generateMonthData(DateTime date) {
    final int daysInMonth = DateUtils.getDaysInMonth(date.year, date.month);
    final int firstWeekday = DateTime(date.year, date.month, 1).weekday;

    final Map<String, List<int?>> matrix = {
      'MON': [],
      'TUE': [],
      'WED': [],
      'THU': [],
      'FRI': [],
      'SAT': [],
      'SUN': [],
    };

    final dayKeys = ['', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    for (var key in matrix.keys) {
      matrix[key] = List.filled(6, null, growable: true);
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final current = DateTime(date.year, date.month, day);
      final weekday = current.weekday;
      final int weekIndex = (day + firstWeekday - 2) ~/ 7;

      if (weekIndex < 6) {
        matrix[dayKeys[weekday]]![weekIndex] = day;
      }
    }

    _trimEmptyColumns(matrix);

    return matrix;
  }

  void _trimEmptyColumns(Map<String, List<int?>> matrix) {
    for (int i = 5; i >= 4; i--) {
      bool allNull = true;
      for (var key in matrix.keys) {
        if (matrix[key]!.length > i && matrix[key]![i] != null) {
          allNull = false;
          break;
        }
      }
      if (allNull) {
        for (var key in matrix.keys) {
          if (matrix[key]!.length > i) {
            matrix[key]!.removeAt(i);
          }
        }
      }
    }
  }
}
