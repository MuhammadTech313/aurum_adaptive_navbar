import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/theme.dart';
import '../widgets/icon_button_aurum.dart';

/// Mobile Top Bar
///
/// A minimal top surface showing: menu icon · AURUM wordmark · cart.
/// Intentionally different from the desktop bar — not a collapsed version.
/// The wordmark is always centered; flanked by symmetrical icon buttons.
class MobileTopBar extends StatelessWidget {
  const MobileTopBar({super.key});

  static const double height = 56;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false, // Only apply safe area to the top
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: Color(0xFFFAF9F7),
          border: Border(
            bottom: BorderSide(color: AurumColors.divider, width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Menu
              AurumIconButton(
                tooltip: 'Menu',
                onTap:   () => Scaffold.of(context).openDrawer(),
                icon:    const _MenuIcon(color: AurumColors.inkSecondary),
              ),

              // Centered wordmark
              const Expanded(
                child: Center(
                  child: _MobileWordmark(),
                ),
              ),

              // Cart
              AurumIconButton(
                tooltip:   'Cart',
                showBadge: true,
                onTap:     () {},
                icon:      const CartIcon(color: AurumColors.inkSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileWordmark extends StatelessWidget {
  const _MobileWordmark();

  @override
  Widget build(BuildContext context) {
    return Text(
      'AURUM',
      style: GoogleFonts.cormorantGaramond(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.22 * 18,
        color: AurumColors.inkPrimary,
      ),
    );
  }
}

class _MenuIcon extends StatelessWidget {
  final Color color;
  const _MenuIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(16, 16),
      painter: _MenuPainter(color: color),
    );
  }
}

class _MenuPainter extends CustomPainter {
  final Color color;
  const _MenuPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color       = color
      ..strokeWidth = 1.0
      ..strokeCap   = StrokeCap.round;

    // Two lines of different widths — asymmetric refinement
    canvas.drawLine(
      Offset(0, size.height * 0.35),
      Offset(size.width, size.height * 0.35),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.65),
      Offset(size.width * 0.68, size.height * 0.65),
      paint,
    );
  }

  @override
  bool shouldRepaint(_MenuPainter old) => old.color != color;
}