import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:compound/main.dart' show installYear;

class YearPickerButton extends StatefulWidget {
  final int currentYear;
  final ValueChanged<int> onYearSelected;

  const YearPickerButton({
    super.key,
    required this.currentYear,
    required this.onYearSelected,
  });

  @override
  State<YearPickerButton> createState() => _YearPickerButtonState();
}

class _YearPickerButtonState extends State<YearPickerButton> {
  final GlobalKey _buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final currentYear = DateTime.now().year;
    final hasMultipleYears = currentYear > installYear;

    return GestureDetector(
      key: _buttonKey,
      onTap: hasMultipleYears ? () => _showPopover(context) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.currentYear.toString(),
            style: textTheme.titleMedium?.copyWith(
              fontVariations: [const FontVariation('wght', 600)],
              color: colorScheme.onSurface,
              letterSpacing: 0.5,
              fontSize: 18,
            ),
          ),
          if (hasMultipleYears) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ],
      ),
    );
  }

  void _showPopover(BuildContext context) {
    final RenderBox button =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    final colorScheme = Theme.of(context).colorScheme;

    // Year range: from install year to current year (no future)
    final currentYear = DateTime.now().year;
    final yearCount = currentYear - installYear + 1;
    final years = List.generate(yearCount, (index) => currentYear - index);

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        int selectedYear = widget.currentYear;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Stack(
              children: [
                Positioned(
                  left: buttonPosition.dx - 20,
                  top: buttonPosition.dy + button.size.height + 8,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 120,
                      height: 220,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.15),
                          width: 0.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListWheelScrollView.useDelegate(
                                itemExtent: 44,
                                perspective: 0.003,
                                diameterRatio: 1.5,
                                physics: const FixedExtentScrollPhysics(),
                                controller: FixedExtentScrollController(
                                  initialItem: years.indexOf(selectedYear) != -1
                                      ? years.indexOf(selectedYear)
                                      : years.indexOf(currentYear),
                                ),
                                onSelectedItemChanged: (index) {
                                  setDialogState(() {
                                    selectedYear = years[index];
                                  });
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: years.length,
                                  builder: (context, index) {
                                    final year = years[index];
                                    final isSelected = selectedYear == year;
                                    return Center(
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(
                                          milliseconds: 150,
                                        ),
                                        style: TextStyle(
                                          fontFamily: 'LeagueSpartan',
                                          color: isSelected
                                              ? colorScheme.onSurface
                                              : colorScheme.onSurface
                                                    .withValues(alpha: 0.35),
                                          fontSize: isSelected ? 20 : 16,
                                          fontVariations: [
                                            FontVariation(
                                              'wght',
                                              isSelected ? 600 : 400,
                                            ),
                                          ],
                                        ),
                                        child: Text(year.toString()),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // Confirm Button
                            GestureDetector(
                              onTap: () {
                                widget.onYearSelected(selectedYear);
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: colorScheme.outline.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 20,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
