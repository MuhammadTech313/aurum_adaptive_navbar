import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/constants/nav_categories.dart';
import '../state/navbar_state.dart';

/// Category Dropdown Panel
///
/// Slides down from below the navbar when a category is hovered.
/// Contains 4 columns of curated sub-categories.
/// Hides on mouse exit from both the nav items and the panel.
class CategoryPanel extends StatelessWidget {
  const CategoryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final state   = context.watch<NavbarState>();
    final visible = state.isPanelVisible && !state.isMobile;
    final catIdx  = state.panelCategoryIndex;
    final cat     = AurumCategories.all[catIdx.clamp(0, AurumCategories.all.length - 1)];

    return AnimatedOpacity(
      duration: AurumTransitions.mid,
      curve: AurumTransitions.enter,
      opacity: visible ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: AurumTransitions.mid,
        curve: AurumTransitions.enter,
        offset: visible ? Offset.zero : const Offset(0, -0.04),
        child: IgnorePointer(
          ignoring: !visible,
          child: MouseRegion(
            onExit: (_) => context.read<NavbarState>().hidePanel(),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFAF9F7).withOpacity(0.99),
                border: const Border(
                  bottom: BorderSide(color: AurumColors.divider, width: 1),
                ),
              ),
              child: AnimatedSwitcher(
                duration: AurumTransitions.fast,
                child: _PanelContent(
                  key: ValueKey(catIdx),
                  category: cat,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PanelContent extends StatelessWidget {
  final NavCategory category;

  const _PanelContent({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: category.panelColumns.map((col) {
          return Expanded(
            child: _PanelColumn(column: col),
          );
        }).toList(),
      ),
    );
  }
}

class _PanelColumn extends StatelessWidget {
  final PanelColumn column;

  const _PanelColumn({required this.column});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading with hairline beneath
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  column.heading.toUpperCase(),
                  style: AurumTypography.panelHead,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Container(
                  height: 1,
                  color: AurumColors.divider,
                ),
              ],
            ),
          ),

          // Items
          ...column.items.map((item) => _PanelItemRow(item: item)),
        ],
      ),
    );
  }
}

class _PanelItemRow extends StatefulWidget {
  final PanelItem item;
  const _PanelItemRow({required this.item});

  @override
  State<_PanelItemRow> createState() => _PanelItemRowState();
}

class _PanelItemRowState extends State<_PanelItemRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            children: [
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: AurumTransitions.fast,
                  style: AurumTypography.panelItem.copyWith(
                    color: _hovered
                        ? AurumColors.inkPrimary
                        : AurumColors.inkSecondary,
                  ),
                  child: Text(
                    widget.item.label,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (widget.item.count != null) ...[
                const SizedBox(width: 8),
                Text(
                  widget.item.count!,
                  style: AurumTypography.panelItemCount,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}