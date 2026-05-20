import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/constants/nav_categories.dart';
import '../state/navbar_state.dart';

/// Profile Pill
///
/// Combines a circular avatar (first-letter monogram) with the user's
/// first name. The name collapses in compressed/tablet mode.
/// Border and background subtly respond to hover.
class ProfilePill extends StatefulWidget {
  final String name;
  final VoidCallback? onTap;

  const ProfilePill({
    super.key,
    this.name = 'Eleanor',
    this.onTap,
  });

  @override
  State<ProfilePill> createState() => _ProfilePillState();
}

class _ProfilePillState extends State<ProfilePill> {
  bool _hovered = false;

  String get _initial => widget.name.isNotEmpty
      ? widget.name[0].toUpperCase()
      : 'E';

  @override
  Widget build(BuildContext context) {
    final state      = context.watch<NavbarState>();
    final compressed = state.isCompressed;

    // Use category accent for avatar tint
    final accentColor = AurumCategories.all[
      state.activeCategoryIndex.clamp(0, AurumCategories.all.length - 1)
    ].accent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AurumTransitions.fast,
          padding: const EdgeInsets.only(top: 3, bottom: 3, right: 10, left: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: _hovered
                  ? AurumColors.surfaceTertiary
                  : AurumColors.surfaceTertiary,
              width: 1,
            ),
            color: _hovered
                ? AurumColors.surfaceSecondary
                : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar circle
              Container(
                width: 26, height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withOpacity(0.15),
                  border: Border.all(
                    color: accentColor.withOpacity(0.30),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    _initial,
                    style: GoogleFontsHelper.cormorantMono.copyWith(
                      fontSize: 12,
                      color: accentColor.withOpacity(0.85),
                    ),
                  ),
                ),
              ),

              // Name — collapses on compression
              ClipRect(
                child: AnimatedAlign(
                  duration: AurumTransitions.slow,
                  curve: AurumTransitions.refined,
                  alignment: Alignment.centerLeft,
                  widthFactor: compressed ? 0.0 : 1.0,
                  child: AnimatedOpacity(
                    duration: AurumTransitions.mid,
                    opacity: compressed ? 0.0 : 1.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        widget.name,
                        style: AurumTypography.profileName,
                      ),
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
}

/// Tiny helper to get Cormorant style without importing google_fonts everywhere
abstract class GoogleFontsHelper {
  static TextStyle get cormorantMono {
    return const TextStyle(
      fontFamily: 'Cormorant Garamond',
      fontWeight: FontWeight.w400,
    );
  }
}