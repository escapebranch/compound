import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:compound/core/theme/app_typography.dart';
import 'package:compound/core/theme/app_radius.dart';
import 'package:compound/core/data/app_database.dart';
import 'package:compound/main.dart';
import 'dart:async';
import 'habit_details_screen.dart';

class DailyLogScreen extends StatefulWidget {
  final DateTime date;

  const DailyLogScreen({super.key, required this.date});

  @override
  State<DailyLogScreen> createState() => _DailyLogScreenState();
}

class _DailyLogScreenState extends State<DailyLogScreen> {
  late Timer _timer;
  DateTime _now = DateTime.now();
  final double _hourHeight = 120.0;
  final double _timelineWidth = 60.0;
  final ScrollController _scrollController = ScrollController();

  List<_ResolvedHabit> _resolvedHabits = [];
  List<HabitLog> _logs = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final habitsWithTimes = await database.getHabitsForDay(widget.date.weekday);
    final logs = await database.getLogsForDate(widget.date);
    
    final resolved = <_ResolvedHabit>[];
    for (var h in habitsWithTimes) {
      final times = await h.timesFuture;
      for (var t in times) {
        if (t.dayOfWeek == widget.date.weekday) {
          resolved.add(_ResolvedHabit(h.habit, t));
        }
      }
    }

    if (mounted) {
      setState(() {
        _resolvedHabits = resolved;
        _logs = logs;
      });
      
      if (_isToday && _scrollController.hasClients && _scrollController.offset == 0) {
        final currentPosition = (_now.hour + _now.minute / 60.0) * _hourHeight;
        _scrollController.animateTo(
          (currentPosition - 200).clamp(0, 24 * _hourHeight),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  bool get _isToday {
    final now = DateTime.now();
    return widget.date.year == now.year &&
        widget.date.month == now.month &&
        widget.date.day == now.day;
  }

  bool _isHabitCompleted(int habitId, int? habitTimeId) {
    return _logs.any((l) => l.habitId == habitId && l.habitTimeId == habitTimeId && l.completed);
  }

  Future<void> _toggleHabit(int habitId, int? habitTimeId, bool currentStatus) async {
    HapticFeedback.selectionClick();
    await database.toggleHabitLog(habitId, habitTimeId, widget.date, !currentStatus);
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          _buildHeader(colorScheme),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    height: 24 * _hourHeight + 60,
                    child: Stack(
                      children: [
                        _buildTimelineGrid(colorScheme),
                        _buildHabitBlocks(colorScheme),
                        if (_isToday) _buildCurrentTimeIndicator(colorScheme),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: _timelineWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.1),
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 8,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.date.day} ${_getMonthName(widget.date.month)}',
                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                _getDayName(widget.date.weekday).toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (_isToday)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: AppRadius.roundedFull,
                border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'LIVE',
                    style: AppTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineGrid(ColorScheme colorScheme) {
    return Column(
      children: List.generate(24, (index) {
        return Container(
          height: _hourHeight,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.05),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: _timelineWidth,
                padding: const EdgeInsets.only(top: 4, right: 8),
                child: Text(
                  '${index.toString().padLeft(2, '0')}:00',
                  textAlign: TextAlign.right,
                  style: AppTypography.labelSmall.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.25),
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHabitBlocks(ColorScheme colorScheme) {
    return Stack(
      children: _resolvedHabits.map((rh) {
        final start = rh.time.startHour + rh.time.startMinute / 60.0;
        final end = rh.time.endHour + rh.time.endMinute / 60.0;
        final duration = end - start;
        final top = start * _hourHeight;
        final height = duration * _hourHeight;
        final isCompleted = _isHabitCompleted(rh.habit.id, rh.time.id);

        return Positioned(
          top: top,
          left: _timelineWidth + 8,
          right: 16,
          height: height.clamp(40.0, 1000.0),
          child: GestureDetector(
            onTap: () => _toggleHabit(rh.habit.id, rh.time.id, isCompleted),
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitDetailsScreen(
                    habitId: rh.habit.id.toString(),
                    habitName: rh.habit.name,
                    habitIcon: IconData(rh.habit.iconCodePoint, fontFamily: 'MaterialIcons'),
                    isDone: isCompleted,
                    date: widget.date,
                  ),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isCompleted
                    ? colorScheme.onSurface.withValues(alpha: 0.15)
                    : colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: AppRadius.roundedLg,
                border: Border.all(
                  color: isCompleted
                      ? colorScheme.onSurface.withValues(alpha: 0.3)
                      : colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: AppRadius.roundedSm,
                    ),
                    child: Icon(
                      isCompleted ? Icons.check_rounded : IconData(rh.habit.iconCodePoint, fontFamily: 'MaterialIcons'),
                      size: 18,
                      color: isCompleted ? Colors.green : colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rh.habit.name,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        Text(
                          '${rh.time.startHour.toString().padLeft(2, '0')}:${rh.time.startMinute.toString().padLeft(2, '0')} - ${rh.time.endHour.toString().padLeft(2, '0')}:${rh.time.endMinute.toString().padLeft(2, '0')}',
                          style: AppTypography.labelSmall.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCurrentTimeIndicator(ColorScheme colorScheme) {
    final top = (_now.hour + _now.minute / 60.0) * _hourHeight;
    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: Row(
        children: [
          Container(
            width: _timelineWidth,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 4),
            child: Text(
              '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}',
              style: AppTypography.labelSmall.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(
            child: Divider(color: Colors.red, thickness: 2, height: 1),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}

class _ResolvedHabit {
  final Habit habit;
  final HabitTime time;
  _ResolvedHabit(this.habit, this.time);
}
