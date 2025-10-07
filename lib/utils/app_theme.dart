import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryOrange,
        onPrimary: AppColors.lightText,
        secondary: AppColors.pressedOrange,
        onSecondary: AppColors.lightText,
        surface: AppColors.lightCream,
        onSurface: AppColors.primaryText,
        background: AppColors.creamBeige,
        onBackground: AppColors.primaryText,
        error: AppColors.angry,
        onError: AppColors.lightText,
      ),
      scaffoldBackgroundColor: AppColors.creamBeige,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.creamBeige,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
          fontFamily: 'SF Pro Display',
        ),
      ),
      textTheme: const TextTheme(
        // H1 - Titles
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
          fontFamily: 'SF Pro Display',
        ),
        // H2 - Section Headers
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
          fontFamily: 'SF Pro Display',
        ),
        // H3 - Card Titles
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
          fontFamily: 'SF Pro Display',
        ),
        // Body - Regular Text
        bodyLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
          fontFamily: 'SF Pro Display',
        ),
        // Small Text
        bodyMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
          fontFamily: 'SF Pro Display',
        ),
        // Caption
        bodySmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.secondaryText,
          fontFamily: 'SF Pro Display',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: AppColors.lightText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryOrange,
          side: const BorderSide(color: AppColors.primaryOrange, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryOrange,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightCream,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(
          color: AppColors.secondaryText,
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontFamily: 'SF Pro Display',
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: AppColors.lightText,
        elevation: 4,
        shape: CircleBorder(),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        elevation: 8,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
          fontFamily: 'SF Pro Display',
        ),
        contentTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: AppColors.primaryText,
          fontFamily: 'SF Pro Display',
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkCharcoal,
        contentTextStyle: const TextStyle(
          color: AppColors.lightText,
          fontSize: 16,
          fontFamily: 'SF Pro Display',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Dark theme (for future implementation)
  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      // Add dark theme customizations here
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryOrange,
        onPrimary: AppColors.lightText,
        secondary: AppColors.pressedOrange,
        onSecondary: AppColors.lightText,
        surface: AppColors.darkCharcoal,
        onSurface: AppColors.lightText,
        background: const Color(0xFF1A1A1A),
        onBackground: AppColors.lightText,
        error: AppColors.angry,
        onError: AppColors.lightText,
      ),
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    );
  }
}