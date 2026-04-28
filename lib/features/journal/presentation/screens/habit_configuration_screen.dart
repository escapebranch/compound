import 'package:flutter/material.dart';
import 'package:compound/core/data/app_database.dart';
import 'package:compound/core/theme/app_radius.dart';
import 'package:compound/core/theme/app_shadows.dart';
import 'package:compound/core/theme/app_spacing.dart';
import 'package:compound/core/theme/app_typography.dart';
import 'package:compound/main.dart';
import 'package:drift/drift.dart' hide Column;

class HabitConfigurationScreen extends StatefulWidget {
  const HabitConfigurationScreen({super.key});

  @override
  State<HabitConfigurationScreen> createState() =>
      _HabitConfigurationScreenState();
}

class _HabitConfigurationScreenState extends State<HabitConfigurationScreen> {
  Future<void> _onAddHabitTap() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => const _CreateHabitBottomSheet(),
    );

    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final surfaceShadows = isDark ? AppShadows.darkMd : AppShadows.lightMd;

    return Scaffold(
      appBar: AppBar(title: const Text('Habit Configuration')),
      body: SafeArea(
        child: StreamBuilder<List<HabitWithTimes>>(
          stream: database.watchHabitsWithTimes(),
          builder: (context, snapshot) {
            final habits = snapshot.data ?? [];
            
            if (habits.isEmpty && snapshot.connectionState == ConnectionState.active) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
                child: _EmptyHabitsState(
                  onAddHabit: _onAddHabitTap,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
                vertical: AppSpacing.md,
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.04),
                      borderRadius: AppRadius.roundedXl,
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.08),
                        width: 0.8,
                      ),
                      boxShadow: surfaceShadows,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.insights_rounded,
                          size: 20,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            '${habits.length} habits configured',
                            style: AppTypography.titleSmall.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: _onAddHabitTap,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Add'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: habits.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final habitWithTimes = habits[index];
                        return FutureBuilder<List<HabitTime>>(
                          future: habitWithTimes.timesFuture,
                          builder: (context, timeSnapshot) {
                            return _HabitCard(
                              habit: habitWithTimes.habit,
                              times: timeSnapshot.data ?? [],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}

class _EmptyHabitsState extends StatelessWidget {
  const _EmptyHabitsState({
    required this.onAddHabit,
    required this.colorScheme,
    required this.textTheme,
  });

  final VoidCallback onAddHabit;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardShadow = isDark ? AppShadows.darkMd : AppShadows.lightMd;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.03),
                borderRadius: AppRadius.roundedXxl,
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.08),
                  width: 0.8,
                ),
                boxShadow: cardShadow,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _OrbIcon(
                        icon: Icons.auto_awesome_rounded,
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _OrbIcon(
                        icon: Icons.track_changes_rounded,
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _OrbIcon(
                        icon: Icons.rocket_launch_rounded,
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'No habits yet',
                    style: AppTypography.titleLarge.copyWith(
                      color: colorScheme.onSurface,
                      fontVariations: const [FontVariation('wght', 600)],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Build your routine with focused, trackable habits.\nStart with one and keep the streak alive.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.62),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onAddHabit,
                icon: const Icon(Icons.add_circle_outline_rounded),
                label: const Text('Add New Habit'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.roundedLg,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateHabitBottomSheet extends StatefulWidget {
  const _CreateHabitBottomSheet();

  @override
  State<_CreateHabitBottomSheet> createState() =>
      _CreateHabitBottomSheetState();
}

class _CreateHabitBottomSheetState extends State<_CreateHabitBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _goalController = TextEditingController();

  IconData _selectedIcon = Icons.check_circle_outline_rounded;
  
  // Day selection and times
  final Map<int, TimeRange?> _selectedDays = {
    1: null, // Mon
    2: null, // Tue
    3: null, // Wed
    4: null, // Thu
    5: null, // Fri
    6: null, // Sat
    7: null, // Sun
  };

  final List<IconData> _iconOptions = const [
    Icons.check_circle_outline_rounded,
    Icons.fitness_center_rounded,
    Icons.self_improvement_rounded,
    Icons.menu_book_rounded,
    Icons.water_drop_rounded,
    Icons.nightlight_round,
    Icons.directions_run,
    Icons.coffee,
    Icons.code,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays[day] != null || _isDaySelected(day)) {
        if (_selectedDays[day] == null) {
          // If selected but no time range yet (defaulting to a range)
           _selectedDays[day] = const TimeRange(
            start: TimeOfDay(hour: 8, minute: 0),
            end: TimeOfDay(hour: 9, minute: 0),
          );
        } else {
           _selectedDays[day] = null;
        }
      } else {
        _selectedDays[day] = const TimeRange(
          start: TimeOfDay(hour: 8, minute: 0),
          end: TimeOfDay(hour: 9, minute: 0),
        );
      }
    });
  }

  bool _isDaySelected(int day) => _selectedDays[day] != null;

  Future<void> _editTime(int day) async {
    final currentRange = _selectedDays[day] ?? const TimeRange(
      start: TimeOfDay(hour: 8, minute: 0),
      end: TimeOfDay(hour: 9, minute: 0),
    );

    final result = await showDialog<TimeRange>(
      context: context,
      builder: (context) => _TimeRangePickerDialog(initialRange: currentRange),
    );

    if (result != null) {
      setState(() {
        _selectedDays[day] = result;
      });
    }
  }

  void _applyToAll(TimeRange range) {
    setState(() {
      for (final day in _selectedDays.keys) {
        if (_selectedDays[day] != null) {
          _selectedDays[day] = range;
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Applied to all selected days'), duration: Duration(seconds: 1)),
    );
  }

  Future<void> _createHabit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final selectedDayEntries = _selectedDays.entries.where((e) => e.value != null).toList();
    if (selectedDayEntries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day')),
      );
      return;
    }

    final habitCompanion = HabitsCompanion.insert(
      name: _nameController.text.trim(),
      goal: Value(_goalController.text.trim()),
      iconCodePoint: _selectedIcon.codePoint,
      createdAt: DateTime.now(),
    );

    final timesCompanions = selectedDayEntries.map((e) {
      final range = e.value!;
      return HabitTimesCompanion.insert(
        habitId: 0, // Will be updated in transaction
        dayOfWeek: e.key,
        startHour: range.start.hour,
        startMinute: range.start.minute,
        endHour: range.end.hour,
        endMinute: range.end.minute,
      );
    }).toList();

    await database.createHabit(habitCompanion, timesCompanions);

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        bottomInset + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create a new habit',
                style: AppTypography.titleLarge.copyWith(
                  color: colorScheme.onSurface,
                  fontVariations: const [FontVariation('wght', 600)],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Define your routine and set your schedule.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.62),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Habit name',
                  hintText: 'e.g. Morning walk',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Habit name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _goalController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Goal (optional)',
                  hintText: 'e.g. 20 minutes',
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Choose icon',
                style: AppTypography.titleSmall.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _iconOptions
                    .map((icon) {
                      final isSelected = icon.codePoint == _selectedIcon.codePoint;
                      return InkWell(
                        borderRadius: AppRadius.roundedMd,
                        onTap: () {
                          setState(() {
                            _selectedIcon = icon;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.onSurface.withValues(alpha: 0.12)
                                : colorScheme.onSurface.withValues(alpha: 0.04),
                            borderRadius: AppRadius.roundedMd,
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.onSurface.withValues(
                                      alpha: 0.35,
                                    )
                                  : colorScheme.outline.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Icon(
                            icon,
                            size: 20,
                            color: colorScheme.onSurface.withValues(
                              alpha: isSelected ? 0.95 : 0.65,
                            ),
                          ),
                        ),
                      );
                    })
                    .toList(growable: false),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Schedule',
                style: AppTypography.titleSmall.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [1, 2, 3, 4, 5, 6, 7].map((day) {
                  final isSelected = _isDaySelected(day);
                  final dayName = _getDayNameShort(day);
                  return FilterChip(
                    label: Text(dayName),
                    selected: isSelected,
                    onSelected: (_) => _toggleDay(day),
                    showCheckmark: false,
                    labelStyle: AppTypography.labelMedium.copyWith(
                      color: isSelected ? colorScheme.surface : colorScheme.onSurface,
                    ),
                    selectedColor: colorScheme.onSurface,
                    backgroundColor: colorScheme.onSurface.withValues(alpha: 0.05),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedFull),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              ..._selectedDays.entries.where((e) => e.value != null).map((e) {
                final day = e.key;
                final range = e.value!;
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.03),
                    borderRadius: AppRadius.roundedLg,
                    border: Border.all(color: colorScheme.outline.withValues(alpha: 0.08)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _getDayNameFull(day),
                        style: AppTypography.titleSmall.copyWith(color: colorScheme.onSurface),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _editTime(day),
                        child: Text('${range.start.format(context)} - ${range.end.format(context)}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_all_rounded, size: 18),
                        onPressed: () => _applyToAll(range),
                        tooltip: 'Apply to all selected',
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _createHabit,
                  icon: const Icon(Icons.add_task_rounded),
                  label: const Text('Create habit'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.lg,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.roundedLg,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDayNameShort(int day) {
    return switch (day) {
      1 => 'Mon',
      2 => 'Tue',
      3 => 'Wed',
      4 => 'Thu',
      5 => 'Fri',
      6 => 'Sat',
      7 => 'Sun',
      _ => '',
    };
  }

  String _getDayNameFull(int day) {
    return switch (day) {
      1 => 'Monday',
      2 => 'Tuesday',
      3 => 'Wednesday',
      4 => 'Thursday',
      5 => 'Friday',
      6 => 'Saturday',
      7 => 'Sunday',
      _ => '',
    };
  }
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({required this.habit, required this.times});

  final Habit habit;
  final List<HabitTime> times;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.04),
        borderRadius: AppRadius.roundedXl,
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.08),
          width: 0.8,
        ),
        boxShadow: isDark ? AppShadows.darkSm : AppShadows.lightSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.08),
              borderRadius: AppRadius.roundedMd,
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.08),
              ),
            ),
            child: Icon(
              IconData(habit.iconCodePoint, fontFamily: 'MaterialIcons'),
              size: 22,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: AppTypography.titleMedium.copyWith(
                    color: colorScheme.onSurface,
                    fontVariations: const [FontVariation('wght', 600)],
                  ),
                ),
                if (habit.goal?.isNotEmpty ?? false) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    habit.goal!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.62),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _MetaPill(
                      icon: Icons.calendar_month_rounded,
                      label: '${times.length} days',
                    ),
                    if (times.isNotEmpty)
                      _MetaPill(
                        icon: Icons.schedule_rounded,
                        label: '${TimeOfDay(hour: times.first.startHour, minute: times.first.startMinute).format(context)} - ${TimeOfDay(hour: times.first.endHour, minute: times.first.endMinute).format(context)}',
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

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.06),
        borderRadius: AppRadius.roundedFull,
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.08),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbIcon extends StatelessWidget {
  const _OrbIcon({required this.icon, required this.colorScheme});

  final IconData icon;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.08),
        borderRadius: AppRadius.roundedLg,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Icon(
        icon,
        size: 24,
        color: colorScheme.onSurface.withValues(alpha: 0.8),
      ),
    );
  }
}

class TimeRange {
  final TimeOfDay start;
  final TimeOfDay end;

  const TimeRange({required this.start, required this.end});
}

class _TimeRangePickerDialog extends StatefulWidget {
  final TimeRange initialRange;

  const _TimeRangePickerDialog({required this.initialRange});

  @override
  State<_TimeRangePickerDialog> createState() => _TimeRangePickerDialogState();
}

class _TimeRangePickerDialogState extends State<_TimeRangePickerDialog> {
  late TimeOfDay _start;
  late TimeOfDay _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialRange.start;
    _end = widget.initialRange.end;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Time Range'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Start Time'),
            trailing: Text(_start.format(context)),
            onTap: () async {
              final picked = await showTimePicker(context: context, initialTime: _start);
              if (picked != null) setState(() => _start = picked);
            },
          ),
          ListTile(
            title: const Text('End Time'),
            trailing: Text(_end.format(context)),
            onTap: () async {
              final picked = await showTimePicker(context: context, initialTime: _end);
              if (picked != null) setState(() => _end = picked);
            },
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, TimeRange(start: _start, end: _end)), child: const Text('OK')),
      ],
    );
  }
}
