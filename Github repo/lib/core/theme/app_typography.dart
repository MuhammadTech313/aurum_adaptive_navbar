import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// AURUM Typography System
///
/// Three-font pairing:
///   Display  → Cormorant Garamond (editorial, identity)
///   Body     → DM Sans (functional, clean)
///   Mono     → DM Mono (counts, hints, metadata)
abstract class AurumTypography {
  // ─── Display — Cormorant Garamond ───────────────────────
  static TextStyle get displayLarge => GoogleFonts.cormorantGaramond(
        fontSize: 72,
        fontWeight: FontWeight.w300,
        color: AurumColors.inkPrimary,
        letterSpacing: -0.5,
        height: 1.05,
      );

  static TextStyle get displayMedium => GoogleFonts.cormorantGaramond(
        fontSize: 48,
        fontWeight: FontWeight.w300,
        color: AurumColors.inkPrimary,
        height: 1.1,
      );

  static TextStyle get displaySmall => GoogleFonts.cormorantGaramond(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        color: AurumColors.inkPrimary,
        height: 1.15,
      );

  // Logo wordmark
  static TextStyle get logoWordmark => GoogleFonts.cormorantGaramond(
        fontSize: 19,
        fontWeight: FontWeight.w300,
        color: AurumColors.inkPrimary,
        letterSpacing: 0.22 * 19, // ~0.22em
      );

  // Navigation glyph (italic monogram)
  static TextStyle get navGlyph => GoogleFonts.cormorantGaramond(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
        color: AurumColors.inkTertiary,
        height: 1,
      );

  // ─── Body — DM Sans ─────────────────────────────────────
  static TextStyle get navLabel => GoogleFonts.dmSans(
        fontSize: 11.5,
        fontWeight: FontWeight.w400,
        color: AurumColors.inkTertiary,
        letterSpacing: 0.10 * 11.5,
      );

  static TextStyle get navLabelActive => GoogleFonts.dmSans(
        fontSize: 11.5,
        fontWeight: FontWeight.w500,
        color: AurumColors.inkSecondary,
        letterSpacing: 0.10 * 11.5,
      );

  static TextStyle get bodySmall => GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AurumColors.inkSecondary,
        letterSpacing: 0.02 * 13,
        height: 1.6,
      );

  static TextStyle get profileName => GoogleFonts.dmSans(
        fontSize: 11.5,
        fontWeight: FontWeight.w400,
        color: AurumColors.inkSecondary,
        letterSpacing: 0.04 * 11.5,
      );

  static TextStyle get searchPlaceholder => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
        color: AurumColors.inkQuaternary,
        letterSpacing: 0.02 * 12,
      );

  static TextStyle get searchInput => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AurumColors.inkPrimary,
        letterSpacing: 0.04 * 12,
      );

  static TextStyle get panelHead => GoogleFonts.dmMono(
        fontSize: 9,
        fontWeight: FontWeight.w400,
        color: AurumColors.inkQuaternary,
        letterSpacing: 0.20 * 9,
      );

  static TextStyle get panelItem => GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AurumColors.inkSecondary,
        letterSpacing: 0.02 * 13,
      );

  static TextStyle get panelItemCount => GoogleFonts.dmMono(
        fontSize: 9,
        fontWeight: FontWeight.w300,
        color: AurumColors.inkQuaternary,
        letterSpacing: 0.06 * 9,
      );

  // ─── Mono — DM Mono ─────────────────────────────────────
  static TextStyle get sectionLabel => GoogleFonts.dmMono(
        fontSize: 10,
        fontWeight: FontWeight.w300,
        color: AurumColors.inkTertiary,
        letterSpacing: 0.20 * 10,
      );

  static TextStyle get searchHint => GoogleFonts.dmMono(
        fontSize: 9,
        fontWeight: FontWeight.w300,
        color: AurumColors.inkQuaternary,
        letterSpacing: 0.06 * 9,
      );

  static TextStyle get tooltip => GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AurumColors.surfacePrimary,
        letterSpacing: 0.08 * 10,
      );

  static TextStyle get dockLabel => GoogleFonts.dmSans(
        fontSize: 9,
        fontWeight: FontWeight.w400,
        color: AurumColors.inkQuaternary,
        letterSpacing: 0.08 * 9,
      );

  static TextStyle get dockLabelActive => GoogleFonts.dmSans(
        fontSize: 9,
        fontWeight: FontWeight.w500,
        color: AurumColors.inkSecondary,
        letterSpacing: 0.08 * 9,
      );
}