import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A single item inside a category panel column
class PanelItem {
  final String label;
  final String? count;

  const PanelItem({required this.label, this.count});
}

/// A column group within the category dropdown panel
class PanelColumn {
  final String heading;
  final List<PanelItem> items;

  const PanelColumn({required this.heading, required this.items});
}

/// Full category definition
class NavCategory {
  final String label;
  final String glyph; // Single italic letter — the compressed monogram
  final Color accent; // Strip/indicator color
  final List<PanelColumn> panelColumns;

  const NavCategory({
    required this.label,
    required this.glyph,
    required this.accent,
    required this.panelColumns,
  });
}

/// All marketplace categories — single source of truth
abstract class AurumCategories {
  static const List<NavCategory> all = [
    NavCategory(
      label: 'Jewellery',
      glyph: 'J',
      accent: AurumColors.accent,
      panelColumns: [
        PanelColumn(heading: 'Collections', items: [
          PanelItem(label: 'Engagement Rings', count: '412'),
          PanelItem(label: 'Fine Necklaces', count: '218'),
          PanelItem(label: 'Estate Pieces', count: '94'),
          PanelItem(label: 'Signed Jewels', count: '67'),
        ]),
        PanelColumn(heading: 'Material', items: [
          PanelItem(label: '18k Gold'),
          PanelItem(label: 'Platinum'),
          PanelItem(label: 'Diamond Set'),
          PanelItem(label: 'Coloured Stone'),
        ]),
        PanelColumn(heading: 'Heritage', items: [
          PanelItem(label: 'Art Deco'),
          PanelItem(label: 'Victorian'),
          PanelItem(label: 'Mid-Century'),
          PanelItem(label: 'Contemporary'),
        ]),
        PanelColumn(heading: 'Editorial', items: [
          PanelItem(label: 'The Vault'),
          PanelItem(label: 'New Arrivals'),
          PanelItem(label: 'Maisons'),
        ]),
      ],
    ),
    NavCategory(
      label: 'Watches',
      glyph: 'W',
      accent: Color(0xFF8FA8B8),
      panelColumns: [
        PanelColumn(heading: 'Movement', items: [
          PanelItem(label: 'Mechanical'),
          PanelItem(label: 'Automatic'),
          PanelItem(label: 'Quartz'),
          PanelItem(label: 'Skeleton'),
        ]),
        PanelColumn(heading: 'Provenance', items: [
          PanelItem(label: 'Rolex'),
          PanelItem(label: 'Patek Philippe'),
          PanelItem(label: 'Vacheron'),
          PanelItem(label: 'Audemars Piguet'),
        ]),
        PanelColumn(heading: 'Era', items: [
          PanelItem(label: '1950s–60s'),
          PanelItem(label: '1970s–80s'),
          PanelItem(label: 'Modern Vintage'),
          PanelItem(label: 'Contemporary'),
        ]),
        PanelColumn(heading: 'Material', items: [
          PanelItem(label: 'Steel'),
          PanelItem(label: 'Gold'),
          PanelItem(label: 'Titanium'),
          PanelItem(label: 'Two-tone'),
        ]),
      ],
    ),
    NavCategory(
      label: 'Fashion',
      glyph: 'F',
      accent: Color(0xFFB8A0A0),
      panelColumns: [
        PanelColumn(heading: 'Category', items: [
          PanelItem(label: 'Ready-to-Wear'),
          PanelItem(label: 'Accessories'),
          PanelItem(label: 'Bags'),
          PanelItem(label: 'Footwear'),
        ]),
        PanelColumn(heading: 'Maisons', items: [
          PanelItem(label: 'Chanel'),
          PanelItem(label: 'Hermès'),
          PanelItem(label: 'Bottega Veneta'),
          PanelItem(label: 'Céline'),
        ]),
        PanelColumn(heading: 'Condition', items: [
          PanelItem(label: 'Pristine'),
          PanelItem(label: 'Very Good'),
          PanelItem(label: 'Good'),
        ]),
        PanelColumn(heading: 'Season', items: [
          PanelItem(label: 'Current'),
          PanelItem(label: 'Archive'),
          PanelItem(label: 'Resort'),
          PanelItem(label: 'Couture'),
        ]),
      ],
    ),
    NavCategory(
      label: 'Art & Objects',
      glyph: 'A',
      accent: Color(0xFF9AA89A),
      panelColumns: [
        PanelColumn(heading: 'Medium', items: [
          PanelItem(label: 'Oil on Canvas'),
          PanelItem(label: 'Works on Paper'),
          PanelItem(label: 'Sculpture'),
          PanelItem(label: 'Photography'),
        ]),
        PanelColumn(heading: 'Period', items: [
          PanelItem(label: 'Modern'),
          PanelItem(label: 'Post-war'),
          PanelItem(label: 'Contemporary'),
          PanelItem(label: 'Old Masters'),
        ]),
        PanelColumn(heading: 'Origin', items: [
          PanelItem(label: 'European'),
          PanelItem(label: 'American'),
          PanelItem(label: 'Asian'),
          PanelItem(label: 'Latin American'),
        ]),
        PanelColumn(heading: 'Format', items: [
          PanelItem(label: 'Large-scale'),
          PanelItem(label: 'Cabinet Works'),
          PanelItem(label: 'Multiples'),
        ]),
      ],
    ),
    NavCategory(
      label: 'Curated',
      glyph: 'C',
      accent: Color(0xFFC0A882),
      panelColumns: [
        PanelColumn(heading: 'Theme', items: [
          PanelItem(label: "The Collector's Eye"),
          PanelItem(label: 'Provenance Stories'),
          PanelItem(label: 'Investment Grade'),
        ]),
        PanelColumn(heading: 'By Expert', items: [
          PanelItem(label: 'Editorial Picks'),
          PanelItem(label: 'Auction Highlights'),
          PanelItem(label: 'Private Sales'),
        ]),
        PanelColumn(heading: 'New This Week', items: [
          PanelItem(label: 'Fresh Listings'),
          PanelItem(label: 'Just Reduced'),
          PanelItem(label: 'Last Pieces'),
        ]),
        PanelColumn(heading: 'Occasion', items: [
          PanelItem(label: 'Investment'),
          PanelItem(label: 'Gift-giving'),
          PanelItem(label: 'Interior'),
          PanelItem(label: 'Ceremony'),
        ]),
      ],
    ),
  ];
}
