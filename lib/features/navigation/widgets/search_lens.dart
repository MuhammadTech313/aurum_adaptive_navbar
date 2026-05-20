import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../state/navbar_state.dart';

/// The Search Lens
///
/// In resting state: a 34×34 circular icon button.
/// On tap/⌘K: expands into a 220px input field.
/// On focus: widens to 260px, border shifts to accent gold.
/// On blur with empty query: collapses back to icon.
class SearchLens extends StatefulWidget {
  const SearchLens({super.key});

  @override
  State<SearchLens> createState() => _SearchLensState();
}

class _SearchLensState extends State<SearchLens> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    final state = context.read<NavbarState>();
    if (_focusNode.hasFocus) {
      state.focusSearch();
    } else {
      state.blurSearch();
      if (_ctrl.text.isEmpty) {
        Future.delayed(AurumTransitions.mid, () {
          if (mounted) state.blurSearch();
        });
      }
    }
  }

  void _expand() {
    final state = context.read<NavbarState>();
    state.expandSearch();
    Future.delayed(const Duration(milliseconds: 60), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NavbarState>();
    final expanded = state.isSearchExpanded;
    final focused = state.isSearchFocused;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          _ctrl.clear();
          _focusNode.unfocus();
          context.read<NavbarState>().clearSearch();
        },
      },
      child: Focus(
        focusNode: FocusNode(),
        child: AnimatedContainer(
          duration: AurumTransitions.slow,
          curve: AurumTransitions.refined,
          height: 32,
          width: focused
              ? 260
              : expanded
                  ? 220
                  : 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: focused
                ? Colors.white
                : expanded
                    ? AurumColors.surfaceSecondary
                    : Colors.transparent,
            border: Border.all(
              color: focused
                  ? AurumColors.accent
                  : expanded
                      ? AurumColors.surfaceTertiary
                      : Colors.transparent,
              width: 1,
            ),
          ),
          // ClipRect prevents overflow during animation
          child: ClipRect(
            child: GestureDetector(
              onTap: expanded ? null : _expand,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Icon — fixed 32px so it never overflows the 34px collapsed container
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Center(
                      child: _SearchIcon(
                        active: focused,
                        onTap: expanded ? null : _expand,
                      ),
                    ),
                  ),

                  // Input + hint — only rendered when expanded
                  if (expanded)
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        focusNode: _focusNode,
                        style: AurumTypography.searchInput,
                        cursorColor: AurumColors.accent,
                        cursorWidth: 1.2,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search collections…',
                          hintStyle: AurumTypography.searchPlaceholder,
                          isDense: true,
                          contentPadding: const EdgeInsets.only(right: 4),
                        ),
                        onChanged: (v) => context.read<NavbarState>().updateSearchQuery(v),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Search Icon ─────────────────────────────────────────────

class _SearchIcon extends StatelessWidget {
  final bool active;
  final VoidCallback? onTap;

  const _SearchIcon({required this.active, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = active ? AurumColors.accentDeep : AurumColors.inkTertiary;

    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        size: const Size(15, 15),
        painter: _SearchIconPainter(color: color),
      ),
    );
  }
}

class _SearchIconPainter extends CustomPainter {
  final Color color;
  const _SearchIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(const Offset(6.5, 6.5), 5, paint);
    canvas.drawLine(
      const Offset(10.5, 10.5),
      const Offset(13.5, 13.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(_SearchIconPainter old) => old.color != color;
}
