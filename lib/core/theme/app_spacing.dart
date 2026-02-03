/// Compound App Spacing System
///
/// Consistent spacing scale based on 4px base unit.
/// Use these values for margins, padding, and gaps.
abstract final class AppSpacing {
  // ============================================
  // BASE SPACING SCALE
  // ============================================

  /// 0px - No spacing
  static const double none = 0;

  /// 2px - Micro spacing (icons, tight elements)
  static const double xxs = 2;

  /// 4px - Extra small spacing
  static const double xs = 4;

  /// 8px - Small spacing (compact UI)
  static const double sm = 8;

  /// 12px - Medium-small spacing
  static const double md = 12;

  /// 16px - Medium spacing (standard padding)
  static const double lg = 16;

  /// 20px - Medium-large spacing
  static const double xl = 20;

  /// 24px - Large spacing (section padding)
  static const double xxl = 24;

  /// 32px - Extra large spacing
  static const double xxxl = 32;

  /// 40px - Huge spacing
  static const double huge = 40;

  /// 48px - Section breaks
  static const double section = 48;

  /// 64px - Major section breaks
  static const double sectionLarge = 64;

  /// 80px - Page-level spacing
  static const double page = 80;

  /// 96px - Extra page spacing
  static const double pageLarge = 96;

  // ============================================
  // SEMANTIC SPACING
  // ============================================

  /// Card internal padding
  static const double cardPadding = lg;

  /// List item vertical spacing
  static const double listItemSpacing = md;

  /// Screen horizontal padding
  static const double screenHorizontal = lg;

  /// Screen vertical padding
  static const double screenVertical = xxl;

  /// Button internal padding horizontal
  static const double buttonPaddingH = xl;

  /// Button internal padding vertical
  static const double buttonPaddingV = md;

  /// Input field padding
  static const double inputPadding = lg;

  /// Icon and text gap
  static const double iconTextGap = sm;

  /// Chip internal padding
  static const double chipPadding = sm;
}
