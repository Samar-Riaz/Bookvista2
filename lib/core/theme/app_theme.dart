import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        tertiary: AppColors.accentLight,
        background: AppColors.backgroundLight,
        surface: AppColors.surfaceLight,
        onPrimary: Colors.white,
        onBackground: AppColors.textPrimaryLight,
        onSurface: AppColors.textPrimaryLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.satisfy(color: AppColors.primaryLight, fontSize: 40),
        headlineLarge: GoogleFonts.notoSerif(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold, fontSize: 32),
        headlineMedium: GoogleFonts.notoSerif(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600, fontSize: 24),
        titleLarge: GoogleFonts.notoSerif(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w500, fontSize: 20),
        bodyLarge: GoogleFonts.inter(color: AppColors.textPrimaryLight, fontSize: 18, height: 1.6),
        bodyMedium: GoogleFonts.inter(color: AppColors.textSecondaryLight, fontSize: 16, height: 1.6),
        labelSmall: GoogleFonts.inter(color: AppColors.textSecondaryLight, fontWeight: FontWeight.w600, letterSpacing: 0.05),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.latte,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          elevation: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: const Color(0xFFC3B1E1).withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.textSecondaryDark,
        tertiary: AppColors.accentDark,
        background: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,
        onPrimary: AppColors.backgroundDark,
        onBackground: AppColors.textPrimaryDark,
        onSurface: AppColors.textPrimaryDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.satisfy(color: AppColors.primaryDark, fontSize: 40),
        headlineLarge: GoogleFonts.notoSerif(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold, fontSize: 32),
        headlineMedium: GoogleFonts.notoSerif(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600, fontSize: 24),
        titleLarge: GoogleFonts.notoSerif(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w500, fontSize: 20),
        bodyLarge: GoogleFonts.inter(color: AppColors.textPrimaryDark, fontSize: 18, height: 1.6),
        bodyMedium: GoogleFonts.inter(color: AppColors.textSecondaryDark, fontSize: 16, height: 1.6),
        labelSmall: GoogleFonts.inter(color: AppColors.textSecondaryDark, fontWeight: FontWeight.w600, letterSpacing: 0.05),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.latte,
          foregroundColor: AppColors.backgroundDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          elevation: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark.withOpacity(0.8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.latte.withOpacity(0.2), width: 1),
        ),
      ),
    );
  }
}
