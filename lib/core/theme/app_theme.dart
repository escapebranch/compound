import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';

/// Compound App Theme
///
/// AMOLED-first, fully monochromatic design system.
/// Uses pure black backgrounds with translucent layers for depth.
abstract final class AppTheme {
  // ============================================
  // DARK THEME (AMOLED-First)
  // ============================================

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'LeagueSpartan',

      // Color Scheme - Pure black AMOLED
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.white,
        onPrimary: AppColors.black,
        primaryContainer: AppColors.neutral800,
        onPrimaryContainer: AppColors.white,
        secondary: AppColors.neutral400,
        onSecondary: AppColors.black,
        secondaryContainer: AppColors.neutral700,
        onSecondaryContainer: AppColors.neutral100,
        tertiary: AppColors.neutral500,
        onTertiary: AppColors.white,
        tertiaryContainer: AppColors.neutral800,
        onTertiaryContainer: AppColors.neutral200,
        error: AppColors.error,
        onError: AppColors.white,
        errorContainer: Color(0xFF93000A),
        onErrorContainer: Color(0xFFFFDAD6),
        surface: DarkColors.surface,
        onSurface: DarkColors.textPrimary,
        surfaceContainerHighest: DarkColors.surfaceContainer,
        onSurfaceVariant: DarkColors.textSecondary,
        outline: DarkColors.border,
        outlineVariant: DarkColors.borderSubtle,
        shadow: AppColors.black,
        scrim: AppColors.black,
        inverseSurface: AppColors.neutral100,
        onInverseSurface: AppColors.neutral900,
        inversePrimary: AppColors.neutral800,
        surfaceTint: Colors.transparent,
      ),

      // Scaffold - Pure black
      scaffoldBackgroundColor: DarkColors.background,

      // Typography
      textTheme: AppTypography.darkTextTheme,

      // AppBar - Pure black, no elevation
      appBarTheme: AppBarTheme(
        backgroundColor: DarkColors.background,
        foregroundColor: DarkColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: DarkColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: DarkColors.iconPrimary, size: 24),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // Card - Minimal border, near-black
      cardTheme: CardThemeData(
        color: DarkColors.surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.roundedMd,
          side: BorderSide(
            color: DarkColors.border.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Outlined Button - Subtle border
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
          side: BorderSide(
            color: DarkColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Icon Button
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: DarkColors.iconPrimary),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
      ),

      // Input Decoration - Translucent fill
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.whiteOverlay05,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: BorderSide(
            color: DarkColors.border.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: BorderSide(
            color: AppColors.white.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: DarkColors.textTertiary,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: DarkColors.textSecondary,
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DarkColors.background,
        selectedItemColor: AppColors.white,
        unselectedItemColor: DarkColors.textTertiary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: DarkColors.background,
        indicatorColor: AppColors.whiteOverlay10,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelMedium.copyWith(color: AppColors.white);
          }
          return AppTypography.labelMedium.copyWith(
            color: DarkColors.textTertiary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.white, size: 24);
          }
          return const IconThemeData(color: DarkColors.iconSecondary, size: 24);
        }),
        elevation: 0,
        height: 80,
      ),

      // Bottom Sheet - Translucent dark
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: DarkColors.surfaceElevated,
        modalBackgroundColor: DarkColors.surfaceElevated,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.topXxl),
        dragHandleColor: AppColors.neutral600,
        dragHandleSize: const Size(40, 4),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: DarkColors.surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedXl),
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: DarkColors.textPrimary,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: DarkColors.textSecondary,
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.neutral100,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.neutral900,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // Chip - Minimal styling
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.whiteOverlay05,
        selectedColor: AppColors.white,
        disabledColor: DarkColors.surfaceContainer,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: DarkColors.textPrimary,
        ),
        secondaryLabelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.black,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.roundedFull,
          side: BorderSide(
            color: DarkColors.border.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),

      // Divider - Very subtle
      dividerTheme: DividerThemeData(
        color: DarkColors.border.withValues(alpha: 0.3),
        thickness: 0.5,
        space: 0.5,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.whiteOverlay05,
        iconColor: DarkColors.iconSecondary,
        textColor: DarkColors.textPrimary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
        titleTextStyle: AppTypography.bodyLarge.copyWith(
          color: DarkColors.textPrimary,
        ),
        subtitleTextStyle: AppTypography.bodySmall.copyWith(
          color: DarkColors.textSecondary,
        ),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.black;
          }
          return AppColors.neutral400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.white;
          }
          return AppColors.whiteOverlay10;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return DarkColors.border;
        }),
      ),

      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.white,
        linearTrackColor: AppColors.whiteOverlay10,
        circularTrackColor: AppColors.whiteOverlay10,
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: AppRadius.roundedSm,
        ),
        textStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.neutral900,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Scrollbar
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.whiteOverlay20),
        trackColor: WidgetStateProperty.all(Colors.transparent),
        radius: const Radius.circular(4),
        thickness: WidgetStateProperty.all(4),
      ),

      // Splash / Highlight - Very subtle
      splashColor: AppColors.whiteOverlay05,
      highlightColor: AppColors.whiteOverlay05,
      hoverColor: AppColors.whiteOverlay05,
      focusColor: AppColors.whiteOverlay10,
    );
  }

  // ============================================
  // LIGHT THEME (Strictly Monochrome)
  // ============================================

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'LeagueSpartan',

      // Color Scheme - Pure white, monochrome
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: Color(0xFF1A1A1A),
        onPrimary: AppColors.white,
        primaryContainer: AppColors.neutral100,
        onPrimaryContainer: AppColors.neutral900,
        secondary: AppColors.neutral500,
        onSecondary: AppColors.white,
        secondaryContainer: AppColors.neutral200,
        onSecondaryContainer: AppColors.neutral800,
        tertiary: AppColors.neutral400,
        onTertiary: Color(0xFF1A1A1A),
        tertiaryContainer: AppColors.neutral100,
        onTertiaryContainer: AppColors.neutral700,
        error: AppColors.error,
        onError: AppColors.white,
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF410002),
        surface: LightColors.surface,
        onSurface: LightColors.textPrimary,
        surfaceContainerHighest: LightColors.surfaceContainer,
        onSurfaceVariant: LightColors.textSecondary,
        outline: LightColors.border,
        outlineVariant: LightColors.borderSubtle,
        shadow: AppColors.black,
        scrim: AppColors.black,
        inverseSurface: AppColors.neutral800,
        onInverseSurface: AppColors.neutral100,
        inversePrimary: AppColors.neutral200,
        surfaceTint: Colors.transparent,
      ),

      // Scaffold
      scaffoldBackgroundColor: LightColors.background,

      // Typography
      textTheme: AppTypography.lightTextTheme,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: LightColors.background,
        foregroundColor: LightColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: LightColors.textPrimary,
        ),
        iconTheme: const IconThemeData(
          color: LightColors.iconPrimary,
          size: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // Card - Minimal border
      cardTheme: CardThemeData(
        color: LightColors.surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.roundedMd,
          side: BorderSide(
            color: LightColors.border.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A1A1A),
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1A1A1A),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
          side: BorderSide(
            color: LightColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF1A1A1A),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Icon Button
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: LightColors.iconPrimary),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.blackOverlay05,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: BorderSide(
            color: LightColors.border.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: BorderSide(
            color: const Color(0xFF1A1A1A).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: LightColors.textTertiary,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: LightColors.textSecondary,
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: LightColors.background,
        selectedItemColor: Color(0xFF1A1A1A),
        unselectedItemColor: LightColors.textTertiary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: LightColors.background,
        indicatorColor: AppColors.blackOverlay10,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelMedium.copyWith(
              color: const Color(0xFF1A1A1A),
            );
          }
          return AppTypography.labelMedium.copyWith(
            color: LightColors.textTertiary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Color(0xFF1A1A1A), size: 24);
          }
          return const IconThemeData(
            color: LightColors.iconSecondary,
            size: 24,
          );
        }),
        elevation: 0,
        height: 80,
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: LightColors.surfaceElevated,
        modalBackgroundColor: LightColors.surfaceElevated,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.topXxl),
        dragHandleColor: AppColors.neutral300,
        dragHandleSize: const Size(40, 4),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: LightColors.surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedXl),
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: LightColors.textPrimary,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: LightColors.textSecondary,
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.neutral900,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.neutral100,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.blackOverlay05,
        selectedColor: const Color(0xFF1A1A1A),
        disabledColor: LightColors.surfaceContainer,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: LightColors.textPrimary,
        ),
        secondaryLabelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.roundedFull,
          side: BorderSide(
            color: LightColors.border.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),

      // Divider - Very subtle
      dividerTheme: DividerThemeData(
        color: LightColors.border.withValues(alpha: 0.3),
        thickness: 0.5,
        space: 0.5,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.blackOverlay05,
        iconColor: LightColors.iconSecondary,
        textColor: LightColors.textPrimary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
        titleTextStyle: AppTypography.bodyLarge.copyWith(
          color: LightColors.textPrimary,
        ),
        subtitleTextStyle: AppTypography.bodySmall.copyWith(
          color: LightColors.textSecondary,
        ),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.white;
          }
          return AppColors.neutral500;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF1A1A1A);
          }
          return AppColors.blackOverlay10;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return LightColors.border;
        }),
      ),

      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: const Color(0xFF1A1A1A),
        linearTrackColor: AppColors.blackOverlay10,
        circularTrackColor: AppColors.blackOverlay10,
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.neutral900,
          borderRadius: AppRadius.roundedSm,
        ),
        textStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.neutral100,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Scrollbar
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.blackOverlay20),
        trackColor: WidgetStateProperty.all(Colors.transparent),
        radius: const Radius.circular(4),
        thickness: WidgetStateProperty.all(4),
      ),

      // Splash / Highlight - Very subtle
      splashColor: AppColors.blackOverlay05,
      highlightColor: AppColors.blackOverlay05,
      hoverColor: AppColors.blackOverlay05,
      focusColor: AppColors.blackOverlay10,
    );
  }
}
