import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppColors {
  static const Color background =
      Color(0xFF101311);

  static const Color surface =
      Color(0xFF181C19);

  static const Color surfaceElevated =
      Color(0xFF202621);

  static const Color primaryGreen =
      Color(0xFF4F9255);

  static const Color brightGreen =
      Color(0xFF65A86B);

  static const Color darkGreen =
      Color(0xFF173D1D);

  static const Color secondaryGreen =
      Color(0xFF26352A);

  static const Color text =
      Color(0xFFF2F5F0);

  static const Color secondaryText =
      Color(0xFFA5AEA6);

  static const Color mutedText =
      Color(0xFF737C74);

  static const Color border =
      Color(0xFF2B332D);

  static const Color confidenceBackground =
      Color(0xFF29432E);

  static const Color confidenceText =
      Color(0xFFB9D8BC);
}


class AppTheme {
  static ThemeData get dark {
    final colorScheme = const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: AppColors.primaryGreen,
      onPrimary: Colors.white,
      secondary: AppColors.brightGreen,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.text,
      surfaceContainerHighest:
          AppColors.surfaceElevated,
      outline:
          AppColors.border,
      outlineVariant:
          AppColors.border,
      error:
          Color(0xFFE57373),
      onError:
          Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          AppColors.background,

      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: AppColors.text,
        displayColor: AppColors.text,
      ),

      appBarTheme:
          const AppBarTheme(
        backgroundColor:
            AppColors.background,
        foregroundColor:
            AppColors.text,
        elevation: 0,
        surfaceTintColor:
            Colors.transparent,
      ),

      cardTheme:
          CardThemeData(
        color:
            AppColors.surface,
        elevation: 0,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20),
          side: const BorderSide(
            color:
                AppColors.border,
          ),
        ),
      ),

      filledButtonTheme:
          FilledButtonThemeData(
        style:
            FilledButton.styleFrom(
          backgroundColor:
              AppColors.primaryGreen,
          foregroundColor:
              Colors.white,
          disabledBackgroundColor:
              AppColors.primaryGreen
                  .withValues(alpha: 0.28),
          disabledForegroundColor:
              Colors.white
                  .withValues(alpha: 0.55),
          elevation: 0,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
        ),
      ),

      textButtonTheme:
          TextButtonThemeData(
        style:
            TextButton.styleFrom(
          foregroundColor:
              AppColors.brightGreen,
        ),
      ),

      bottomSheetTheme:
          const BottomSheetThemeData(
        backgroundColor:
            AppColors.surface,
        modalBackgroundColor:
            AppColors.surface,
        surfaceTintColor:
            Colors.transparent,
        showDragHandle: false,
      ),

      sliderTheme:
          const SliderThemeData(
        activeTrackColor:
            AppColors.primaryGreen,
        thumbColor:
            AppColors.brightGreen,
        inactiveTrackColor:
            AppColors.border,
      ),

      dividerTheme:
          const DividerThemeData(
        color: AppColors.border,
      ),
    );
  }
}