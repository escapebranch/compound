import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Calendar Grid Widget
///
/// A transposed calendar grid that displays days of the week
/// vertically and weeks horizontally. Refined for AMOLED-first
/// monochromatic design with proper typography hierarchy.
///
/// Cells for today and past dates are tappable — [onDateTap] is called
/// with the full [DateTime] for the selected day.
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
    final isPast = _isPast(date);
    final isFuture = !isToday && !isPast;
    final isTappable = isToday || isPast;

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
                  // Outer Glow
                  BoxShadow(
                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                  // Professional Shadow for depth
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

    // Wrap tappable cells (today + past) in an InkWell
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
