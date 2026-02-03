import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';

/// Compound App Theme
///
/// Unified theme configuration for the entire application.
/// Supports both light and dark modes with seamless switching.
abstract final class AppTheme {
  // ============================================
  // DARK THEME
  // ============================================

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'LeagueSpartan',

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.neutral0,
        onPrimary: AppColors.neutral950,
        primaryContainer: AppColors.neutral800,
        onPrimaryContainer: AppColors.neutral0,
        secondary: AppColors.neutral400,
        onSecondary: AppColors.neutral950,
        secondaryContainer: AppColors.neutral700,
        onSecondaryContainer: AppColors.neutral100,
        tertiary: AppColors.neutral500,
        onTertiary: AppColors.neutral0,
        tertiaryContainer: AppColors.neutral800,
        onTertiaryContainer: AppColors.neutral200,
        error: AppColors.error,
        onError: AppColors.neutral0,
        errorContainer: Color(0xFF93000A),
        onErrorContainer: Color(0xFFFFDAD6),
        surface: DarkColors.surface,
        onSurface: DarkColors.textPrimary,
        surfaceContainerHighest: DarkColors.surfaceContainer,
        onSurfaceVariant: DarkColors.textSecondary,
        outline: DarkColors.border,
        outlineVariant: DarkColors.borderSubtle,
        shadow: AppColors.neutral950,
        scrim: AppColors.neutral950,
        inverseSurface: AppColors.neutral100,
        onInverseSurface: AppColors.neutral900,
        inversePrimary: AppColors.neutral800,
        surfaceTint: Colors.transparent,
      ),

      // Scaffold
      scaffoldBackgroundColor: DarkColors.background,

      // Typography
      textTheme: AppTypography.darkTextTheme,

      // AppBar
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

      // Card
      cardTheme: CardThemeData(
        color: DarkColors.surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.roundedMd,
          side: BorderSide(
            color: DarkColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neutral0,
          foregroundColor: AppColors.neutral950,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.neutral0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
          side: const BorderSide(color: DarkColors.border, width: 1),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.neutral0,
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
        backgroundColor: AppColors.neutral0,
        foregroundColor: AppColors.neutral950,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DarkColors.surfaceContainer,
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
            color: DarkColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: const BorderSide(color: AppColors.neutral0, width: 1.5),
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
        backgroundColor: DarkColors.surface,
        selectedItemColor: AppColors.neutral0,
        unselectedItemColor: DarkColors.textTertiary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: DarkColors.surface,
        indicatorColor: AppColors.neutral700,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelMedium.copyWith(
              color: AppColors.neutral0,
            );
          }
          return AppTypography.labelMedium.copyWith(
            color: DarkColors.textTertiary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.neutral0, size: 24);
          }
          return const IconThemeData(color: DarkColors.iconSecondary, size: 24);
        }),
        elevation: 0,
        height: 80,
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: DarkColors.surfaceElevated,
        modalBackgroundColor: DarkColors.surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.topXxl),
        dragHandleColor: AppColors.neutral600,
        dragHandleSize: Size(40, 4),
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
        elevation: 4,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: DarkColors.surfaceContainer,
        selectedColor: AppColors.neutral0,
        disabledColor: DarkColors.surfaceContainer,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: DarkColors.textPrimary,
        ),
        secondaryLabelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.neutral950,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.roundedFull,
          side: BorderSide(
            color: DarkColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: DarkColors.border.withValues(alpha: 0.5),
        thickness: 1,
        space: 1,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: DarkColors.surfaceContainer,
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
            return AppColors.neutral950;
          }
          return AppColors.neutral400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.neutral0;
          }
          return DarkColors.surfaceContainer;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return DarkColors.border;
        }),
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.neutral0,
        linearTrackColor: DarkColors.surfaceContainer,
        circularTrackColor: DarkColors.surfaceContainer,
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
        thumbColor: WidgetStateProperty.all(AppColors.neutral600),
        trackColor: WidgetStateProperty.all(Colors.transparent),
        radius: const Radius.circular(4),
        thickness: WidgetStateProperty.all(4),
      ),

      // Splash / Highlight
      splashColor: AppColors.neutral0.withValues(alpha: 0.08),
      highlightColor: AppColors.neutral0.withValues(alpha: 0.04),
      hoverColor: AppColors.neutral0.withValues(alpha: 0.04),
      focusColor: AppColors.neutral0.withValues(alpha: 0.08),
    );
  }

  // ============================================
  // LIGHT THEME
  // ============================================

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'LeagueSpartan',

      // Color Scheme
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: AppColors.neutral950,
        onPrimary: AppColors.neutral0,
        primaryContainer: AppColors.neutral100,
        onPrimaryContainer: AppColors.neutral900,
        secondary: AppColors.neutral500,
        onSecondary: AppColors.neutral0,
        secondaryContainer: AppColors.neutral200,
        onSecondaryContainer: AppColors.neutral800,
        tertiary: AppColors.neutral400,
        onTertiary: AppColors.neutral950,
        tertiaryContainer: AppColors.neutral100,
        onTertiaryContainer: AppColors.neutral700,
        error: AppColors.error,
        onError: AppColors.neutral0,
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF410002),
        surface: LightColors.surface,
        onSurface: LightColors.textPrimary,
        surfaceContainerHighest: LightColors.surfaceContainer,
        onSurfaceVariant: LightColors.textSecondary,
        outline: LightColors.border,
        outlineVariant: LightColors.borderSubtle,
        shadow: AppColors.neutral950,
        scrim: AppColors.neutral950,
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

      // Card
      cardTheme: CardThemeData(
        color: LightColors.surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.roundedMd,
          side: BorderSide(
            color: LightColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neutral950,
          foregroundColor: AppColors.neutral0,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.neutral950,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
          side: const BorderSide(color: LightColors.border, width: 1),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.neutral950,
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
        backgroundColor: AppColors.neutral950,
        foregroundColor: AppColors.neutral0,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LightColors.surfaceContainer,
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
            color: LightColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: const BorderSide(color: AppColors.neutral950, width: 1.5),
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
        backgroundColor: LightColors.surface,
        selectedItemColor: AppColors.neutral950,
        unselectedItemColor: LightColors.textTertiary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: LightColors.surface,
        indicatorColor: AppColors.neutral200,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelMedium.copyWith(
              color: AppColors.neutral950,
            );
          }
          return AppTypography.labelMedium.copyWith(
            color: LightColors.textTertiary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.neutral950, size: 24);
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
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: LightColors.surfaceElevated,
        modalBackgroundColor: LightColors.surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.topXxl),
        dragHandleColor: AppColors.neutral300,
        dragHandleSize: Size(40, 4),
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
        elevation: 4,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: LightColors.surfaceContainer,
        selectedColor: AppColors.neutral950,
        disabledColor: LightColors.surfaceContainer,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: LightColors.textPrimary,
        ),
        secondaryLabelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.neutral0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.roundedFull,
          side: BorderSide(
            color: LightColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: LightColors.border.withValues(alpha: 0.5),
        thickness: 1,
        space: 1,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: LightColors.surfaceContainer,
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
            return AppColors.neutral0;
          }
          return AppColors.neutral500;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.neutral950;
          }
          return LightColors.surfaceContainer;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return LightColors.border;
        }),
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.neutral950,
        linearTrackColor: LightColors.surfaceContainer,
        circularTrackColor: LightColors.surfaceContainer,
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
        thumbColor: WidgetStateProperty.all(AppColors.neutral300),
        trackColor: WidgetStateProperty.all(Colors.transparent),
        radius: const Radius.circular(4),
        thickness: WidgetStateProperty.all(4),
      ),

      // Splash / Highlight
      splashColor: AppColors.neutral950.withValues(alpha: 0.08),
      highlightColor: AppColors.neutral950.withValues(alpha: 0.04),
      hoverColor: AppColors.neutral950.withValues(alpha: 0.04),
      focusColor: AppColors.neutral950.withValues(alpha: 0.08),
    );
  }
}
