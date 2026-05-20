import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import 'search_lens.dart';
import 'icon_button_aurum.dart';
import 'profile_pill.dart';

/// Right-side action zone of the Meridian Bar.
///
/// Composed of: SearchLens · WishlistButton · CartButton · ProfilePill
/// Each component is independently animated and stateless externally.
class ActionZone extends StatelessWidget {
  const ActionZone({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search
        const SearchLens(),
        const SizedBox(width: 2),

        // Wishlist
        AurumIconButton(
          tooltip: 'Wishlist',
          onTap: () {},
          icon: const WishlistIcon(color: AurumColors.inkTertiary),
        ),
        const SizedBox(width: 2),

        // Cart with badge
        AurumIconButton(
          tooltip: 'Cart',
          showBadge: true,
          onTap: () {},
          icon: const CartIcon(color: AurumColors.inkTertiary),
        ),
        const SizedBox(width: 4),

        // Profile
        const ProfilePill(name: 'Eleanor'),
      ],
    );
  }
}
