import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:compound/core/theme/app_typography.dart';
import 'package:compound/core/theme/app_radius.dart';
import 'habit_details_screen.dart';

/// Daily Log Screen
///
/// A premium, AMOLED-first journal + habit tracker for a specific day.
/// Monochromatic, minimal, and ultra-refined.
class DailyLogScreen extends StatefulWidget {
  final DateTime date;

  const DailyLogScreen({super.key, required this.date});

  @override
  State<DailyLogScreen> createState() => _DailyLogScreenState();
}

class _DailyLogScreenState extends State<DailyLogScreen>
    with TickerProviderStateMixin {
  final TextEditingController _journalController = TextEditingController();
  final FocusNode _journalFocusNode = FocusNode();
  late AnimationController _entryAnimController;
  late AnimationController _headerAnimController;
  bool _isEditing = false;
  int _wordCount = 0;

  // ── Dummy habit data (replace with real data layer later) ──────────────────
  final List<_HabitItem> _habits = [
    _HabitItem(
      id: '1',
      name: 'Morning Meditation',
      icon: Icons.self_improvement_rounded,
      done: false,
    ),
    _HabitItem(
      id: '2',
      name: 'Read 30 minutes',
      icon: Icons.menu_book_rounded,
      done: true,
    ),
    _HabitItem(
      id: '3',
      name: 'Exercise',
      icon: Icons.fitness_center_rounded,
      done: false,
    ),
    _HabitItem(
      id: '4',
      name: 'Cold Shower',
      icon: Icons.water_drop_rounded,
      done: true,
    ),
    _HabitItem(
      id: '5',
      name: 'No social media',
      icon: Icons.phone_disabled_rounded,
      done: false,
    ),
    _HabitItem(
      id: '6',
      name: 'Sleep by 11 PM',
      icon: Icons.bedtime_rounded,
      done: false,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _entryAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    _journalController.addListener(() {
      final text = _journalController.text;
      final words = text.trim().isEmpty
          ? 0
          : text.trim().split(RegExp(r'\s+')).length;
      if (words != _wordCount) {
        setState(() => _wordCount = words);
      }
    });

    _journalFocusNode.addListener(() {
      setState(() => _isEditing = _journalFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _journalController.dispose();
    _journalFocusNode.dispose();
    _entryAnimController.dispose();
    _headerAnimController.dispose();
    super.dispose();
  }

  int get _completedHabits => _habits.where((h) => h.done).length;
  double get _habitProgress =>
      _habits.isEmpty ? 0 : _completedHabits / _habits.length;

  bool get _isToday {
    final now = DateTime.now();
    return widget.date.year == now.year &&
        widget.date.month == now.month &&
        widget.date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: GestureDetector(
        onTap: () => _journalFocusNode.unfocus(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Floating App Bar ─────────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              expandedHeight: 170,
              backgroundColor: colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: colorScheme.onSurface,
                  size: 20,
                ),
              ),
              actions: [
                _buildDateChip(colorScheme, textTheme),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: _buildHeader(colorScheme, textTheme),
              ),
            ),

            // ── Habit Ring Summary ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _buildHabitSummaryBar(colorScheme, textTheme),
            ),

            // ── Section: Habits ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _buildSectionLabel('HABITS', colorScheme, textTheme),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _AnimatedHabitTile(
                    habit: _habits[index],
                    index: index,
                    parentController: _entryAnimController,
                    date: widget.date,
                    onToggle: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _habits[index] = _habits[index].copyWith(
                          done: !_habits[index].done,
                        );
                      });
                    },
                  );
                }, childCount: _habits.length),
              ),
            ),

            // ── Section: Journal ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _buildSectionLabel('DAILY LOG', colorScheme, textTheme),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildJournalEditor(colorScheme, textTheme),
              ),
            ),

            // ── Bottom padding ────────────────────────────────────────────────
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),

      // ── Floating Save Button ──────────────────────────────────────────────
      floatingActionButton: _buildSaveButton(colorScheme, textTheme),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    final dayName = _getDayName(widget.date.weekday);
    final monthName = _getMonthName(widget.date.month);

    return Container(
      decoration: BoxDecoration(color: colorScheme.surface),
      padding: const EdgeInsets.only(top: 96, left: 20, right: 20, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isToday)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.08),
                borderRadius: AppRadius.roundedFull,
                border: Border.all(
                  color: colorScheme.onSurface.withValues(alpha: 0.12),
                  width: 0.5,
                ),
              ),
              child: Text(
                'TODAY',
                style: AppTypography.uppercaseSmall.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  letterSpacing: 2.0,
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                widget.date.day.toString().padLeft(2, '0'),
                style: AppTypography.displayMedium.copyWith(
                  color: colorScheme.onSurface,
                  fontVariations: const [FontVariation('wght', 700)],
                  letterSpacing: -2,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName.toUpperCase(),
                    style: AppTypography.labelMedium.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.35),
                      letterSpacing: 2.0,
                    ),
                  ),
                  Text(
                    '$monthName ${widget.date.year}',
                    style: AppTypography.titleSmall.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.55),
                      fontVariations: const [FontVariation('wght', 400)],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Date Chip in AppBar ──────────────────────────────────────────────────────
  Widget _buildDateChip(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.06),
        borderRadius: AppRadius.roundedFull,
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Text(
        '${_wordCount}w',
        style: AppTypography.labelSmall.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.4),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ── Habit Summary Bar ─────────────────────────────────────────────────────
  Widget _buildHabitSummaryBar(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.04),
        borderRadius: AppRadius.roundedLg,
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.07),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Progress Ring
          SizedBox(
            width: 44,
            height: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 3,
                  strokeCap: StrokeCap.round,
                  valueColor: AlwaysStoppedAnimation(
                    colorScheme.onSurface.withValues(alpha: 0.07),
                  ),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: _habitProgress),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => CircularProgressIndicator(
                    value: value,
                    strokeWidth: 3,
                    strokeCap: StrokeCap.round,
                    valueColor: AlwaysStoppedAnimation(
                      colorScheme.onSurface.withValues(
                        alpha: value == 1.0 ? 1.0 : 0.75,
                      ),
                    ),
                  ),
                ),
                Text(
                  '$_completedHabits',
                  style: AppTypography.labelMedium.copyWith(
                    color: colorScheme.onSurface,
                    fontVariations: const [FontVariation('wght', 700)],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_completedHabits of ${_habits.length} habits done',
                  style: AppTypography.titleSmall.copyWith(
                    color: colorScheme.onSurface,
                    fontVariations: const [FontVariation('wght', 500)],
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: AppRadius.roundedFull,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: _habitProgress),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      minHeight: 3,
                      backgroundColor: colorScheme.onSurface.withValues(
                        alpha: 0.08,
                      ),
                      valueColor: AlwaysStoppedAnimation(
                        colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Percentage
          Text(
            '${(_habitProgress * 100).toInt()}%',
            style: AppTypography.headlineSmall.copyWith(
              color: colorScheme.onSurface.withValues(
                alpha: _habitProgress == 0 ? 0.2 : 0.8,
              ),
              fontVariations: const [FontVariation('wght', 600)],
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Label ─────────────────────────────────────────────────────────
  Widget _buildSectionLabel(
    String label,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          Text(
            label,
            style: AppTypography.uppercaseLarge.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.3),
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 0.5,
              color: colorScheme.onSurface.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }

  // ── Journal Editor ────────────────────────────────────────────────────────
  Widget _buildJournalEditor(ColorScheme colorScheme, TextTheme textTheme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.04),
        borderRadius: AppRadius.roundedLg,
        border: Border.all(
          color: _isEditing
              ? colorScheme.onSurface.withValues(alpha: 0.2)
              : colorScheme.outline.withValues(alpha: 0.08),
          width: _isEditing ? 1.0 : 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.onSurface.withValues(alpha: 0.06),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.edit_note_rounded,
                  size: 18,
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 8),
                Text(
                  'What\'s on your mind today?',
                  style: AppTypography.bodySmall.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                    fontVariations: const [FontVariation('wght', 400)],
                  ),
                ),
                const Spacer(),
                if (_wordCount > 0)
                  Text(
                    '$_wordCount words',
                    style: AppTypography.labelSmall.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.25),
                    ),
                  ),
              ],
            ),
          ),

          // Text Field
          TextField(
            controller: _journalController,
            focusNode: _journalFocusNode,
            maxLines: null,
            minLines: 8,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            style: AppTypography.bodyLarge.copyWith(
              color: colorScheme.onSurface,
              height: 1.65,
              letterSpacing: 0.1,
              fontVariations: const [FontVariation('wght', 400)],
            ),
            decoration: InputDecoration(
              hintText: 'Start writing...',
              hintStyle: AppTypography.bodyLarge.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.18),
                height: 1.65,
                fontVariations: const [FontVariation('wght', 300)],
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              filled: false,
            ),
          ),
        ],
      ),
    );
  }

  // ── Save Button ─────────────────────────────────────────────────────────────
  Widget _buildSaveButton(ColorScheme colorScheme, TextTheme textTheme) {
    return AnimatedScale(
      scale: _isEditing ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutBack,
      child: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.mediumImpact();
          _journalFocusNode.unfocus();
          // Show save confirmation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: colorScheme.surface,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Log saved',
                    style: AppTypography.labelLarge.copyWith(
                      color: colorScheme.surface,
                    ),
                  ),
                ],
              ),
              backgroundColor: colorScheme.onSurface,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        backgroundColor: colorScheme.onSurface,
        foregroundColor: colorScheme.surface,
        elevation: 0,
        label: Text(
          'Save Log',
          style: AppTypography.labelLarge.copyWith(
            color: colorScheme.surface,
            fontVariations: const [FontVariation('wght', 600)],
          ),
        ),
        icon: Icon(Icons.check_rounded, size: 18, color: colorScheme.surface),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────
  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
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
}

// ── Habit Data Model ───────────────────────────────────────────────────────────
class _HabitItem {
  final String id;
  final String name;
  final IconData icon;
  final bool done;

  const _HabitItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.done,
  });

  _HabitItem copyWith({bool? done}) =>
      _HabitItem(id: id, name: name, icon: icon, done: done ?? this.done);
}

// ── Animated Habit Tile ────────────────────────────────────────────────────────
class _AnimatedHabitTile extends StatefulWidget {
  final _HabitItem habit;
  final int index;
  final AnimationController parentController;
  final VoidCallback onToggle;
  final DateTime date;

  const _AnimatedHabitTile({
    required this.habit,
    required this.index,
    required this.parentController,
    required this.onToggle,
    required this.date,
  });

  @override
  State<_AnimatedHabitTile> createState() => _AnimatedHabitTileState();
}

class _AnimatedHabitTileState extends State<_AnimatedHabitTile>
    with SingleTickerProviderStateMixin {
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late AnimationController _checkController;

  @override
  void initState() {
    super.initState();

    final begin = (widget.index * 0.07).clamp(0.0, 0.7);
    final end = (begin + 0.3).clamp(0.0, 1.0);

    _slideAnimation = Tween<double>(begin: 24, end: 0).animate(
      CurvedAnimation(
        parent: widget.parentController,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: widget.parentController,
        curve: Interval(begin, end, curve: Curves.easeOut),
      ),
    );

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    if (widget.habit.done) _checkController.value = 1.0;
  }

  @override
  void didUpdateWidget(_AnimatedHabitTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.habit.done != oldWidget.habit.done) {
      if (widget.habit.done) {
        _checkController.forward();
      } else {
        _checkController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  void _navigateToDetails() {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => HabitDetailsScreen(
          habitId: widget.habit.id,
          habitName: widget.habit.name,
          habitIcon: widget.habit.icon,
          isDone: widget.habit.done,
          date: widget.date,
        ),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(opacity: curved, child: child);
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: widget.parentController,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _slideAnimation.value),
        child: Opacity(opacity: _fadeAnimation.value, child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTap: _navigateToDetails,
          onLongPress: widget.onToggle,
          behavior: HitTestBehavior.opaque,
          child: AnimatedBuilder(
            animation: _checkController,
            builder: (context, child) {
              final t = _checkController.value;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: Color.lerp(
                    colorScheme.onSurface.withValues(alpha: 0.04),
                    colorScheme.onSurface.withValues(alpha: 0.08),
                    t,
                  ),
                  borderRadius: AppRadius.roundedMd,
                  border: Border.all(
                    color: Color.lerp(
                      colorScheme.outline.withValues(alpha: 0.07),
                      colorScheme.onSurface.withValues(alpha: 0.15),
                      t,
                    )!,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Color.lerp(
                          colorScheme.onSurface.withValues(alpha: 0.06),
                          colorScheme.onSurface.withValues(alpha: 0.12),
                          t,
                        ),
                        borderRadius: AppRadius.roundedSm,
                      ),
                      child: Icon(
                        widget.habit.done
                            ? Icons.check_rounded
                            : widget.habit.icon,
                        size: 18,
                        color: colorScheme.onSurface.withValues(
                          alpha: 0.3 + (t * 0.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Name
                    Expanded(
                      child: Text(
                        widget.habit.name,
                        style: AppTypography.bodyMedium.copyWith(
                          color: Color.lerp(
                            colorScheme.onSurface.withValues(alpha: 0.5),
                            colorScheme.onSurface,
                            t,
                          ),
                          fontVariations: [
                            FontVariation('wght', 400 + (100 * t)),
                          ],
                          decoration: widget.habit.done
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                          decorationThickness: 1,
                        ),
                      ),
                    ),
                    // Toggle checkbox (long press or explicit tap area)
                    GestureDetector(
                      onTap: widget.onToggle,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.habit.done
                                ? colorScheme.onSurface
                                : Colors.transparent,
                            border: Border.all(
                              color: widget.habit.done
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurface.withValues(
                                      alpha: 0.2,
                                    ),
                              width: 1.5,
                            ),
                          ),
                          child: widget.habit.done
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 13,
                                  color: colorScheme.surface,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
