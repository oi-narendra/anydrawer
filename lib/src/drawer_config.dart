import 'package:anydrawer/src/drawer_side.dart';

/// Configuration for the drawer.
/// [widthPercentage] is the width for the drawer. If not specified, the
/// default width will be used which is 0.8 for mobile, 0.3 for desktop and 0.5
/// for tablet.
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
    this.widthPercentage,
    this.closeOnClickOutside = true,
    this.backdropOpacity = 0.4,
    this.dragEnabled = false,
    this.maxDragExtent = 300,
    this.side = DrawerSide.right,
    this.closeOnEscapeKey = true,
    this.borderRadius = 20,
    this.animationDuration = const Duration(milliseconds: 300),
  })  : assert(
          widthPercentage == null ||
              (widthPercentage >= 0.1 && widthPercentage <= 0.99),
          'widthPercentage must be between 0.1 and 0.99',
        ),
        assert(
          backdropOpacity >= 0 && backdropOpacity <= 1,
          'backdropOpacity must be between 0 and 1',
        ),
        assert(
          borderRadius >= 0,
          'borderRadius must be greater than or equal to 0',
        ),
        assert(
          (closeOnClickOutside ?? true) || (closeOnEscapeKey ?? true),
          'both closeOnClickOutside and closeOnEscapeKey cannot be false',
        );

  /// The width percentage of the drawer.
  /// It is used to calculate the width of the drawer based on the width of the
  /// screen.
  final double? widthPercentage;

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
    double? widthPercentage,
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
      widthPercentage: widthPercentage ?? this.widthPercentage,
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
      DrawerConfig(widthPercentage: $widthPercentage,
        closeOnClickOutside: $closeOnClickOutside, 
        backdropOpacity: $backdropOpacity,
        enableEdgeDrag: $dragEnabled, maxDragExtent: $maxDragExtent)
        side: $side, animationDuration: $animationDuration''';
  }
}
