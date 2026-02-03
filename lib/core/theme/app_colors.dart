import 'package:flutter/material.dart';

/// Compound App Color System
///
/// A sophisticated monochromatic color palette designed for
/// both light and dark themes with proper contrast ratios.
abstract final class AppColors {
  // ============================================
  // NEUTRAL SCALE (Gray Palette)
  // ============================================

  /// Pure black - Primary dark mode background
  static const Color neutral950 = Color(0xFF0A0A0A);

  /// Near-black - Dark mode elevated surfaces
  static const Color neutral900 = Color(0xFF121212);

  /// Dark gray - Dark mode cards/containers
  static const Color neutral850 = Color(0xFF1A1A1A);

  /// Medium-dark gray - Dark mode secondary surfaces
  static const Color neutral800 = Color(0xFF1F1F1F);

  /// Dark mode borders & dividers
  static const Color neutral700 = Color(0xFF2C2C2E);

  /// Disabled/muted elements dark mode
  static const Color neutral600 = Color(0xFF3A3A3C);

  /// Secondary text dark mode
  static const Color neutral500 = Color(0xFF636366);

  /// Tertiary text / placeholders
  static const Color neutral400 = Color(0xFF8E8E93);

  /// Light mode borders & dividers
  static const Color neutral300 = Color(0xFFC7C7CC);

  /// Light mode disabled states
  static const Color neutral200 = Color(0xFFE5E5EA);

  /// Light mode secondary surfaces
  static const Color neutral100 = Color(0xFFF2F2F7);

  /// Light mode elevated surfaces
  static const Color neutral50 = Color(0xFFF8F8FA);

  /// Pure white - Primary light mode background
  static const Color neutral0 = Color(0xFFFFFFFF);

  // ============================================
  // ACCENT COLORS (Subtle monochrome accents)
  // ============================================

  /// Warm white for highlights
  static const Color warmWhite = Color(0xFFFAFAFA);

  /// Cool white for subtle differentiation
  static const Color coolWhite = Color(0xFFF5F7FA);

  /// Soft shadow color
  static const Color shadowDark = Color(0x40000000);

  /// Light shadow color
  static const Color shadowLight = Color(0x1A000000);

  // ============================================
  // SEMANTIC COLORS
  // ============================================

  /// Success state
  static const Color success = Color(0xFF34C759);

  /// Warning state
  static const Color warning = Color(0xFFFF9500);

  /// Error state
  static const Color error = Color(0xFFFF3B30);

  /// Info state
  static const Color info = Color(0xFF5AC8FA);
}

/// Dark Theme Color Scheme
abstract final class DarkColors {
  static const Color background = AppColors.neutral950;
  static const Color surface = AppColors.neutral900;
  static const Color surfaceElevated = AppColors.neutral850;
  static const Color surfaceContainer = AppColors.neutral800;
  static const Color border = AppColors.neutral700;
  static const Color borderSubtle = Color(0xFF252528);
  static const Color textPrimary = AppColors.neutral0;
  static const Color textSecondary = AppColors.neutral400;
  static const Color textTertiary = AppColors.neutral500;
  static const Color textDisabled = AppColors.neutral600;
  static const Color iconPrimary = AppColors.neutral0;
  static const Color iconSecondary = AppColors.neutral400;
}

/// Light Theme Color Scheme
abstract final class LightColors {
  static const Color background = AppColors.neutral0;
  static const Color surface = AppColors.neutral50;
  static const Color surfaceElevated = AppColors.neutral0;
  static const Color surfaceContainer = AppColors.neutral100;
  static const Color border = AppColors.neutral200;
  static const Color borderSubtle = AppColors.neutral100;
  static const Color textPrimary = AppColors.neutral950;
  static const Color textSecondary = AppColors.neutral500;
  static const Color textTertiary = AppColors.neutral400;
  static const Color textDisabled = AppColors.neutral300;
  static const Color iconPrimary = AppColors.neutral950;
  static const Color iconSecondary = AppColors.neutral500;
}
