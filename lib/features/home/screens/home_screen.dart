import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../navigation/meridian_bar.dart';
import '../../navigation/mobile/mobile_topbar.dart';
import '../../navigation/mobile/bottom_dock.dart';
import '../../navigation/state/navbar_state.dart';

/// AURUM Home Screen
///
/// Wraps scrollable editorial content with:
///   Desktop/Tablet → MeridianBar (pinned top)
///   Mobile         → MobileTopBar (top) + BottomDock (floating bottom)
///
/// Scroll notifications drive NavbarState.onScroll().
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    context.read<NavbarState>().onScroll(_scrollCtrl.offset);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NavbarState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Update breakpoint from layout width
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<NavbarState>().updateBreakpoint(constraints.maxWidth);
        });

        return Scaffold(
          backgroundColor: AurumColors.surfacePrimary,
          body: Stack(
            children: [
              // ── Scrollable content ──────────────────────────
              CustomScrollView(
                controller: _scrollCtrl,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Spacer for top bar height
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: state.isMobile
                          ? MobileTopBar.height
                          : 64,
                    ),
                  ),

                  // Editorial sections
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _HeroSection(index: 0),
                      _ContentSection(index: 1),
                      _ContentSection(index: 2),
                      _ContentSection(index: 3),
                      // Bottom padding for mobile dock
                      if (state.isMobile)
                        const SizedBox(height: 100),
                    ]),
                  ),
                ],
              ),

              // ── Navigation overlay ──────────────────────────
              Positioned(
                top: 0, left: 0, right: 0,
                child: state.isMobile
                    ? const MobileTopBar()
                    : const MeridianBar(),
              ),

              // ── Mobile bottom dock ──────────────────────────
              if (state.isMobile)
                const Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: BottomDock(),
                ),

              // ── Scroll cue ──────────────────────────────────
              if (!state.isScrolled)
                const Positioned(
                  bottom: 40,
                  left: 0, right: 0,
                  child: _ScrollCue(),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Content Sections ───────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final int index;
  const _HeroSection({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'The Collection',
            style: GoogleFonts.dmMono(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              color: AurumColors.inkTertiary,
              letterSpacing: 0.2 * 10,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Objects of\nEnduring Beauty',
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: _heroSize(context),
              fontWeight: FontWeight.w300,
              color: AurumColors.inkPrimary,
              height: 1.05,
              letterSpacing: -0.5,
            ).copyWith(
              shadows: [
                Shadow(
                  color: AurumColors.inkPrimary.withOpacity(0.04),
                  blurRadius: 20,
                ),
              ],
            ),
          ).apply(
            italic: 'Enduring',
            context: context,
          ),
          const SizedBox(height: 20),
          Text(
            'Scroll to witness the Meridian Bar transform',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: AurumColors.inkTertiary,
              letterSpacing: 0.04 * 13,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  double _heroSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < 600) return 42;
    if (w < 900) return 56;
    return 72;
  }
}

class _ContentSection extends StatelessWidget {
  final int index;
  const _ContentSection({required this.index});

  static const List<_SectionData> _sections = [
    _SectionData(
      label: 'Jewellery',
      title: 'Fine Estate\nPieces',
      italic: 'Estate',
      note: 'The accent line traces your position. Categories compress to monogram glyphs.',
    ),
    _SectionData(
      label: 'Timepieces',
      title: 'Watches\nReissued',
      italic: 'Reissued',
      note: 'The search field expands on focus. Profile name condenses on scroll.',
    ),
    _SectionData(
      label: 'Maisons',
      title: 'Curated\nHouses',
      italic: 'Curated',
      note: 'Hover a category to reveal the panel. The accent strip slides to follow.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final data = _sections[(index - 1).clamp(0, _sections.length - 1)];
    final alt  = index.isEven;

    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: alt
            ? AurumColors.surfaceSecondary
            : AurumColors.surfacePrimary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data.label.toUpperCase(),
            style: GoogleFonts.dmMono(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              color: AurumColors.inkTertiary,
              letterSpacing: 0.2 * 10,
            ),
          ),
          const SizedBox(height: 16),
          _ItalicTitle(title: data.title, italic: data.italic),
          const SizedBox(height: 20),
          Text(
            data.note,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: AurumColors.inkTertiary,
              letterSpacing: 0.04 * 13,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItalicTitle extends StatelessWidget {
  final String title;
  final String italic;

  const _ItalicTitle({required this.title, required this.italic});

  @override
  Widget build(BuildContext context) {
    final lines = title.split('\n');

    return Column(
      children: lines.map((line) {
        final isItalic = line.contains(italic);
        return Text(
          line,
          textAlign: TextAlign.center,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 48,
            fontWeight: FontWeight.w300,
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            color: isItalic
                ? AurumColors.inkTertiary
                : AurumColors.inkPrimary,
            height: 1.1,
          ),
        );
      }).toList(),
    );
  }
}

// ─── Scroll Cue ─────────────────────────────────────────────

class _ScrollCue extends StatefulWidget {
  const _ScrollCue();

  @override
  State<_ScrollCue> createState() => _ScrollCueState();
}

class _ScrollCueState extends State<_ScrollCue>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>   _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'SCROLL',
          style: GoogleFonts.dmMono(
            fontSize: 9,
            fontWeight: FontWeight.w300,
            color: AurumColors.inkQuaternary,
            letterSpacing: 0.18 * 9,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _anim,
          builder: (_, __) => Opacity(
            opacity: _anim.value,
            child: Container(
              width: 1,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AurumColors.inkQuaternary,
                    AurumColors.inkQuaternary.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Section Data Model ──────────────────────────────────────

class _SectionData {
  final String label;
  final String title;
  final String italic;
  final String note;

  const _SectionData({
    required this.label,
    required this.title,
    required this.italic,
    required this.note,
  });
}

// ─── Extension for inline italic ────────────────────────────

extension on Text {
  Widget apply({required String italic, required BuildContext context}) {
    return this; // Replaced by _ItalicTitle for proper implementation
  }
}