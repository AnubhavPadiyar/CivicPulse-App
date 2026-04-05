import 'package:flutter/material.dart';

class AppColors {
  static const blue = Color(0xFF2C5AA0);
  static const blueDark = Color(0xFF1e3f72);
  static const blueLight = Color(0xFFC1E4F9);
  static const blueSoft = Color(0xFFEBF4FD);
  static const teal = Color(0xFF00A8A8);
  static const tealSoft = Color(0xFFE0F5F5);
  static const bg = Color(0xFFF5F7FA);
  static const white = Color(0xFFFFFFFF);
  static const text = Color(0xFF222222);
  static const textMid = Color(0xFF4A5568);
  static const textLight = Color(0xFF8896A5);
  static const border = Color(0xFFE2E8F0);
  static const error = Color(0xFFC0392B);
  static const errorSoft = Color(0xFFFFF0F0);
  static const successSoft = Color(0xFFE8FBF5);
  static const successText = Color(0xFF1A7A50);
  static const successBorder = Color(0xFFB8F0DA);

  static const tagOrangeBg = Color(0xFFFFF4E6);
  static const tagOrangeText = Color(0xFFC87C00);
  static const tagRedBg = Color(0xFFFFF0F0);
  static const tagRedText = Color(0xFFC0392B);
  static const tagGreenBg = Color(0xFFE8FBF5);
  static const tagGreenText = Color(0xFF1A7A50);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Plus Jakarta Sans',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.text,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: AppColors.text,
          ),
          iconTheme: IconThemeData(color: AppColors.text),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
            shadowColor: AppColors.blue.withOpacity(0.3),
            textStyle: const TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.bg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
          ),
          labelStyle: const TextStyle(
            color: AppColors.textMid,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          hintStyle: const TextStyle(
            color: AppColors.textLight,
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        ),
      );
}
