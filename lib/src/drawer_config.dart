import 'package:anydrawer/src/drawer_side.dart';
import 'package:flutter/rendering.dart';

/// Configuration for the drawer.
/// [constraints] is the constraints for the drawer. If not specified, the
/// default constraints will be used.
///
/// [closeOnClickOutside] is whether the drawer should be closed when the user
/// clicks outside the drawer. Defaults to `true`.
///
/// [backdropOpacity] is the opacity of the backdrop. Defaults to `0.4`.
///
/// [dragEnabled] is whether the user can drag the drawer from the edge of
/// the screen. Defaults to `false`.
///
/// [maxDragExtent] is the maximum extent the user can drag the drawer. Defaults
/// to `300`.
///
/// [side] is the side of the drawer. Defaults to [DrawerSide.right].
///
/// [closeOnEscapeKey] is whether the drawer should be closed when the user
/// presses the escape key. Defaults to `true`.
class DrawerConfig {
  /// Constructs a new [DrawerConfig].
  const DrawerConfig({
    this.constraints,
    this.closeOnClickOutside = true,
    this.backdropOpacity = 0.4,
    this.dragEnabled = false,
    this.maxDragExtent = 300,
    this.side = DrawerSide.right,
    this.closeOnEscapeKey = true,
    this.borderRadius = 20,
    this.animationDuration = const Duration(milliseconds: 300),
  })  : assert(
          backdropOpacity >= 0 && backdropOpacity <= 1,
          'backdropOpacity must be between 0 and 1',
        ),
        assert(
          borderRadius >= 0,
          'borderRadius must be greater than or equal to 0',
        );

  /// The constraints for the drawer.
  final BoxConstraints? constraints;

  /// Whether the drawer should be closed when the user clicks outside the
  /// drawer.
  final bool? closeOnClickOutside;

  /// The opacity of the backdrop.
  final double backdropOpacity;

  /// Whether the user can drag the drawer from the edge of the screen.
  final bool? dragEnabled;

  /// The maximum extent the user can drag the drawer.
  final double? maxDragExtent;

  /// The side of the drawer.
  final DrawerSide? side;

  /// Drawer animation duration
  final Duration animationDuration;

  /// Close on Escape key
  final bool? closeOnEscapeKey;

  /// Border radius
  final double borderRadius;

  /// copyWith method
  DrawerConfig copyWith({
    BoxConstraints? constraints,
    bool? closeOnClickOutside,
    double? backdropOpacity,
    bool? enableEdgeDrag,
    double? maxDragExtent,
    DrawerSide? side,
    bool? closeOnEscapeKey,
    Duration? animationDuration,
    double? borderRadius,
  }) {
    return DrawerConfig(
      constraints: constraints ?? this.constraints,
      closeOnClickOutside: closeOnClickOutside ?? this.closeOnClickOutside,
      backdropOpacity: backdropOpacity ?? this.backdropOpacity,
      dragEnabled: enableEdgeDrag ?? dragEnabled,
      maxDragExtent: maxDragExtent ?? this.maxDragExtent,
      side: side ?? this.side,
      closeOnEscapeKey: closeOnEscapeKey ?? this.closeOnEscapeKey,
      animationDuration: animationDuration ?? this.animationDuration,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  String toString() {
    return '''
      DrawerConfig(constraints: $constraints,
        closeOnClickOutside: $closeOnClickOutside, 
        backdropOpacity: $backdropOpacity,
        enableEdgeDrag: $dragEnabled, maxDragExtent: $maxDragExtent)
        side: $side, animationDuration: $animationDuration''';
  }
}
