import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

/// Home Page
///
/// The main calendar view page displaying a transposed calendar grid
/// with month navigation controls.
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
                    colorScheme.onSurface.withValues(alpha: 0.0),
                    colorScheme.onSurface.withValues(alpha: 0.15),
                    colorScheme.onSurface.withValues(alpha: 0.15),
                    colorScheme.onSurface.withValues(alpha: 0.0),
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
                SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(
                      'Compound',
                      style: textTheme.headlineMedium?.copyWith(
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
