import 'package:flutter/material.dart';

/// Compound App Border Radius System
///
/// Consistent corner radii for a cohesive visual language.
abstract final class AppRadius {
  // ============================================
  // BASE RADIUS SCALE
  // ============================================

  /// No radius - sharp corners
  static const double none = 0;

  /// 4px - Subtle rounding
  static const double xs = 4;

  /// 8px - Small rounding (chips, badges)
  static const double sm = 8;

  /// 12px - Medium rounding (cards, buttons)
  static const double md = 12;

  /// 16px - Large rounding (modals, sheets)
  static const double lg = 16;

  /// 20px - Extra large rounding
  static const double xl = 20;

  /// 24px - Extra extra large
  static const double xxl = 24;

  /// 32px - Huge rounding
  static const double xxxl = 32;

  /// Full circle / pill shape
  static const double full = 9999;

  // ============================================
  // BORDER RADIUS INSTANCES
  // ============================================

  /// No radius
  static const BorderRadius roundedNone = BorderRadius.zero;

  /// 4px all corners
  static const BorderRadius roundedXs = BorderRadius.all(Radius.circular(xs));

  /// 8px all corners
  static const BorderRadius roundedSm = BorderRadius.all(Radius.circular(sm));

  /// 12px all corners
  static const BorderRadius roundedMd = BorderRadius.all(Radius.circular(md));

  /// 16px all corners
  static const BorderRadius roundedLg = BorderRadius.all(Radius.circular(lg));

  /// 20px all corners
  static const BorderRadius roundedXl = BorderRadius.all(Radius.circular(xl));

  /// 24px all corners
  static const BorderRadius roundedXxl = BorderRadius.all(Radius.circular(xxl));

  /// 32px all corners
  static const BorderRadius roundedXxxl = BorderRadius.all(
    Radius.circular(xxxl),
  );

  /// Full pill shape
  static const BorderRadius roundedFull = BorderRadius.all(
    Radius.circular(full),
  );

  // ============================================
  // SPECIAL BORDER RADIUS
  // ============================================

  /// Top only - for bottom sheets, modals
  static const BorderRadius topLg = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );

  /// Top only - larger variant
  static const BorderRadius topXl = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );

  /// Top only - extra large
  static const BorderRadius topXxl = BorderRadius.only(
    topLeft: Radius.circular(xxl),
    topRight: Radius.circular(xxl),
  );

  /// Bottom only
  static const BorderRadius bottomLg = BorderRadius.only(
    bottomLeft: Radius.circular(lg),
    bottomRight: Radius.circular(lg),
  );
}
