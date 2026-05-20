import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

/// AURUM Icon Button
///
/// 34×34 circular button with hover tint and scale-on-press.
/// Optionally shows a small gold pip badge (e.g. cart count).
class AurumIconButton extends StatefulWidget {
  final Widget     icon;
  final VoidCallback onTap;
  final String?    tooltip;
  final bool       showBadge;

  const AurumIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.showBadge = false,
  });

  @override
  State<AurumIconButton> createState() => _AurumIconButtonState();
}

class _AurumIconButtonState extends State<AurumIconButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit:  (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTapDown:   (_) => setState(() => _pressed = true),
          onTapUp:     (_) => setState(() => _pressed = false),
          onTapCancel: ()  => setState(() => _pressed = false),
          onTap:       widget.onTap,
          child: AnimatedScale(
            scale: _pressed ? 0.90 : 1.0,
            duration: AurumTransitions.fast,
            curve: AurumTransitions.standard,
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: AurumTransitions.fast,
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _hovered
                        ? AurumColors.surfaceSecondary
                        : Colors.transparent,
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: AurumTransitions.fast,
                      style: TextStyle(
                        color: _hovered
                            ? AurumColors.inkSecondary
                            : AurumColors.inkTertiary,
                      ),
                      child: widget.icon,
                    ),
                  ),
                ),
                if (widget.showBadge)
                  Positioned(
                    top: 5, right: 4,
                    child: AnimatedContainer(
                      duration: AurumTransitions.fast,
                      width:  _hovered ? 9 : 8,
                      height: _hovered ? 9 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _hovered
                            ? AurumColors.accentDeep
                            : AurumColors.accent,
                        border: Border.all(
                          color: AurumColors.surfacePrimary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── SVG Icon Painters ──────────────────────────────────────

/// Wishlist heart icon
class WishlistIcon extends StatelessWidget {
  final Color color;
  const WishlistIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(15, 15),
      painter: _HeartPainter(color: color),
    );
  }
}

class _HeartPainter extends CustomPainter {
  final Color color;
  const _HeartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color       = color
      ..style       = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap   = StrokeCap.round
      ..strokeJoin  = StrokeJoin.round;

    final path = Path();
    path.moveTo(size.width / 2, size.height * 0.82);
    path.cubicTo(
      size.width * 0.1, size.height * 0.58,
      size.width * 0.1, size.height * 0.22,
      size.width / 2,   size.height * 0.30,
    );
    path.cubicTo(
      size.width * 0.9, size.height * 0.22,
      size.width * 0.9, size.height * 0.58,
      size.width / 2,   size.height * 0.82,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_HeartPainter old) => old.color != color;
}

/// Cart icon
class CartIcon extends StatelessWidget {
  final Color color;
  const CartIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(15, 15),
      painter: _CartPainter(color: color),
    );
  }
}

class _CartPainter extends CustomPainter {
  final Color color;
  const _CartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color       = color
      ..style       = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap   = StrokeCap.round
      ..strokeJoin  = StrokeJoin.round;

    // Bag outline
    final path = Path()
      ..moveTo(2, 2)
      ..lineTo(3.5, 2)
      ..lineTo(5.5, 10)
      ..lineTo(12.5, 10)
      ..lineTo(14, 5)
      ..lineTo(4.5, 5);
    canvas.drawPath(path, paint);

    // Wheels
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(7, 12.5), 0.75, dotPaint);
    canvas.drawCircle(const Offset(11, 12.5), 0.75, dotPaint);
  }

  @override
  bool shouldRepaint(_CartPainter old) => old.color != color;
}