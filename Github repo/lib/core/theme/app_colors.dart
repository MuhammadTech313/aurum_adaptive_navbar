import 'package:flutter/material.dart';

/// AURUM Design System — Color Tokens
///
/// A warm, mineral palette anchored in antique gold.
/// Every color is named for its semantic role, not its hue.
abstract class AurumColors {
  // ─── Ink Scale ──────────────────────────────────────────
  static const Color inkPrimary    = Color(0xFF0F0E0D);
  static const Color inkSecondary  = Color(0xFF3A3835);
  static const Color inkTertiary   = Color(0xFF7A786F);
  static const Color inkQuaternary = Color(0xFFB8B4AB);

  // ─── Surface Scale ──────────────────────────────────────
  static const Color surfacePrimary   = Color(0xFFFAF9F7);
  static const Color surfaceSecondary = Color(0xFFF2F0EC);
  static const Color surfaceTertiary  = Color(0xFFE8E5DE);

  // ─── Accent — Gold ──────────────────────────────────────
  static const Color accent         = Color(0xFFC8A96E);
  static const Color accentDeep     = Color(0xFF9B7D4A);
  static const Color accentPale     = Color(0x1FC8A96E); // 12% opacity
  static const Color accentPaleMid  = Color(0x3FC8A96E); // 25% opacity

  // ─── Category Accent Strip Colors ───────────────────────
  /// Each category has its own tinted accent for the indicator strip.
  static const List<Color> categoryAccents = [
    Color(0xFFC8A96E), // Jewellery — antique gold
    Color(0xFF8FA8B8), // Watches   — steel blue
    Color(0xFFB8A0A0), // Fashion   — dusty rose
    Color(0xFF9AA89A), // Art       — sage
    Color(0xFFC0A882), // Curated   — warm tan
  ];

  // ─── Transparent / Overlay ──────────────────────────────
  static const Color barrierLight = Color(0x14000000);
  static const Color navBarBg     = Color(0xF7FAF9F7); // 97% opaque surface

  // ─── Semantic ───────────────────────────────────────────
  static const Color divider = Color(0xFFE8E5DE);

  // Helper: get category accent by index
  static Color categoryAccent(int index) {
    return categoryAccents[index.clamp(0, categoryAccents.length - 1)];
  }
}