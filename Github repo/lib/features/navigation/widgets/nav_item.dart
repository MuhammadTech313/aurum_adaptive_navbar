import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

/// Single navigation item in the Meridian Bar
///
/// Morphs between:
///   Resting    → uppercase label text (DM Sans)
///   Compressed → italic monogram glyph (Cormorant Garamond)
///
/// A tooltip appears in compressed state on hover.
class NavItem extends StatefulWidget {
  final String  label;
  final String  glyph;
  final bool    isActive;
  final bool    isCompressed;
  final VoidCallback  onTap;
  final VoidCallback? onHoverEnter;
  final VoidCallback? onHoverExit;

  const NavItem({
    super.key,
    required this.label,
    required this.glyph,
    required this.isActive,
    required this.isCompressed,
    required this.onTap,
    this.onHoverEnter,
    this.onHoverExit,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hovered = true);
        widget.onHoverEnter?.call();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        widget.onHoverExit?.call();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Content: label or glyph ──
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isCompressed ? 8 : 14,
                ),
                child: AnimatedSwitcher(
                  duration: AurumTransitions.mid,
                  switchInCurve: AurumTransitions.enter,
                  switchOutCurve: AurumTransitions.exit,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: child,
                  ),
                  child: widget.isCompressed
                      ? _buildGlyph()
                      : _buildLabel(),
                ),
              ),

              // ── Tooltip (visible only in compressed + hovered) ──
              if (widget.isCompressed)
                Positioned(
                  bottom: -28,
                  child: AnimatedOpacity(
                    duration: AurumTransitions.fast,
                    opacity: _hovered ? 1.0 : 0.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AurumColors.inkPrimary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        widget.label.toUpperCase(),
                        style: AurumTypography.tooltip,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    final style = widget.isActive
        ? AurumTypography.navLabelActive
        : AurumTypography.navLabel.copyWith(
            color: _hovered
                ? AurumColors.inkSecondary
                : AurumColors.inkTertiary,
          );

    return Text(
      widget.label.toUpperCase(),
      key: ValueKey('label_${widget.label}'),
      style: style,
    );
  }

  Widget _buildGlyph() {
    final color = widget.isActive
        ? AurumColors.inkSecondary
        : _hovered
            ? AurumColors.inkSecondary
            : AurumColors.inkTertiary;

    return Text(
      widget.glyph,
      key: ValueKey('glyph_${widget.glyph}'),
      style: AurumTypography.navGlyph.copyWith(color: color),
    );
  }
}