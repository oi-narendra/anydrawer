import 'dart:async' show unawaited;

import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';

/// A widget that detects swipe gestures from the edge of the screen and opens
/// a drawer in response.
///
/// Wrap your page content with [AnyDrawerRegion] to enable swipe-to-open:
///
/// ```dart
/// AnyDrawerRegion(
///   side: DrawerSide.left,
///   builder: (context) => const NavigationMenu(),
///   config: const DrawerConfig(
///     side: DrawerSide.left,
///     dragEnabled: true,
///   ),
///   child: const MyPageContent(),
/// )
/// ```
///
/// The widget places an invisible hit-test strip along the specified edge.
/// When the user swipes from that edge past the [swipeThreshold], the drawer
/// is opened.
class AnyDrawerRegion extends StatefulWidget {
  /// Creates an [AnyDrawerRegion].
  const AnyDrawerRegion({
    required this.side,
    required this.builder,
    required this.child,
    this.config,
    this.edgeWidth = 20.0,
    this.swipeThreshold = 30.0,
    this.onOpen,
    this.onClose,
    super.key,
  });

  /// The edge of the screen to detect swipes from.
  final DrawerSide side;

  /// Builder for the drawer content.
  final DrawerBuilder builder;

  /// The page content this region wraps.
  final Widget child;

  /// Drawer configuration.
  ///
  /// The [DrawerConfig.side] should match [side] for consistent behaviour.
  /// If not provided, a default config with matching side is used.
  final DrawerConfig? config;

  /// Width (or height for top/bottom) of the invisible swipe detection strip
  /// in logical pixels. Defaults to `20.0`.
  final double edgeWidth;

  /// Minimum swipe distance (in logical pixels) required to trigger the
  /// drawer opening. Defaults to `30.0`.
  final double swipeThreshold;

  /// Called when the drawer finishes opening.
  final VoidCallback? onOpen;

  /// Called when the drawer finishes closing.
  final VoidCallback? onClose;

  @override
  State<AnyDrawerRegion> createState() => _AnyDrawerRegionState();
}

class _AnyDrawerRegionState extends State<AnyDrawerRegion> {
  bool _drawerOpen = false;
  double _dragAccumulator = 0;

  bool get _isHorizontal =>
      widget.side == DrawerSide.left || widget.side == DrawerSide.right;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          left: _positionLeft,
          right: _positionRight,
          top: _positionTop,
          bottom: _positionBottom,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: _isHorizontal ? _onDragUpdate : null,
            onHorizontalDragEnd: _isHorizontal ? _onDragEnd : null,
            onVerticalDragUpdate: !_isHorizontal ? _onDragUpdate : null,
            onVerticalDragEnd: !_isHorizontal ? _onDragEnd : null,
            child: SizedBox(
              width: _isHorizontal ? widget.edgeWidth : double.infinity,
              height: !_isHorizontal ? widget.edgeWidth : double.infinity,
            ),
          ),
        ),
      ],
    );
  }

  double? get _positionLeft {
    if (widget.side == DrawerSide.left) return 0;
    if (widget.side == DrawerSide.right) return null;
    // top/bottom: stretch full width
    return 0;
  }

  double? get _positionRight {
    if (widget.side == DrawerSide.right) return 0;
    if (widget.side == DrawerSide.left) return null;
    // top/bottom: stretch full width
    return 0;
  }

  double? get _positionTop {
    if (widget.side == DrawerSide.top) return 0;
    if (widget.side == DrawerSide.bottom) return null;
    // left/right: stretch full height
    return 0;
  }

  double? get _positionBottom {
    if (widget.side == DrawerSide.bottom) return 0;
    if (widget.side == DrawerSide.top) return null;
    // left/right: stretch full height
    return 0;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;

    // Accumulate drag in the direction that opens the drawer.
    switch (widget.side) {
      case DrawerSide.left:
      case DrawerSide.top:
        _dragAccumulator += delta;
      case DrawerSide.right:
      case DrawerSide.bottom:
        _dragAccumulator -= delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragAccumulator >= widget.swipeThreshold && !_drawerOpen) {
      _openDrawer();
    }
    _dragAccumulator = 0;
  }

  void _openDrawer() {
    if (!mounted || _drawerOpen) return;
    _drawerOpen = true;

    final config = widget.config ?? DrawerConfig(side: widget.side);

    unawaited(
      showDrawer<void>(
        context,
        builder: widget.builder,
        config: config,
        onOpen: widget.onOpen,
        onClose: () {
          _drawerOpen = false;
          widget.onClose?.call();
        },
      ),
    );
  }
}
