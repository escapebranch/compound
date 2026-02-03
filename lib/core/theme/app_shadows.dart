import 'package:flutter/material.dart';

/// Compound App Shadow System
///
/// Layered elevation shadows for depth perception.
/// Designed for both light and dark themes.
abstract final class AppShadows {
  // ============================================
  // DARK THEME SHADOWS
  // ============================================

  /// No shadow
  static const List<BoxShadow> none = [];

  /// Dark theme - Subtle elevation (cards, buttons)
  static const List<BoxShadow> darkSm = [
    BoxShadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  /// Dark theme - Medium elevation (dropdowns, popovers)
  static const List<BoxShadow> darkMd = [
    BoxShadow(color: Color(0x30000000), blurRadius: 8, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x20000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  /// Dark theme - High elevation (modals, dialogs)
  static const List<BoxShadow> darkLg = [
    BoxShadow(color: Color(0x40000000), blurRadius: 16, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x30000000), blurRadius: 8, offset: Offset(0, 4)),
  ];

  /// Dark theme - Highest elevation (floating elements)
  static const List<BoxShadow> darkXl = [
    BoxShadow(color: Color(0x50000000), blurRadius: 24, offset: Offset(0, 12)),
    BoxShadow(color: Color(0x30000000), blurRadius: 12, offset: Offset(0, 6)),
  ];

  // ============================================
  // LIGHT THEME SHADOWS
  // ============================================

  /// Light theme - Subtle elevation
  static const List<BoxShadow> lightSm = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0F000000), blurRadius: 2, offset: Offset(0, 1)),
  ];

  /// Light theme - Medium elevation
  static const List<BoxShadow> lightMd = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  /// Light theme - High elevation
  static const List<BoxShadow> lightLg = [
    BoxShadow(color: Color(0x12000000), blurRadius: 20, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 4)),
  ];

  /// Light theme - Highest elevation
  static const List<BoxShadow> lightXl = [
    BoxShadow(color: Color(0x14000000), blurRadius: 32, offset: Offset(0, 16)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 6)),
  ];

  // ============================================
  // GLOW EFFECTS
  // ============================================

  /// Soft white glow (for dark theme accents)
  static const List<BoxShadow> glowWhite = [
    BoxShadow(color: Color(0x20FFFFFF), blurRadius: 12, spreadRadius: 2),
  ];

  /// Subtle inner glow
  static const List<BoxShadow> innerGlow = [
    BoxShadow(color: Color(0x10FFFFFF), blurRadius: 8, spreadRadius: -2),
  ];
}
