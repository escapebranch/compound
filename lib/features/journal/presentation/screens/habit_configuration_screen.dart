import 'package:flutter/material.dart';
import 'package:compound/core/theme/app_radius.dart';
import 'package:compound/core/theme/app_shadows.dart';
import 'package:compound/core/theme/app_spacing.dart';
import 'package:compound/core/theme/app_typography.dart';

class HabitConfigurationScreen extends StatefulWidget {
  const HabitConfigurationScreen({super.key});

  @override
  State<HabitConfigurationScreen> createState() =>
      _HabitConfigurationScreenState();
}

class _HabitConfigurationScreenState extends State<HabitConfigurationScreen> {
  final List<_HabitConfigItem> _habits = [];

  Future<void> _onAddHabitTap() async {
    final habit = await showModalBottomSheet<_HabitConfigItem>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => const _CreateHabitBottomSheet(),
    );

    if (habit == null || !mounted) {
      return;
    }

    setState(() {
      _habits.insert(0, habit);
    });
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
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
            vertical: AppSpacing.md,
          ),
          child: _habits.isEmpty
              ? _EmptyHabitsState(
                  onAddHabit: _onAddHabitTap,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                )
              : Column(
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
                              '${_habits.length} habits configured',
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
                        itemCount: _habits.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final habit = _habits[index];
                          return _HabitCard(habit: habit);
                        },
                      ),
                    ),
                  ],
                ),
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

  _HabitFrequency _frequency = _HabitFrequency.daily;
  int _targetPerDay = 1;
  IconData _selectedIcon = Icons.check_circle_outline_rounded;
  bool _enableReminder = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);

  final List<IconData> _iconOptions = const [
    Icons.check_circle_outline_rounded,
    Icons.fitness_center_rounded,
    Icons.self_improvement_rounded,
    Icons.menu_book_rounded,
    Icons.water_drop_rounded,
    Icons.nightlight_round,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _pickReminderTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (selected == null || !mounted) {
      return;
    }
    setState(() {
      _reminderTime = selected;
    });
  }

  void _createHabit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final item = _HabitConfigItem(
      name: _nameController.text.trim(),
      goal: _goalController.text.trim(),
      icon: _selectedIcon,
      frequency: _frequency,
      targetPerDay: _targetPerDay,
      reminderTime: _enableReminder ? _reminderTime : null,
      createdAt: DateTime.now(),
    );

    Navigator.of(context).pop(item);
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
                'Add the essentials and start tracking instantly.',
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
                  if (value.trim().length < 2) {
                    return 'Use at least 2 characters';
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
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<_HabitFrequency>(
                value: _frequency,
                decoration: const InputDecoration(labelText: 'Frequency'),
                items: _HabitFrequency.values
                    .map(
                      (frequency) => DropdownMenuItem(
                        value: frequency,
                        child: Text(frequency.label),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _frequency = value;
                  });
                },
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
                      final isSelected = icon == _selectedIcon;
                      return InkWell(
                        borderRadius: AppRadius.roundedMd,
                        onTap: () {
                          setState(() {
                            _selectedIcon = icon;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 48,
                          height: 48,
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
                            size: 22,
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
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.03),
                  borderRadius: AppRadius.roundedLg,
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.08),
                    width: 0.8,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Target / day',
                          style: AppTypography.titleSmall.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$_targetPerDay',
                          style: AppTypography.labelLarge.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _targetPerDay.toDouble(),
                      min: 1,
                      max: 8,
                      divisions: 7,
                      label: _targetPerDay.toString(),
                      onChanged: (value) {
                        setState(() {
                          _targetPerDay = value.round();
                        });
                      },
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _enableReminder,
                      onChanged: (value) {
                        setState(() {
                          _enableReminder = value;
                        });
                      },
                      title: Text(
                        'Enable reminder',
                        style: AppTypography.bodyMedium.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        _enableReminder
                            ? 'At ${_reminderTime.format(context)}'
                            : 'Reminder off',
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                    if (_enableReminder)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _pickReminderTime,
                          icon: const Icon(Icons.schedule_rounded),
                          label: const Text('Set reminder time'),
                        ),
                      ),
                  ],
                ),
              ),
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
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({required this.habit});

  final _HabitConfigItem habit;

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
              habit.icon,
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
                if (habit.goal.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    habit.goal,
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
                      icon: Icons.repeat_rounded,
                      label: habit.frequency.label,
                    ),
                    _MetaPill(
                      icon: Icons.flag_rounded,
                      label: '${habit.targetPerDay}/day',
                    ),
                    if (habit.reminderTime != null)
                      _MetaPill(
                        icon: Icons.alarm_rounded,
                        label: habit.reminderTime!.format(context),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurface.withValues(alpha: 0.4),
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

class _HabitConfigItem {
  const _HabitConfigItem({
    required this.name,
    required this.goal,
    required this.icon,
    required this.frequency,
    required this.targetPerDay,
    required this.reminderTime,
    required this.createdAt,
  });

  final String name;
  final String goal;
  final IconData icon;
  final _HabitFrequency frequency;
  final int targetPerDay;
  final TimeOfDay? reminderTime;
  final DateTime createdAt;
}

enum _HabitFrequency { daily, weekdays, custom }

extension on _HabitFrequency {
  String get label {
    return switch (this) {
      _HabitFrequency.daily => 'Daily',
      _HabitFrequency.weekdays => 'Weekdays',
      _HabitFrequency.custom => 'Custom',
    };
  }
}
