import 'package:aurum_nav/features/navigation/widgets/action_zone.dart';
import 'package:aurum_nav/features/navigation/widgets/category_panel.dart';
import 'package:aurum_nav/features/navigation/widgets/logo_zone.dart';
import 'package:aurum_nav/features/navigation/widgets/nav_center.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/constants/nav_categories.dart';
import 'state/navbar_state.dart';
/// The Meridian Bar — AURUM's primary navigation surface.
///
/// Three behavioral states:
///   Resting    → full height (64px), wordmark + labels visible
///   Compressed → 52px, wordmark collapses, labels → glyphs
///   Command    → search expanded, focus shifts to input
///
/// The Accent Strip slides beneath the active/hovered category.
/// The Category Panel drops below the bar on hover.
///
/// Architecture:
///   MeridianBar (Stack)
///     └── _BarSurface (ClipRect + backdrop blur)
///         └── _BarInner (Row: LogoZone · NavCenter · ActionZone)
///     └── AccentStrip (Positioned, animated via GlobalKeys)
class MeridianBar extends StatefulWidget {
  const MeridianBar({super.key});

  @override
  State<MeridianBar> createState() => _MeridianBarState();
}

class _MeridianBarState extends State<MeridianBar> {
  // One GlobalKey per nav item — used to measure position for AccentStrip
  final List<GlobalKey> _itemKeys = List.generate(
    AurumCategories.all.length,
    (_) => GlobalKey(),
  );

  // Accent strip state — updated after layout
  double _stripLeft  = 0;
  double _stripWidth = 80;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateStrip());
  }

  void _updateStrip() {
    final state    = context.read<NavbarState>();
    final idx      = state.displayCategoryIndex;
    _measureItem(idx);
  }

  void _measureItem(int idx) {
    final clamped = idx.clamp(0, _itemKeys.length - 1);
    final key     = _itemKeys[clamped];
    final box     = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final barBox = context.findRenderObject() as RenderBox?;
    if (barBox == null) return;

    final global = box.localToGlobal(Offset.zero);
    final local  = barBox.globalToLocal(global);

    if (mounted) {
      setState(() {
        _stripLeft  = local.dx;
        _stripWidth = box.size.width;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state      = context.watch<NavbarState>();
    final barH       = state.isCompressed ? 52.0 : 64.0;
    final hPad       = state.isCompressed ? 20.0 : 28.0;

    // Re-measure strip whenever display index changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureItem(state.displayCategoryIndex);
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Bar surface ──────────────────────────────────────
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Background with subtle blur
            AnimatedContainer(
              duration: AurumTransitions.mid,
              curve: AurumTransitions.standard,
              height: barH,
              decoration: const BoxDecoration(
                color: Color(0xF7FAF9F7),
                border: Border(
                  bottom: BorderSide(
                    color: AurumColors.divider,
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Row(
                  children: [
                    // Logo
                    const LogoZone(),

                    // Nav center — stretches between logo and actions
                    Expanded(
                      child: NavCenter(itemKeys: _itemKeys),
                    ),

                    // Actions
                    const ActionZone(),
                  ],
                ),
              ),
            ),

            // Accent strip — absolutely positioned at bottom of bar
            AnimatedPositioned(
              duration: AurumTransitions.slow,
              curve: AurumTransitions.refined,
              bottom: 0,
              left: _stripLeft,
              child: AnimatedContainer(
                duration: AurumTransitions.slow,
                curve: AurumTransitions.refined,
                width: _stripWidth,
                height: 1.5,
                color: AurumCategories.all[
                  state.displayCategoryIndex.clamp(
                    0, AurumCategories.all.length - 1,
                  )
                ].accent,
              ),
            ),
          ],
        ),

        // ── Category Panel ───────────────────────────────────
        const CategoryPanel(),
      ],
    );
  }
}