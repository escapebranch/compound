import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:compound/main.dart';
import 'package:compound/core/data/app_database.dart';

/// Calendar Grid Widget
class CalendarGrid extends StatelessWidget {
  final DateTime currentDate;

  /// Called when the user taps a past or today's cell.
  final void Function(DateTime date)? onDateTap;

  const CalendarGrid({super.key, required this.currentDate, this.onDateTap});

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

    return FutureBuilder<List<HabitLogWithTime>>(
      future: database.getLogsWithTimesForMonth(currentDate.year, currentDate.month),
      builder: (context, snapshot) {
        final logs = snapshot.data ?? [];
        
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
                      // Day Label
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
                        child: RotatedBox(
                          quarterTurns: 1,
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
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Dates for this day
                      Expanded(
                        child: Row(
                          children: weekData[day]!.map((date) {
                            if (date == null) return const Expanded(child: SizedBox());
                            
                            final dayLogs = logs.where((l) => l.log.date.day == date).toList();
                            
                            return Expanded(
                              child: _buildDateCell(
                                date: date,
                                colorScheme: colorScheme,
                                textTheme: textTheme,
                                dayLogs: dayLogs,
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
      },
    );
  }

  Widget _buildDateCell({
    required int date,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required List<HabitLogWithTime> dayLogs,
  }) {
    final isToday = _isToday(date);
    final isPast = _isPast(date);
    final isFuture = !isToday && !isPast;
    final isTappable = isToday || isPast;

    final segments = dayLogs.map((hl) {
      final startMinutes = hl.time.startHour * 60 + hl.time.startMinute;
      final endMinutes = hl.time.endHour * 60 + hl.time.endMinute;
      return _EmotionSegment(
        startPercent: startMinutes / 1440.0,
        endPercent: endMinutes / 1440.0,
        emotion: hl.log.emotion ?? 2,
      );
    }).toList();

    final cell = Center(
      child: Container(
        width: isToday ? 54 : 50,
        height: isToday ? 64 : 60,
        decoration: BoxDecoration(
          color: isToday
              ? colorScheme.surface
              : isFuture
              ? colorScheme.onSurface.withValues(alpha: 0.03)
              : colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(isToday ? 14 : 12),
          border: Border.all(
            color: isToday
                ? colorScheme.onSurface
                : isFuture
                ? colorScheme.outline.withValues(alpha: 0.05)
                : colorScheme.outline.withValues(alpha: 0.08),
            width: isToday ? 1.5 : 0.5,
          ),
          boxShadow: isToday
              ? [
                  BoxShadow(
                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            if (!isFuture)
              Positioned.fill(
                child: CustomPaint(
                  painter: _ProportionalBackgroundPainter(
                    segments: segments,
                    isFaded: isPast,
                  ),
                ),
              ),
            if (isFuture)
              Positioned.fill(
                child: CustomPaint(
                  painter: _StripedPainter(
                    color: colorScheme.onSurface.withValues(alpha: 0.06),
                  ),
                ),
              ),
            Center(
              child: Text(
                date.toString().padLeft(2, '0'),
                style: textTheme.titleLarge?.copyWith(
                  color: isToday
                      ? colorScheme.onSurface
                      : isFuture
                      ? colorScheme.onSurface.withValues(alpha: 0.2)
                      : colorScheme.onSurface.withValues(alpha: 0.4),
                  fontVariations: [FontVariation('wght', isToday ? 700 : 500)],
                  fontSize: isToday ? 22 : 20,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (!isTappable) return cell;

    return _TappableDateCell(
      onTap: () {
        HapticFeedback.selectionClick();
        onDateTap?.call(DateTime(currentDate.year, currentDate.month, date));
      },
      child: cell,
    );
  }

  bool _isToday(int date) {
    final now = DateTime.now();
    return now.year == currentDate.year &&
        now.month == currentDate.month &&
        now.day == date;
  }

  bool _isPast(int date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cellDate = DateTime(currentDate.year, currentDate.month, date);
    return cellDate.isBefore(today);
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

class _EmotionSegment {
  final double startPercent;
  final double endPercent;
  final int emotion;
  _EmotionSegment({required this.startPercent, required this.endPercent, required this.emotion});
}

class _ProportionalBackgroundPainter extends CustomPainter {
  final List<_EmotionSegment> segments;
  final bool isFaded;

  _ProportionalBackgroundPainter({
    required this.segments,
    required this.isFaded,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final opacity = isFaded ? 0.3 : 1.0;
    
    for (var segment in segments) {
      final top = segment.startPercent * size.height;
      final bottom = segment.endPercent * size.height;
      
      Color color;
      switch (segment.emotion) {
        case 1: color = Colors.orange; break;
        case 2: color = Colors.yellow; break;
        case 3: color = Colors.green; break;
        default: color = Colors.transparent;
      }

      if (color != Colors.transparent) {
        final paint = Paint()..color = color.withValues(alpha: 0.6 * opacity);
        canvas.drawRect(Rect.fromLTRB(0, top, size.width, bottom), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ProportionalBackgroundPainter oldDelegate) {
    return oldDelegate.segments != segments || oldDelegate.isFaded != isFaded;
  }
}

/// A subtle ink-splash wrapper for tappable date cells.
class _TappableDateCell extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _TappableDateCell({required this.child, required this.onTap});

  @override
  State<_TappableDateCell> createState() => _TappableDateCellState();
}

class _TappableDateCellState extends State<_TappableDateCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: widget.child,
      ),
    );
  }
}

class _StripedPainter extends CustomPainter {
  final Color color;

  _StripedPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;

    const gap = 8.0;
    for (double i = -size.height; i < size.width; i += gap) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
