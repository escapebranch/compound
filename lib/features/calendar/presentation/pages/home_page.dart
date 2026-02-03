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
        children: [
          // Top App Bar / Header Area
          Container(
            height: 120,
            padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Compound',
                  style: textTheme.headlineMedium?.copyWith(
                    fontVariations: [const FontVariation('wght', 700)],
                    letterSpacing: -0.8,
                    fontSize: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.menu_rounded,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    size: 26,
                  ),
                ),
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

                    // Month Selector
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
}
