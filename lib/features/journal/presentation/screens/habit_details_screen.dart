import 'package:flutter/material.dart';
import 'package:compound/core/theme/app_typography.dart';
import 'package:compound/core/theme/app_radius.dart';

class HabitDetailsScreen extends StatefulWidget {
  final String habitId;
  final String habitName;
  final IconData habitIcon;
  final bool isDone;
  final DateTime date;

  const HabitDetailsScreen({
    super.key,
    required this.habitId,
    required this.habitName,
    required this.habitIcon,
    required this.isDone,
    required this.date,
  });

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _contentController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<_HabitHistory> _history = _generateDummyHistory();

  int get _currentStreak => 7;
  int get _longestStreak => 14;
  double get _completionRate => 0.78;
  int get _totalCompletions => 45;

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    _heroController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  static List<_HabitHistory> _generateDummyHistory() {
    final now = DateTime.now();
    return List.generate(30, (index) {
      final date = now.subtract(Duration(days: index));
      return _HabitHistory(
        date: date,
        isCompleted: index % 3 != 0 && index < 20,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: colorScheme.onSurface,
                  size: 18,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.more_horiz_rounded,
                    color: colorScheme.onSurface,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _buildHeader(colorScheme, textTheme),
            ),
          ),

          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsGrid(colorScheme, textTheme),
                    _buildStreakCard(colorScheme, textTheme),
                    _buildCalendarSection(colorScheme, textTheme),
                    _buildNotesSection(colorScheme, textTheme),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(color: colorScheme.surface),
      padding: const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _heroController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.8 + (0.2 * _heroController.value),
                    child: Opacity(
                      opacity: _heroController.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.06),
                    borderRadius: AppRadius.roundedLg,
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.1),
                      width: 0.5,
                    ),
                  ),
                  child: Icon(
                    widget.habitIcon,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.habitName,
                      style: AppTypography.headlineSmall.copyWith(
                        color: colorScheme.onSurface,
                        fontVariations: const [FontVariation('wght', 600)],
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.isDone
                                ? colorScheme.onSurface.withValues(alpha: 0.8)
                                : colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.isDone ? 'Completed today' : 'Not completed',
                          style: AppTypography.bodySmall.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                            fontVariations: const [FontVariation('wght', 400)],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Current\nStreak',
              value: '$_currentStreak',
              unit: 'days',
              colorScheme: colorScheme,
              index: 0,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'Longest\nStreak',
              value: '$_longestStreak',
              unit: 'days',
              colorScheme: colorScheme,
              index: 1,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'Completion\nRate',
              value: '${(_completionRate * 100).toInt()}',
              unit: '%',
              colorScheme: colorScheme,
              index: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.onSurface.withValues(alpha: 0.05),
            colorScheme.onSurface.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: AppRadius.roundedXl,
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'STREAK JOURNEY',
                style: AppTypography.uppercaseSmall.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_totalCompletions',
                      style: AppTypography.displaySmall.copyWith(
                        color: colorScheme.onSurface,
                        fontVariations: const [FontVariation('wght', 700)],
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      'Total completions',
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: colorScheme.outline.withValues(alpha: 0.1),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_currentStreak days',
                        style: AppTypography.titleLarge.copyWith(
                          color: colorScheme.onSurface,
                          fontVariations: const [FontVariation('wght', 600)],
                        ),
                      ),
                      Text(
                        'Current streak',
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: AppRadius.roundedFull,
            child: LinearProgressIndicator(
              value: _currentStreak / _longestStreak,
              minHeight: 6,
              backgroundColor: colorScheme.onSurface.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation(
                colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Day $_currentStreak',
                style: AppTypography.labelSmall.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
              Text(
                'Best: $_longestStreak days',
                style: AppTypography.labelSmall.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'HISTORY',
                style: AppTypography.uppercaseSmall.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 0.5,
                  color: colorScheme.onSurface.withValues(alpha: 0.08),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.03),
              borderRadius: AppRadius.roundedLg,
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.06),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (index) {
                    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                    return SizedBox(
                      width: 32,
                      child: Text(
                        days[index],
                        textAlign: TextAlign.center,
                        style: AppTypography.labelSmall.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.3),
                          fontVariations: const [FontVariation('wght', 500)],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                ...List.generate(5, (weekIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(7, (dayIndex) {
                        final index = (weekIndex * 7) + dayIndex;
                        if (index >= _history.length) {
                          return const SizedBox(width: 32, height: 32);
                        }
                        final history = _history[index];
                        return _CalendarDot(
                          isCompleted: history.isCompleted,
                          isToday: index == 0,
                          colorScheme: colorScheme,
                        );
                      }),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'NOTES',
                style: AppTypography.uppercaseSmall.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 0.5,
                  color: colorScheme.onSurface.withValues(alpha: 0.08),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.03),
              borderRadius: AppRadius.roundedLg,
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.06),
                width: 0.5,
              ),
            ),
            child: TextField(
              maxLines: 4,
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurface,
                height: 1.6,
              ),
              decoration: InputDecoration(
                hintText: 'Add notes about this habit...',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.25),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final ColorScheme colorScheme;
  final int index;

  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.colorScheme,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animValue)),
          child: Opacity(opacity: animValue, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.03),
          borderRadius: AppRadius.roundedMd,
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.06),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTypography.headlineMedium.copyWith(
                color: colorScheme.onSurface,
                fontVariations: const [FontVariation('wght', 700)],
                letterSpacing: -1,
              ),
            ),
            Text(
              unit,
              style: AppTypography.labelSmall.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarDot extends StatelessWidget {
  final bool isCompleted;
  final bool isToday;
  final ColorScheme colorScheme;

  const _CalendarDot({
    required this.isCompleted,
    required this.isToday,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? colorScheme.onSurface.withValues(alpha: 0.8)
            : Colors.transparent,
        border: isToday
            ? Border.all(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                width: 1.5,
              )
            : null,
      ),
      child: isCompleted
          ? Icon(Icons.check_rounded, size: 14, color: colorScheme.surface)
          : null,
    );
  }
}

class _HabitHistory {
  final DateTime date;
  final bool isCompleted;

  const _HabitHistory({required this.date, required this.isCompleted});
}
