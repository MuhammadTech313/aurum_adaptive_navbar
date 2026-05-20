import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AurumTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AurumColors.surfacePrimary,
      colorScheme: const ColorScheme.light(
        primary: AurumColors.accent,
        onPrimary: AurumColors.surfacePrimary,
        secondary: AurumColors.accentDeep,
        surface: AurumColors.surfacePrimary,
        onSurface: AurumColors.inkPrimary,
      ),
      textTheme: GoogleFonts.dmSansTextTheme().apply(
        bodyColor: AurumColors.inkPrimary,
        displayColor: AurumColors.inkPrimary,
      ),
      dividerColor: AurumColors.divider,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }
}