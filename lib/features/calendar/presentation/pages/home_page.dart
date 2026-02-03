import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

/// Home Page
///
/// The main calendar view page displaying a transposed calendar grid
/// with month navigation controls. Refined for AMOLED-first design.
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top App Bar / Header Area
          Container(
            padding: const EdgeInsets.only(
              top: 48,
              left: 12,
              right: 12,
              bottom: 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Compound',
                      style: textTheme.headlineMedium?.copyWith(
                        fontVariations: [const FontVariation('wght', 700)],
                        letterSpacing: -0.5,
                        fontSize: 24,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.menu_rounded,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        size: 24,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Month (Text) + Year (Picker) Row + Year Progress
                Row(
                  children: [
                    Text(
                      _getMonthName(_currentDate.month),
                      style: textTheme.titleMedium?.copyWith(
                        fontVariations: [const FontVariation('wght', 500)],
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        letterSpacing: 0.2,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    YearPickerButton(
                      currentYear: _currentDate.year,
                      onYearSelected: (newYear) {
                        setState(() {
                          _currentDate = DateTime(
                            newYear,
                            _currentDate.month,
                            _currentDate.day,
                          );
                        });
                      },
                    ),
                    const Spacer(),
                    // Year Progress Indicator
                    _buildYearProgress(colorScheme, textTheme),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Subtle Horizontal Divider
          Container(
            height: 0.5,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.onSurface.withValues(alpha: 0.0),
                  colorScheme.onSurface.withValues(alpha: 0.08),
                  colorScheme.onSurface.withValues(alpha: 0.08),
                  colorScheme.onSurface.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.15, 0.85, 1.0],
              ),
            ),
          ),

          // Main Content Area
          Expanded(
            child: Stack(
              children: [
                // Subtle vertical divider line
                Positioned(
                  left: 34,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorScheme.onSurface.withValues(alpha: 0.08),
                          colorScheme.onSurface.withValues(alpha: 0.08),
                          colorScheme.onSurface.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.8, 1.0],
                      ),
                    ),
                  ),
                ),

                // Content
                Column(
                  children: [
                    // Calendar Grid
                    Expanded(
                      flex: 8,
                      child: Container(
                        padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                        child: CalendarGrid(currentDate: _currentDate),
                      ),
                    ),

                    // Month Selector (Keep for quick navigation)
                    SizedBox(
                      height: 80,
                      child: MonthSelector(
                        currentDate: _currentDate,
                        onMonthChanged: _changeMonth,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  Widget _buildYearProgress(ColorScheme colorScheme, TextTheme textTheme) {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, 12, 31);
    final totalDays = endOfYear.difference(startOfYear).inDays + 1;
    final dayOfYear = now.difference(startOfYear).inDays + 1;
    final progress = dayOfYear / totalDays;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Day/Total Text
        Text(
          '$dayOfYear',
          style: textTheme.bodyMedium?.copyWith(
            fontVariations: [const FontVariation('wght', 600)],
            color: colorScheme.onSurface,
            fontSize: 14,
          ),
        ),
        Text(
          '/$totalDays',
          style: textTheme.bodyMedium?.copyWith(
            fontVariations: [const FontVariation('wght', 400)],
            color: colorScheme.onSurface.withValues(alpha: 0.4),
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 10),
        // Circular Progress
        SizedBox(
          width: 28,
          height: 28,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Circle
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 3,
                strokeCap: StrokeCap.round,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(
                  colorScheme.onSurface.withValues(alpha: 0.08),
                ),
              ),
              // Progress Circle
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 3,
                strokeCap: StrokeCap.round,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(
                  colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
