import 'dart:ui';
import 'package:flutter/material.dart';

/// Compound App Typography System
///
/// Built with League Spartan font following Material 3 type scale.
/// Weights: 100 (Thin) to 900 (Black)
abstract final class AppTypography {
  static const String _fontFamily = 'LeagueSpartan';

  // ============================================
  // BASE TEXT STYLES
  // ============================================

  /// Display Large - Hero headlines, splash screens
  /// Size: 57, Weight: 400, Tracking: -0.25
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 57,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: -0.25,
    height: 1.12,
  );

  /// Display Medium - Section headers, cards
  /// Size: 45, Weight: 400, Tracking: 0
  static const TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 45,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0,
    height: 1.16,
  );

  /// Display Small - Prominent UI elements
  /// Size: 36, Weight: 400, Tracking: 0
  static const TextStyle displaySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0,
    height: 1.22,
  );

  /// Headline Large - Page titles
  /// Size: 32, Weight: 900, Tracking: -1.0
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontVariations: [FontVariation('wght', 900)],
    letterSpacing: -1.0,
    height: 1.25,
  );

  /// Headline Medium - Section titles
  /// Size: 28, Weight: 800, Tracking: -0.5
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontVariations: [FontVariation('wght', 800)],
    letterSpacing: -0.5,
    height: 1.29,
  );

  /// Headline Small - Subsection titles
  /// Size: 24, Weight: 800, Tracking: -0.5
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontVariations: [FontVariation('wght', 800)],
    letterSpacing: -0.5,
    height: 1.33,
  );

  /// Title Large - List item titles, dialog titles
  /// Size: 22, Weight: 800, Tracking: -0.5
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontVariations: [FontVariation('wght', 800)],
    letterSpacing: -0.5,
    height: 1.27,
  );

  /// Title Medium - Navigation titles, smaller cards
  /// Size: 18, Weight: 700, Tracking: 0
  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontVariations: [FontVariation('wght', 700)],
    letterSpacing: 0,
    height: 1.50,
  );

  /// Title Small - Tabs, chips, smaller nav
  /// Size: 14, Weight: 700, Tracking: 0.1
  static const TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontVariations: [FontVariation('wght', 700)],
    letterSpacing: 0.1,
    height: 1.43,
  );

  /// Body Large - Primary content text
  /// Size: 16, Weight: 400, Tracking: 0.5
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0.5,
    height: 1.50,
  );

  /// Body Medium - Secondary content text
  /// Size: 14, Weight: 400, Tracking: 0.25
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0.25,
    height: 1.43,
  );

  /// Body Small - Captions, timestamps
  /// Size: 12, Weight: 400, Tracking: 0.4
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0.4,
    height: 1.33,
  );

  /// Label Large - Buttons, prominent labels
  /// Size: 14, Weight: 600, Tracking: 0.1
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontVariations: [FontVariation('wght', 600)],
    letterSpacing: 0.1,
    height: 1.43,
  );

  /// Label Medium - Form labels, navigation
  /// Size: 12, Weight: 600, Tracking: 0.5
  static const TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontVariations: [FontVariation('wght', 600)],
    letterSpacing: 0.5,
    height: 1.33,
  );

  /// Label Small - Annotations, hints
  /// Size: 11, Weight: 500, Tracking: 0.5
  static const TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontVariations: [FontVariation('wght', 500)],
    letterSpacing: 0.5,
    height: 1.45,
  );

  // ============================================
  // COMPLETE TEXT THEME
  // ============================================

  /// Creates the complete TextTheme for the app
  static TextTheme textTheme({required Color color}) {
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: color),
      displayMedium: displayMedium.copyWith(color: color),
      displaySmall: displaySmall.copyWith(color: color),
      headlineLarge: headlineLarge.copyWith(color: color),
      headlineMedium: headlineMedium.copyWith(color: color),
      headlineSmall: headlineSmall.copyWith(color: color),
      titleLarge: titleLarge.copyWith(color: color),
      titleMedium: titleMedium.copyWith(color: color),
      titleSmall: titleSmall.copyWith(color: color),
      bodyLarge: bodyLarge.copyWith(color: color),
      bodyMedium: bodyMedium.copyWith(color: color),
      bodySmall: bodySmall.copyWith(color: color),
      labelLarge: labelLarge.copyWith(color: color),
      labelMedium: labelMedium.copyWith(color: color),
      labelSmall: labelSmall.copyWith(color: color),
    );
  }

  /// Dark theme text theme
  static TextTheme get darkTextTheme =>
      textTheme(color: const Color(0xFFFFFFFF));

  /// Light theme text theme
  static TextTheme get lightTextTheme =>
      textTheme(color: const Color(0xFF0A0A0A));
}
