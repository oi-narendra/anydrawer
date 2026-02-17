import 'package:anydrawer/src/drawer_side.dart';
import 'package:flutter/material.dart';

/// Type definition for a custom barrier builder.
///
/// The [context] is the build context and [animation] is the route's
/// animation controller (0.0 = fully dismissed, 1.0 = fully presented).
typedef BarrierBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
);

/// Configuration for the drawer.
///
/// [widthPercentage] is the size fraction of the drawer along its primary axis.
/// For [DrawerSide.left] and [DrawerSide.right] this controls width; for
/// [DrawerSide.top] and [DrawerSide.bottom] this controls height. If not
/// specified, sensible responsive defaults are used.
///
/// [closeOnClickOutside] is whether the drawer should be closed when the user
/// clicks outside the drawer. Defaults to `true`.
///
/// [backdropOpacity] is the opacity of the backdrop. Defaults to `0.4`.
///
/// [backdropBlur] is the blur sigma applied to the backdrop via a
/// [BackdropFilter]. Defaults to `0.0` (no blur).
///
/// [dragEnabled] is whether the user can drag the drawer to dismiss it.
/// Defaults to `false`.
///
/// [maxDragExtent] is the maximum extent the user can drag the drawer. Defaults
/// to `300`.
///
/// [side] is the side of the drawer. Defaults to [DrawerSide.right].
///
/// [closeOnEscapeKey] is whether the drawer should be closed when the user
/// presses the escape key. Defaults to `true`.
///
/// [closeOnResume] is a boolean value that indicates whether the drawer should
/// be closed when the app resumes from background. Defaults to `false`.
///
/// [closeOnBackButton] is a boolean value that indicates whether the drawer
/// should be closed when the user presses the back button on Android. Defaults
/// to `false`.
///
/// [curve] is the animation curve used for the slide transition. Defaults to
/// [Curves.easeInOut].
///
/// [maxWidth] is the maximum pixel width (or height for top/bottom drawers).
/// If the computed size exceeds this, it will be clamped.
///
/// [minWidth] is the minimum pixel width (or height for top/bottom drawers).
/// If the computed size is less than this, it will be clamped.
///
/// [elevation] is the elevation applied to the drawer surface. Defaults to
/// `0.0`.
///
/// [shadowColor] is the color of the shadow when [elevation] > 0.
///
/// [barrierBuilder] allows providing a completely custom barrier widget.
/// When set, [backdropOpacity], [backdropBlur], and [closeOnClickOutside]
/// are ignored and the barrier is fully user-controlled.
///
/// [semanticsLabel] is the accessibility label announced for the drawer.
///
/// [resizable] enables animated width transitions at runtime. Defaults to
/// `false`.
class DrawerConfig {
  /// Constructs a new [DrawerConfig].
  const DrawerConfig({
    this.widthPercentage,
    this.closeOnClickOutside = true,
    this.backdropOpacity = 0.4,
    this.backdropBlur = 0.0,
    this.dragEnabled = false,
    this.maxDragExtent = 300,
    this.side = DrawerSide.right,
    this.closeOnEscapeKey = true,
    this.borderRadius = 20,
    this.closeOnResume = false,
    this.closeOnBackButton = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.maxWidth,
    this.minWidth,
    this.elevation = 0.0,
    this.shadowColor,
    this.barrierBuilder,
    this.semanticsLabel,
    this.resizable = false,
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
          backdropBlur >= 0,
          'backdropBlur must be greater than or equal to 0',
        ),
        assert(
          borderRadius >= 0,
          'borderRadius must be greater than or equal to 0',
        ),
        assert(
          elevation >= 0,
          'elevation must be greater than or equal to 0',
        );

  /// The size percentage of the drawer along its primary axis.
  ///
  /// For left/right drawers this is the width fraction; for top/bottom drawers
  /// this is the height fraction. Used to calculate the size based on the
  /// screen dimensions.
  final double? widthPercentage;

  /// Whether the drawer should be closed when the user clicks outside the
  /// drawer.
  final bool closeOnClickOutside;

  /// The opacity of the backdrop.
  final double backdropOpacity;

  /// The blur sigma applied behind the drawer via [BackdropFilter].
  ///
  /// Set to `0.0` (default) for no blur effect.
  final double backdropBlur;

  /// Whether the user can drag the drawer to dismiss it.
  final bool? dragEnabled;

  /// The maximum extent the user can drag the drawer.
  final double? maxDragExtent;

  /// The side of the drawer.
  final DrawerSide? side;

  /// Drawer animation duration
  final Duration animationDuration;

  /// The animation curve for the slide transition.
  final Curve curve;

  /// Close on Escape key
  final bool closeOnEscapeKey;

  /// Border radius
  final double borderRadius;

  /// Close on resume
  final bool closeOnResume;

  /// Close on back button
  final bool closeOnBackButton;

  /// Maximum pixel width (or height for top/bottom drawers).
  final double? maxWidth;

  /// Minimum pixel width (or height for top/bottom drawers).
  final double? minWidth;

  /// Elevation applied to the drawer surface.
  final double elevation;

  /// Shadow color when [elevation] > 0.
  final Color? shadowColor;

  /// Custom barrier builder.
  ///
  /// When provided, the default backdrop is replaced entirely by the widget
  /// returned from this builder, giving full control over appearance and
  /// dismiss behaviour.
  final BarrierBuilder? barrierBuilder;

  /// Accessibility label announced for the drawer.
  final String? semanticsLabel;

  /// Whether the drawer supports animated runtime width changes.
  final bool resizable;

  /// copyWith method
  DrawerConfig copyWith({
    double? widthPercentage,
    bool? closeOnClickOutside,
    double? backdropOpacity,
    double? backdropBlur,
    bool? enableEdgeDrag,
    double? maxDragExtent,
    DrawerSide? side,
    bool? closeOnEscapeKey,
    Duration? animationDuration,
    Curve? curve,
    double? borderRadius,
    bool? closeOnResume,
    bool? closeOnBackButton,
    double? maxWidth,
    double? minWidth,
    double? elevation,
    Color? shadowColor,
    BarrierBuilder? barrierBuilder,
    String? semanticsLabel,
    bool? resizable,
  }) {
    return DrawerConfig(
      widthPercentage: widthPercentage ?? this.widthPercentage,
      closeOnClickOutside: closeOnClickOutside ?? this.closeOnClickOutside,
      backdropOpacity: backdropOpacity ?? this.backdropOpacity,
      backdropBlur: backdropBlur ?? this.backdropBlur,
      dragEnabled: enableEdgeDrag ?? dragEnabled,
      maxDragExtent: maxDragExtent ?? this.maxDragExtent,
      side: side ?? this.side,
      closeOnEscapeKey: closeOnEscapeKey ?? this.closeOnEscapeKey,
      animationDuration: animationDuration ?? this.animationDuration,
      curve: curve ?? this.curve,
      borderRadius: borderRadius ?? this.borderRadius,
      closeOnResume: closeOnResume ?? this.closeOnResume,
      closeOnBackButton: closeOnBackButton ?? this.closeOnBackButton,
      maxWidth: maxWidth ?? this.maxWidth,
      minWidth: minWidth ?? this.minWidth,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      barrierBuilder: barrierBuilder ?? this.barrierBuilder,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      resizable: resizable ?? this.resizable,
    );
  }

  @override
  String toString() {
    return '''
      DrawerConfig(
        widthPercentage: $widthPercentage,
        closeOnClickOutside: $closeOnClickOutside, 
        backdropOpacity: $backdropOpacity,
        backdropBlur: $backdropBlur,
        dragEnabled: $dragEnabled,
        maxDragExtent: $maxDragExtent,
        side: $side,
        animationDuration: $animationDuration,
        curve: $curve,
        closeOnEscapeKey: $closeOnEscapeKey,
        borderRadius: $borderRadius,
        maxWidth: $maxWidth,
        minWidth: $minWidth,
        elevation: $elevation,
        shadowColor: $shadowColor,
        semanticsLabel: $semanticsLabel,
        resizable: $resizable,
      )
    ''';
  }
}
