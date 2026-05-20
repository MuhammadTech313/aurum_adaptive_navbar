import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/constants/nav_categories.dart';
import '../state/navbar_state.dart';

/// Mobile Bottom Dock
///
/// A floating pill that sits above the system navigation.
/// Five items: Jewels · Watches · Home (geometric mark) · Art · Account
///
/// Active state: monogram tinted with category accent, gold pip above.
/// The dock is a first-class mobile surface — not a collapsed desktop nav.
class BottomDock extends StatelessWidget {
  const BottomDock({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: const ColorFilter.linearToSrgbGamma(), // subtle saturation
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFAFAF9F7),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AurumColors.surfaceTertiary,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                const _DockItem(
                  index:   0,
                  label:   'Jewels',
                  content:  _GlyphContent(glyph: 'J'),
                ),
                const _DockItem(
                  index:   1,
                  label:   'Watches',
                  content:  _GlyphContent(glyph: 'W'),
                ),
                _DockItem(
                  index:   -1, // Home — not a category
                  label:   'Home',
                  content: const _HomeMarkContent(),
                  onTap:   () {},
                ),
                const _DockItem(
                  index:   3,
                  label:   'Art',
                  content: _GlyphContent(glyph: 'A'),
                ),
                _DockItem(
                  index:   -2, // Account — not a category
                  label:   'Account',
                  content: const _AccountContent(),
                  onTap:   () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DockItem extends StatefulWidget {
  final int        index;  // -1 or -2 for non-category items
  final String     label;
  final Widget     content;
  final VoidCallback? onTap;

  const _DockItem({
    required this.index,
    required this.label,
    required this.content,
    this.onTap,
  });

  @override
  State<_DockItem> createState() => _DockItemState();
}

class _DockItemState extends State<_DockItem>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final state     = context.watch<NavbarState>();
    final isActive  = widget.index >= 0 &&
        state.activeCategoryIndex == widget.index;

    final accent = widget.index >= 0
        ? AurumCategories.all[
            widget.index.clamp(0, AurumCategories.all.length - 1)
          ].accent
        : AurumColors.accent;

    return Expanded(
      child: GestureDetector(
        onTapDown:   (_) => setState(() => _pressed = true),
        onTapUp:     (_) => setState(() => _pressed = false),
        onTapCancel: ()  => setState(() => _pressed = false),
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          } else if (widget.index >= 0) {
            context.read<NavbarState>().setCategory(widget.index);
          }
        },
        child: AnimatedScale(
          scale: _pressed ? 0.88 : 1.0,
          duration: AurumTransitions.fast,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gold pip
              AnimatedOpacity(
                duration: AurumTransitions.fast,
                opacity: isActive ? 1.0 : 0.0,
                child: AnimatedContainer(
                  duration: AurumTransitions.fast,
                  width:  isActive ? 3 : 0,
                  height: isActive ? 3 : 0,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent,
                  ),
                ),
              ),

              // Icon area
              AnimatedContainer(
                duration: AurumTransitions.mid,
                curve: AurumTransitions.standard,
                width: 26, height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isActive
                      ? accent.withOpacity(0.15)
                      : Colors.transparent,
                ),
                child: Center(
                  child: _ContentWrapper(
                    content: widget.content,
                    isActive: isActive,
                    accent: accent,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // Label
              AnimatedDefaultTextStyle(
                duration: AurumTransitions.fast,
                style: isActive
                    ? AurumTypography.dockLabelActive
                    : AurumTypography.dockLabel,
                child: Text(widget.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentWrapper extends StatelessWidget {
  final Widget content;
  final bool   isActive;
  final Color  accent;

  const _ContentWrapper({
    required this.content,
    required this.isActive,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) => content;
}

/// Italic monogram glyph for category dock items
class _GlyphContent extends StatelessWidget {
  final String glyph;
  const _GlyphContent({required this.glyph});

  @override
  Widget build(BuildContext context) {
    return Text(
      glyph,
      style: GoogleFonts.cormorantGaramond(
        fontSize: 15,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
        color: AurumColors.inkTertiary,
      ),
    );
  }
}

/// Geometric home mark (circle + inner dot)
class _HomeMarkContent extends StatelessWidget {
  const _HomeMarkContent();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      size: Size(18, 18),
      painter: _HomeMarkPainter(color: AurumColors.inkTertiary),
    );
  }
}

class _HomeMarkPainter extends CustomPainter {
  final Color color;
  const _HomeMarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color       = color
      ..style       = PaintingStyle.stroke
      ..strokeWidth = 0.75;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2 - 0.5,
      paint,
    );

    final fillPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.11,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(_HomeMarkPainter old) => old.color != color;
}

/// Account person silhouette
class _AccountContent extends StatelessWidget {
  const _AccountContent();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      size: Size(16, 16),
      painter: _AccountPainter(color: AurumColors.inkTertiary),
    );
  }
}

class _AccountPainter extends CustomPainter {
  final Color color;
  const _AccountPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color       = color
      ..style       = PaintingStyle.stroke
      ..strokeWidth = 0.75
      ..strokeCap   = StrokeCap.round;

    // Head
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.38),
      size.width * 0.19,
      paint,
    );
    // Shoulders
    final path = Path()
      ..moveTo(size.width * 0.12, size.height)
      ..quadraticBezierTo(
        size.width / 2, size.height * 0.72,
        size.width * 0.88, size.height,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_AccountPainter old) => old.color != color;
}