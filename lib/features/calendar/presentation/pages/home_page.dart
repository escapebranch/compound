import 'package:flutter/material.dart';
import 'package:compound/main.dart' show installYear, installMonth;
import 'package:compound/core/theme/theme_notifier.dart';
import 'package:compound/features/journal/presentation/screens/daily_log_screen.dart';
import 'package:compound/features/journal/presentation/screens/habit_configuration_screen.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _currentDate = DateTime.now();

  void _changeMonth(int offset) {
    setState(() {
      final newDate = DateTime(_currentDate.year, _currentDate.month + offset);
      if (newDate.year < installYear ||
          (newDate.year == installYear && newDate.month < installMonth)) {
        return; // Do not go before the install month
      }
      _currentDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildEndDrawer(context, colorScheme, textTheme, isDark),
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
                      'Compound.',
                      style: textTheme.headlineMedium?.copyWith(
                        fontVariations: [const FontVariation('wght', 700)],
                        letterSpacing: -0.5,
                        fontSize: 24,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          _scaffoldKey.currentState?.openEndDrawer(),
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
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity == null) return;
                if (details.primaryVelocity! > 0) {
                  // Swipe right -> previous month
                  _changeMonth(-1);
                } else if (details.primaryVelocity! < 0) {
                  // Swipe left -> next month
                  _changeMonth(1);
                }
              },
              behavior: HitTestBehavior.opaque,
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
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: CalendarGrid(
                              key: ValueKey(_currentDate),
                              currentDate: _currentDate,
                              onDateTap: (date) {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, animation, __) =>
                                        DailyLogScreen(date: date),
                                    transitionsBuilder:
                                        (_, animation, __, child) {
                                          final curved = CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeOutCubic,
                                          );
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(0, 1),
                                              end: Offset.zero,
                                            ).animate(curved),
                                            child: FadeTransition(
                                              opacity: curved,
                                              child: child,
                                            ),
                                          );
                                        },
                                    transitionDuration: const Duration(
                                      milliseconds: 380,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // Month Selector with Return to Current Month Button
                      SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            MonthSelector(
                              currentDate: _currentDate,
                              onMonthChanged: _changeMonth,
                            ),
                            // Return to Current Month Button
                            _buildReturnToNowButton(context, colorScheme),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndDrawer(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDark,
  ) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.84,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Settings',
                  style: textTheme.titleLarge?.copyWith(
                    fontVariations: [const FontVariation('wght', 600)],
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Personalize your workspace',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.56),
                    fontVariations: [const FontVariation('wght', 400)],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _buildThemeCard(colorScheme, textTheme, isDark),
              const SizedBox(height: 10),
              _buildActionCard(
                colorScheme: colorScheme,
                textTheme: textTheme,
                icon: Icons.tune_rounded,
                title: 'Habit Configuration',
                subtitle: 'Create, edit, and manage habits',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HabitConfigurationScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeCard(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: colorScheme.onSurface.withValues(alpha: isDark ? 0.05 : 0.04),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: isDark ? 0.09 : 0.12),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(
                      alpha: isDark ? 0.12 : 0.08,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _iconForTheme(themeNotifier.value),
                    size: 19,
                    color: colorScheme.onSurface.withValues(alpha: 0.84),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theme',
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontVariations: [const FontVariation('wght', 560)],
                        ),
                      ),
                      Text(
                        'Light, Auto, or Dark',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.58),
                          fontVariations: [const FontVariation('wght', 400)],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurface.withValues(alpha: 0.46),
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier,
                builder: (context, selectedMode, _) {
                  return SegmentedButton<ThemeMode>(
                    multiSelectionEnabled: false,
                    showSelectedIcon: false,
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      ),
                      textStyle: WidgetStateProperty.all(
                        textTheme.labelMedium?.copyWith(
                          fontVariations: [const FontVariation('wght', 500)],
                        ),
                      ),
                    ),
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('Light'),
                        ),
                        icon: Icon(Icons.light_mode_rounded, size: 16),
                      ),
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('Auto'),
                        ),
                        icon: Icon(Icons.brightness_auto_rounded, size: 16),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('Dark'),
                        ),
                        icon: Icon(Icons.dark_mode_rounded, size: 16),
                      ),
                    ],
                    selected: {selectedMode},
                    onSelectionChanged: (selected) {
                      if (selected.isNotEmpty) {
                        themeNotifier.value = selected.first;
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: colorScheme.onSurface.withValues(alpha: 0.04),
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              width: 0.8,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 19,
                    color: colorScheme.onSurface.withValues(alpha: 0.84),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontVariations: [const FontVariation('wght', 560)],
                        ),
                      ),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.58),
                          fontVariations: [const FontVariation('wght', 400)],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurface.withValues(alpha: 0.46),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconForTheme(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.system:
        return Icons.brightness_auto_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
    }
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
        const SizedBox(width: 6),
        // Circular Progress
        SizedBox(
          width: 16,
          height: 16,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Circle
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 2,
                strokeCap: StrokeCap.round,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(
                  colorScheme.onSurface.withValues(alpha: 0.08),
                ),
              ),
              // Progress Circle
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 2,
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

  Widget _buildReturnToNowButton(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    final now = DateTime.now();
    final currentMonthStart = DateTime(now.year, now.month);
    final selectedMonthStart = DateTime(_currentDate.year, _currentDate.month);

    // Don't show if already on current month
    if (selectedMonthStart == currentMonthStart) return const SizedBox.shrink();

    // Determine direction
    // If selected is in past (e.g. Jan), and we want to go back to Current (e.g. Mar).
    // Current is AHEAD (Right).
    final isPast = selectedMonthStart.isBefore(currentMonthStart);
    final icon = isPast
        ? Icons.keyboard_double_arrow_right
        : Icons.keyboard_double_arrow_left;

    return Positioned(
      right: 8, // Fits to the right-most, close to edge
      top: 6, // Aligns with the 44px height pill
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuart,
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          // Slide in from the right (positive X offset)
          // Start at 60px right, end at 0
          final slideOffset = 60.0 * (1.0 - value);

          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(slideOffset, 0),
              child: child,
            ),
          );
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              _currentDate = now;
            });
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.1),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
