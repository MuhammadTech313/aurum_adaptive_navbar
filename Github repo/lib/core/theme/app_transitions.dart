import 'package:flutter/material.dart';

/// AURUM Animation System
///
/// Named durations enforce a consistent rhythm.
/// Curves are tuned for luxury feel — smooth, never bouncy.
abstract class AurumTransitions {
  // ─── Durations ──────────────────────────────────────────
  static const Duration fast   = Duration(milliseconds: 180);
  static const Duration mid    = Duration(milliseconds: 320);
  static const Duration slow   = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 700);

  // ─── Curves ─────────────────────────────────────────────
  /// Standard ease — for most UI transitions
  static const Curve standard = Curves.easeInOut;

  /// Decelerate — for elements entering the screen
  static const Curve enter = Curves.easeOutCubic;

  /// Accelerate — for elements leaving the screen
  static const Curve exit = Curves.easeInCubic;

  /// Refined ease — for accent strip sliding
  static const Curve refined = Curves.easeInOutQuart;

  // ─── Convenience tween constructors ─────────────────────
  static Animation<double> fade({
    required AnimationController controller,
    Curve curve = standard,
    double begin = 0,
    double end = 1,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  static Animation<double> size({
    required AnimationController controller,
    Curve curve = standard,
    double begin = 0,
    double end = 1,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }
}