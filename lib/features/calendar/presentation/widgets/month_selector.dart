import 'package:flutter/material.dart';
import 'package:compound/main.dart' show installYear, installMonth;

import 'compact_nav_button.dart';

/// Month Selector Widget
///
/// A compact, pill-shaped month navigation component with
/// refined AMOLED-first styling and proper typography hierarchy.
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

  static const List<String> _months = [
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final currentDate = widget.currentDate;
    final onMonthChanged = widget.onMonthChanged;

    final prevDate = DateTime(currentDate.year, currentDate.month - 1);
    final nextDate = DateTime(currentDate.year, currentDate.month + 1);

    final bool hasPrevMonth =
        !(prevDate.year < installYear ||
            (prevDate.year == installYear && prevDate.month < installMonth));

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Center(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0 && hasPrevMonth) {
              onMonthChanged(-1);
            } else if (details.primaryVelocity! < 0) {
              onMonthChanged(1);
            }
          },
          child: Container(
            width: 220,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.1),
                width: 0.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Subtle Glow Indicator
                  _buildGlowIndicator(colorScheme),
                  // Navigation Items
                  _buildNavigationRow(
                    colorScheme: colorScheme,
                    currentDate: currentDate,
                    prevDate: prevDate,
                    nextDate: nextDate,
                    hasPrevMonth: hasPrevMonth,
                    onMonthChanged: onMonthChanged,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlowIndicator(ColorScheme colorScheme) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      key: ValueKey(widget.currentDate.month),
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Subtle Glow
            Positioned(
              bottom: 0,
              child: Container(
                width: 30 + (8 * value),
                height: 10,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, 1.0),
                    radius: 0.8,
                    colors: [
                      colorScheme.onSurface.withValues(alpha: 0.12 * value),
                      colorScheme.onSurface.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Minimal Indicator Bar
            Positioned(
              bottom: 0,
              child: Container(
                width: 12 + (6 * value),
                height: 1,
                margin: const EdgeInsets.only(bottom: 0.5),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(
                    alpha: 0.2 + (0.5 * value),
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.onSurface.withValues(
                        alpha: 0.2 * value,
                      ),
                      blurRadius: 3,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNavigationRow({
    required ColorScheme colorScheme,
    required DateTime currentDate,
    required DateTime prevDate,
    required DateTime nextDate,
    required bool hasPrevMonth,
    required ValueChanged<int> onMonthChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IgnorePointer(
            ignoring: !hasPrevMonth,
            child: Opacity(
              opacity: hasPrevMonth ? 1.0 : 0.0,
              child: CompactNavButton(
                icon: Icons.chevron_left,
                onPressed: () => onMonthChanged(-1),
              ),
            ),
          ),
          // Animated Month Labels
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                final isEntering = child.key == ValueKey(currentDate.month);

                Offset beginOffset;
                if (isEntering) {
                  beginOffset = _isMovingForward
                      ? const Offset(0.3, 0)
                      : const Offset(-0.3, 0);
                } else {
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
                  Opacity(
                    opacity: hasPrevMonth ? 1.0 : 0.0,
                    child: _buildMonthLabel(
                      text: _months[prevDate.month - 1],
                      isActive: false,
                      colorScheme: colorScheme,
                    ),
                  ),
                  // Current Month
                  _buildMonthLabel(
                    text: _months[currentDate.month - 1],
                    isActive: true,
                    colorScheme: colorScheme,
                  ),
                  // Next Month
                  _buildMonthLabel(
                    text: _months[nextDate.month - 1],
                    isActive: false,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
          ),
          CompactNavButton(
            icon: Icons.chevron_right,
            onPressed: () => onMonthChanged(1),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthLabel({
    required String text,
    required bool isActive,
    required ColorScheme colorScheme,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 66 : 32,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isActive ? 1.0 : 0.35,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: isActive ? 13 : 10,
            fontVariations: [FontVariation('wght', isActive ? 600 : 500)],
            letterSpacing: isActive ? 1.2 : 0.8,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
