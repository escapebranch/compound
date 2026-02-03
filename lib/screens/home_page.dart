import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _currentDate = DateTime.now();

  void _changeMonth(int offset) {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background vertical divider line
          Positioned(
            left: 34,
            top: 0,
            bottom: 0,
            child: Container(
              width: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.1, 0.9, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top App Bar / Header Area
                const SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(
                      'Compound',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Expanded Center Area - Calendar Grid
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                    child: CalendarGrid(currentDate: _currentDate),
                  ),
                ),

                // Bottom Area - Month Selector
                SizedBox(
                  height: 80,
                  child: MonthSelector(
                    currentDate: _currentDate,
                    onMonthChanged: _changeMonth,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MonthSelector extends StatefulWidget {
  final DateTime currentDate;
  final ValueChanged<int> onMonthChanged;

  const MonthSelector({
    super.key,
    required this.currentDate,
    required this.onMonthChanged,
  });

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  bool _isMovingForward = true;

  @override
  void didUpdateWidget(MonthSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentDate != oldWidget.currentDate) {
      setState(() {
        _isMovingForward = widget.currentDate.isAfter(oldWidget.currentDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = widget.currentDate;
    final onMonthChanged = widget.onMonthChanged;

    final prevDate = DateTime(currentDate.year, currentDate.month - 1);
    final nextDate = DateTime(currentDate.year, currentDate.month + 1);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Center(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              onMonthChanged(-1);
            } else if (details.primaryVelocity! < 0) {
              onMonthChanged(1);
            }
          },
          child: Container(
            width: 210, // Fixed width to prevent stretching
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: Colors.white.withOpacity(0.12),
                width: 1.0,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Lively Breathing Indicator
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.easeOutCubic,
                    key: ValueKey(currentDate.month),
                    builder: (context, value, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Pulsing Glow
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 40 + (10 * value),
                              height: 12,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  center: const Alignment(0, 1.0),
                                  radius: 0.8,
                                  colors: [
                                    Colors.white.withOpacity(0.2 * value),
                                    Colors.white.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Expanding Laser Bar
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 16 + (8 * value),
                              height: 1.2,
                              margin: const EdgeInsets.only(bottom: 0.5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                  0.3 + (0.7 * value),
                                ),
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(
                                      0.4 * value,
                                    ),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // Navigation Items
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CompactNavButton(
                          icon: Icons.chevron_left,
                          onPressed: () => onMonthChanged(-1),
                        ),
                        // Animated Month Labels
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              final isEntering =
                                  child.key == ValueKey(currentDate.month);

                              Offset beginOffset;
                              if (isEntering) {
                                // New month entering
                                beginOffset = _isMovingForward
                                    ? const Offset(0.3, 0)
                                    : const Offset(-0.3, 0);
                              } else {
                                // Old month exiting
                                beginOffset = _isMovingForward
                                    ? const Offset(-0.3, 0)
                                    : const Offset(0.3, 0);
                              }

                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: beginOffset,
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: Row(
                              key: ValueKey(currentDate.month),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Prev Month
                                SizedBox(
                                  width: 35,
                                  child: Opacity(
                                    opacity: 0.2,
                                    child: Text(
                                      months[prevDate.month - 1].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                // Current Month
                                Container(
                                  width: 65,
                                  alignment: Alignment.center,
                                  child: Text(
                                    months[currentDate.month - 1].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                // Next Month
                                SizedBox(
                                  width: 35,
                                  child: Opacity(
                                    opacity: 0.2,
                                    child: Text(
                                      months[nextDate.month - 1].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _CompactNavButton(
                          icon: Icons.chevron_right,
                          onPressed: () => onMonthChanged(1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CompactNavButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white.withOpacity(0.7), size: 16),
      ),
    );
  }
}

class CalendarGrid extends StatelessWidget {
  final DateTime currentDate;

  const CalendarGrid({super.key, required this.currentDate});

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final weekData = _generateMonthData(currentDate);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: daysOfWeek.map((day) {
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
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Spacer for the vertical line (width 4 + line width 1 + padding 4?)
                  // User said "within a width of size box 4 draw this line"
                  const SizedBox(width: 8),
                  // Dates for this day
                  Expanded(
                    child: Row(
                      children: weekData[day]!.map((date) {
                        return Expanded(
                          child: date == null
                              ? const SizedBox()
                              : Center(
                                  child: Container(
                                    width: 50,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2C2C2E),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      date.toString().padLeft(2, '0'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
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

  Map<String, List<int?>> _generateMonthData(DateTime date) {
    // Generate the matrix of dates for the transposed calendar
    // Rows: Weekdays (MON-SUN)
    // Columns: Weeks in the month

    final int daysInMonth = DateUtils.getDaysInMonth(date.year, date.month);
    final int firstWeekday = DateTime(
      date.year,
      date.month,
      1,
    ).weekday; // 1=Mon, 7=Sun

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

    // We can have up to 6 weeks. Initialize with nulls or push as we go.
    // Let's create a flat structure first then distribute.
    // Actually, calculating the week index is cleaner.

    // Initialize with empty lists
    for (var key in matrix.keys) {
      matrix[key] = List.filled(6, null, growable: true);
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final current = DateTime(date.year, date.month, day);
      final weekday = current.weekday; // 1-7

      // Calculate week index (0-based)
      // Shift day 1 to be relative to the "start of the grid".
      // The grid start is Monday of the first week.
      // If 1st is Monday, offset is 0. If 1st is Thursday, it's 3rd day, so shift +2.
      // Adjusted Week Loop:
      // Week 0: Days 1..X where X is end os week
      final int weekIndex = (day + firstWeekday - 2) ~/ 7;

      if (weekIndex < 6) {
        matrix[dayKeys[weekday]]![weekIndex] = day;
      }
    }

    // Clean up empty columns (weeks) at the end if strict compactness is needed.
    // Check if the last column (index 5) is completely null.
    _trimEmptyColumns(matrix);

    return matrix;
  }

  void _trimEmptyColumns(Map<String, List<int?>> matrix) {
    // Check highest index.
    // We maxed at 6 (indices 0-5).
    // If index 5 is all null, remove it.
    // Then check index 4.

    for (int i = 5; i >= 4; i--) {
      // Check last two potential empty weeks
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
