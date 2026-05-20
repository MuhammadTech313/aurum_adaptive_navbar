import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../state/navbar_state.dart';

/// AURUM Logo Zone
///
/// Consists of a geometric mark (triangle-in-square SVG)
/// and the wordmark "AURUM" in Cormorant Garamond.
///
/// On scroll compression: wordmark fades and collapses width.
/// The mark scales down slightly for spatial harmony.
/// On hover: mark rotates -5°.
class LogoZone extends StatefulWidget {
  const LogoZone({super.key});

  @override
  State<LogoZone> createState() => _LogoZoneState();
}

class _LogoZoneState extends State<LogoZone> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: AurumTransitions.mid,
    );
    _rotateAnim = Tween<double>(begin: 0, end: -0.09).animate(
      CurvedAnimation(parent: _hoverController, curve: AurumTransitions.standard),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NavbarState>();
    final compressed = state.isCompressed;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: GestureDetector(
        onTap: () {
          // In a real app: Navigator.pushNamed(context, '/');
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Logo Mark ──
            AnimatedBuilder(
              animation: _rotateAnim,
              builder: (_, child) => Transform.rotate(
                angle: _rotateAnim.value,
                child: child,
              ),
              child: AnimatedContainer(
                duration: AurumTransitions.mid,
                curve: AurumTransitions.standard,
                width: compressed ? 22 : 28,
                height: compressed ? 22 : 28,
                child: const _AurumMark(),
              ),
            ),

            const SizedBox(width: 10),

            // ── Wordmark — collapses on compression ──
            ClipRect(
              child: AnimatedAlign(
                duration: AurumTransitions.slow,
                curve: AurumTransitions.refined,
                alignment: Alignment.centerLeft,
                widthFactor: compressed ? 0.0 : 1.0,
                child: AnimatedOpacity(
                  duration: AurumTransitions.mid,
                  opacity: compressed ? 0.0 : 1.0,
                  child: Text(
                    'AURUM',
                    style: AurumTypography.logoWordmark,
                    semanticsLabel: 'AURUM — Home',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The geometric AURUM mark: square outline + triangle + center circle
class _AurumMark extends StatelessWidget {
  const _AurumMark();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _AurumMarkPainter(color: AurumColors.accent),
    );
  }
}

class _AurumMarkPainter extends CustomPainter {
  final Color color;
  const _AurumMarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Outer square
    canvas.drawRect(
      Rect.fromLTWH(2, 2, w - 4, h - 4),
      paint,
    );

    // Inner triangle
    final triPath = Path()
      ..moveTo(w / 2, h * 0.18)
      ..lineTo(w * 0.82, h * 0.80)
      ..lineTo(w * 0.18, h * 0.80)
      ..close();
    canvas.drawPath(triPath, paint);

    // Center circle — filled at 60% opacity
    final circlePaint = Paint()
      ..color = color.withOpacity(0.60)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w / 2, h * 0.47), w * 0.073, circlePaint);
  }

  @override
  bool shouldRepaint(_AurumMarkPainter old) => old.color != color;
}
