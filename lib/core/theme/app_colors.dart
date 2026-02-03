import 'package:flutter/material.dart';

/// Compound App Color System
///
/// A true AMOLED-first, fully monochromatic color palette.
/// Prioritizes pure black for backgrounds with transparent layers for depth.
abstract final class AppColors {
  // ============================================
  // CORE BLACKS (AMOLED-Optimized)
  // ============================================

  /// Pure black - AMOLED primary background
  static const Color black = Color(0xFF000000);

  /// Near-black - Subtle separation only when needed
  static const Color nearBlack = Color(0xFF050505);

  /// Deep black - Minimal elevation
  static const Color deepBlack = Color(0xFF0A0A0A);

  // ============================================
  // NEUTRAL SCALE (Grayscale)
  // ============================================

  /// Darkest gray - Only for essential contrast
  static const Color neutral900 = Color(0xFF0F0F0F);

  /// Dark gray - Elevated surfaces in dark mode
  static const Color neutral850 = Color(0xFF141414);

  /// Medium-dark gray
  static const Color neutral800 = Color(0xFF1A1A1A);

  /// Border tone dark mode
  static const Color neutral700 = Color(0xFF242424);

  /// Subtle dividers
  static const Color neutral600 = Color(0xFF2E2E2E);

  /// Muted/disabled elements
  static const Color neutral500 = Color(0xFF555555);

  /// Secondary text
  static const Color neutral400 = Color(0xFF808080);

  /// Tertiary text / placeholders
  static const Color neutral350 = Color(0xFF9A9A9A);

  /// Light mode borders
  static const Color neutral300 = Color(0xFFB5B5B5);

  /// Light mode disabled states
  static const Color neutral200 = Color(0xFFD0D0D0);

  /// Light mode subtle surfaces
  static const Color neutral100 = Color(0xFFE8E8E8);

  /// Off-white - Light mode secondary background
  static const Color neutral50 = Color(0xFFF5F5F5);

  /// Pure white
  static const Color white = Color(0xFFFFFFFF);

  // ============================================
  // TRANSPARENT LAYERS (For depth without solid grays)
  // ============================================

  /// Transparent black - 90% opacity
  static const Color blackOverlay90 = Color(0xE6000000);

  /// Transparent black - 80% opacity
  static const Color blackOverlay80 = Color(0xCC000000);

  /// Transparent black - 60% opacity
  static const Color blackOverlay60 = Color(0x99000000);

  /// Transparent black - 40% opacity
  static const Color blackOverlay40 = Color(0x66000000);

  /// Transparent black - 20% opacity
  static const Color blackOverlay20 = Color(0x33000000);

  /// Transparent black - 10% opacity
  static const Color blackOverlay10 = Color(0x1A000000);

  /// Transparent black - 5% opacity
  static const Color blackOverlay05 = Color(0x0D000000);

  /// Transparent white - 90% opacity
  static const Color whiteOverlay90 = Color(0xE6FFFFFF);

  /// Transparent white - 60% opacity
  static const Color whiteOverlay60 = Color(0x99FFFFFF);

  /// Transparent white - 20% opacity
  static const Color whiteOverlay20 = Color(0x33FFFFFF);

  /// Transparent white - 10% opacity
  static const Color whiteOverlay10 = Color(0x1AFFFFFF);

  /// Transparent white - 5% opacity
  static const Color whiteOverlay05 = Color(0x0DFFFFFF);

  // ============================================
  // SEMANTIC COLORS (Minimal, muted tones)
  // ============================================

  /// Success state (muted)
  static const Color success = Color(0xFF4CAF50);

  /// Warning state (muted)
  static const Color warning = Color(0xFFFFA726);

  /// Error state (muted)
  static const Color error = Color(0xFFEF5350);

  /// Info state (muted)
  static const Color info = Color(0xFF42A5F5);
}

/// Dark Theme Color Scheme (AMOLED-First with visible surfaces)
abstract final class DarkColors {
  /// Pure black background for AMOLED
  static const Color background = AppColors.black;

  /// Translucent surface - Use transparency instead of solid gray
  static const Color surface = AppColors.black;

  /// Slightly elevated surface
  static const Color surfaceElevated = Color(0xFF0C0C0C);

  /// Container surface
  static const Color surfaceContainer = Color(0xFF121212);

  /// Primary border
  static const Color border = Color(0xFF222222);

  /// Subtle border
  static const Color borderSubtle = Color(0xFF181818);

  /// Primary text - Pure white
  static const Color textPrimary = AppColors.white;

  /// Secondary text - Slightly dimmed
  static const Color textSecondary = Color(0xFFAAAAAA);

  /// Tertiary text - More dimmed for hierarchy
  static const Color textTertiary = Color(0xFF777777);

  /// Disabled text
  static const Color textDisabled = Color(0xFF555555);

  /// Primary icons
  static const Color iconPrimary = AppColors.white;

  /// Secondary icons
  static const Color iconSecondary = Color(0xFF888888);
}

/// Light Theme Color Scheme (Strictly Monochrome)
abstract final class LightColors {
  /// Pure white background
  static const Color background = AppColors.white;

  /// Off-white surface
  static const Color surface = Color(0xFFFAFAFA);

  /// Elevated surface - pure white
  static const Color surfaceElevated = AppColors.white;

  /// Container surface - subtle gray
  static const Color surfaceContainer = Color(0xFFF2F2F2);

  /// Primary border - subtle
  static const Color border = Color(0xFFE0E0E0);

  /// Subtle border
  static const Color borderSubtle = Color(0xFFF0F0F0);

  /// Primary text - Not pure black, softer contrast
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// Secondary text - Hierarchy level 2
  static const Color textSecondary = Color(0xFF666666);

  /// Tertiary text - Hierarchy level 3
  static const Color textTertiary = Color(0xFF999999);

  /// Disabled text
  static const Color textDisabled = Color(0xFFBBBBBB);

  /// Primary icons
  static const Color iconPrimary = Color(0xFF1A1A1A);

  /// Secondary icons
  static const Color iconSecondary = Color(0xFF777777);
}
