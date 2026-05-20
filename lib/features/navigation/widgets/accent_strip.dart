import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/constants/nav_categories.dart';

/// The Meridian Accent Strip
///
/// A 1.5px horizontal line that slides beneath the active category.
/// Position and color are driven by [GlobalKey] bounds of the nav items.
/// Uses [TweenAnimationBuilder] for fully implicit, rebuild-free animation.
class AccentStrip extends StatelessWidget {
  /// Current display position (left offset from nav area start)
  final double left;

  /// Width of the active item
  final double width;

  /// Index into [AurumCategories.all] for color
  final int categoryIndex;

  const AccentStrip({
    super.key,
    required this.left,
    required this.width,
    required this.categoryIndex,
  });

  Color get _color => AurumCategories.all[
    categoryIndex.clamp(0, AurumCategories.all.length - 1)
  ].accent;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: left, end: left),
      duration: AurumTransitions.slow,
      curve: AurumTransitions.refined,
      builder: (_, leftVal, __) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: width, end: width),
          duration: AurumTransitions.slow,
          curve: AurumTransitions.refined,
          builder: (_, widthVal, __) {
            return TweenAnimationBuilder<Color?>(
              tween: ColorTween(begin: _color, end: _color),
              duration: AurumTransitions.mid,
              builder: (_, colorVal, __) {
                return Positioned(
                  bottom: 0,
                  left: leftVal,
                  child: Container(
                    width: widthVal,
                    height: 1.5,
                    color: colorVal ?? _color,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Stateful wrapper that computes strip position from item GlobalKeys
class AccentStripController extends StatefulWidget {
  final List<GlobalKey> itemKeys;
  final int displayIndex;

  const AccentStripController({
    super.key,
    required this.itemKeys,
    required this.displayIndex,
  });

  @override
  State<AccentStripController> createState() => _AccentStripControllerState();
}

class _AccentStripControllerState extends State<AccentStripController> {
  double _left  = 0;
  double _width = 80;

  @override
  void didUpdateWidget(AccentStripController old) {
    super.didUpdateWidget(old);
    if (old.displayIndex != widget.displayIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    final idx = widget.displayIndex.clamp(0, widget.itemKeys.length - 1);
    final key = widget.itemKeys[idx];
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final globalPos = box.localToGlobal(Offset.zero);
    // Convert to local coords within the Stack (the bar itself)
    final barBox = context.findRenderObject() as RenderBox?;
    if (barBox == null) return;
    final local = barBox.globalToLocal(globalPos);

    if (mounted) {
      setState(() {
        _left  = local.dx;
        _width = box.size.width;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AnimatedStrip(
      left:          _left,
      width:         _width,
      categoryIndex: widget.displayIndex,
    );
  }
}

class _AnimatedStrip extends StatelessWidget {
  final double left;
  final double width;
  final int    categoryIndex;

  const _AnimatedStrip({
    required this.left,
    required this.width,
    required this.categoryIndex,
  });

  Color get _color => AurumCategories.all[
    categoryIndex.clamp(0, AurumCategories.all.length - 1)
  ].accent;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: AurumTransitions.slow,
      curve: AurumTransitions.refined,
      bottom: 0,
      left: left,
      child: AnimatedContainer(
        duration: AurumTransitions.slow,
        curve: AurumTransitions.refined,
        width: width,
        height: 1.5,
        color: _color,
      ),
    );
  }
}