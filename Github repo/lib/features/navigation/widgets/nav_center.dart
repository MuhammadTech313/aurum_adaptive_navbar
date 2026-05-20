import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/nav_categories.dart';
import '../state/navbar_state.dart';
import 'nav_item.dart';

/// Center navigation section of the Meridian Bar.
///
/// Lays out [NavItem]s in a row, exposes [GlobalKey]s for each item
/// so the parent [Stack] can position the [AccentStrip] precisely.
class NavCenter extends StatefulWidget {
  /// Keys are passed up so the parent can measure item positions
  final List<GlobalKey> itemKeys;

  const NavCenter({super.key, required this.itemKeys});

  @override
  State<NavCenter> createState() => _NavCenterState();
}

class _NavCenterState extends State<NavCenter> {
  @override
  Widget build(BuildContext context) {
    final state      = context.watch<NavbarState>();
    final compressed = state.isCompressed;
    final activeIdx  = state.activeCategoryIndex;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(AurumCategories.all.length, (i) {
        final cat = AurumCategories.all[i];
        return KeyedSubtree(
          key: widget.itemKeys[i],
          child: NavItem(
            label:        cat.label,
            glyph:        cat.glyph,
            isActive:     activeIdx == i,
            isCompressed: compressed,
            onTap: () {
              state.setCategory(i);
              state.showPanel(i);
            },
            onHoverEnter: () {
              state.setHoveredCategory(i);
              state.showPanel(i);
            },
            onHoverExit: () {
              state.setHoveredCategory(null);
              // Panel hide is handled by the panel's own mouse region
            },
          ),
        );
      }),
    );
  }
}