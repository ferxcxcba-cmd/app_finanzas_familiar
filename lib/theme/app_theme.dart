import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        tertiary: AppColors.accentColor,
        error: AppColors.errorColor,
        background: AppColors.backgroundColor,
        surface: AppColors.surfaceColor,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        titleTextStyle: TextStyle(
          color: AppColors.textColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Text Themes
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
        displayMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
        displaySmall: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
        headlineMedium: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor,
        ),
        titleMedium: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textColor,
        ),
        bodySmall: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondaryColor,
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          ),
          elevation: 4,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey[100],
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(
            color: AppColors.errorColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
      ),

      // Card Theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        color: AppColors.surfaceColor,
      ),

      // Bottom Navigation Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceColor,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey[400],
        elevation: 8,
      ),
    );
  }
}
