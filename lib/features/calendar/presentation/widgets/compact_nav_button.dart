import 'package:flutter/material.dart';

/// Compact circular navigation button for the month selector.
///
/// A minimal, subtle button with an icon that provides
/// navigation controls for switching months.
class CompactNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CompactNavButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
          size: 16,
        ),
      ),
    );
  }
}
