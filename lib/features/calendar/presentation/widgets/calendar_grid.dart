import 'dart:ui';
import 'package:flutter/material.dart';

/// Calendar Grid Widget
///
/// A transposed calendar grid that displays days of the week
/// vertically and weeks horizontally. Refined for AMOLED-first
/// monochromatic design with proper typography hierarchy.
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
            return Container(
              height: 75,
              margin: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  // Day Label - Matching date cell styling
                  Container(
                    width: 30,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.05),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.06),
                        width: 0.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Transform.rotate(
                      angle: 1.57,
                      child: Text(
                        day,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.6,
                          ),
                          fontVariations: [const FontVariation('wght', 500)],
                          letterSpacing: 1.0,
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
              : colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: isToday
              ? null
              : Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.08),
                  width: 0.5,
                ),
          boxShadow: isToday
              ? [
                  BoxShadow(
                    color: colorScheme.onSurface.withValues(alpha: 0.15),
                    blurRadius: 16,
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
            fontVariations: [FontVariation('wght', isToday ? 700 : 500)],
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
