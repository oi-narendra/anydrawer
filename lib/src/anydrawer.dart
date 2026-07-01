import 'dart:async';
import 'dart:ui';

import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';

/// Type definition for the drawer builder.
/// The [context] is the build context
typedef DrawerBuilder = Widget Function(BuildContext context);

/// Callback signature for drag events on the drawer.
typedef DrawerDragCallback = void Function(DragUpdateDetails details);

/// Callback signature for drag end events on the drawer.
typedef DrawerDragEndCallback = void Function(DragEndDetails details);

/// anydrawer is a package that allows you to show a drawer from any side of
/// the screen — left, right, top, or bottom. You can also customize the
/// drawer. This package removes the limitation of the default scaffold drawer
/// which can only be shown from the scaffold. Just call the [showDrawer]
/// function to show the drawer. You can also specify the [DrawerConfig] to
/// customize the drawer.
///
/// [context] is the build context.
///
/// [builder] is the drawer builder.
///
/// [config] is the drawer configuration.
///
/// [onOpen] is the callback function when the drawer is opened.
///
/// [onClose] is the callback function when the drawer is closed.
///
/// [controller] is the drawer controller.
/// Use this controller to close the drawer programmatically.
/// It is users responsibility to dispose the controller when it is no longer
/// needed.
///
/// [onDragUpdate] is called during a drag gesture on the drawer.
///
/// [onDragEnd] is called when a drag gesture on the drawer ends.
///
/// Returns a [Future] that completes with the value passed to
/// [Navigator.pop] when the drawer is closed, or `null` if dismissed.
///
/// Example:
/// ```dart
/// final result = await showDrawer<String>(
///  context,
///  builder: (context) {
///    return Center(
///      child: ElevatedButton(
///        onPressed: () => Navigator.of(context).pop('selected'),
///        child: const Text('Select'),
///      ),
///    );
///  },
///  config: const DrawerConfig(
///    side: DrawerSide.left,
///    closeOnClickOutside: true,
///  ),
/// );
/// ```
///
Future<T?> showDrawer<T>(
  BuildContext context, {
  required DrawerBuilder builder,
  void Function()? onOpen,
  void Function()? onClose,
  DrawerConfig? config,
  AnyDrawerController? controller,
  DrawerDragCallback? onDragUpdate,
  DrawerDragEndCallback? onDragEnd,
}) {
  config ??= const DrawerConfig();

  return Navigator.of(context).push<T>(
    _DrawerRoute<T>(
      drawerBuilder: builder,
      config: config,
      onOpen: onOpen,
      onClose: onClose,
      drawerController: controller,
      onDragUpdate: onDragUpdate,
      onDragEnd: onDragEnd,
    ),
  );
}

/// Whether the drawer side is horizontal (left/right).
bool _isHorizontal(DrawerSide side) =>
    side == DrawerSide.left || side == DrawerSide.right;

/// Route-based drawer implementation.
/// Using [PopupRoute] ensures that dialogs, bottom sheets, and menus
/// shown from inside the drawer naturally stack above it.
class _DrawerRoute<T> extends PopupRoute<T> {
  _DrawerRoute({
    required this.drawerBuilder,
    required this.config,
    this.onOpen,
    this.onClose,
    this.drawerController,
    this.onDragUpdate,
    this.onDragEnd,
  });

  final DrawerBuilder drawerBuilder;
  final DrawerConfig config;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final AnyDrawerController? drawerController;
  final DrawerDragCallback? onDragUpdate;
  final DrawerDragEndCallback? onDragEnd;

  /// Exposes the route's [AnimationController] so that the drawer content
  /// widget can drive drag animations without accessing protected members.
  AnimationController? get animationController => controller;

  @override
  Color? get barrierColor => config.barrierBuilder != null
      ? Colors.transparent
      : Colors.black.withValues(alpha: config.backdropOpacity);

  @override
  bool get barrierDismissible =>
      config.barrierBuilder == null && config.closeOnClickOutside;

  @override
  String? get barrierLabel => config.semanticsLabel ?? 'Dismiss drawer';

  @override
  Duration get transitionDuration => config.animationDuration;

  /// Custom barrier that calls [Navigator.pop] directly instead of
  /// [Navigator.maybePop]. This bypasses [PopScope]'s `canPop: false` so
  /// that barrier taps always dismiss the drawer when `closeOnClickOutside`
  /// is true, while system Escape/back button pops are still controlled
  /// by the [PopScope] in the content widget.
  @override
  Widget buildModalBarrier() {
    Widget applyBarrierPointerBehavior(Widget barrier) {
      if (!config.barrierPenetrable) return barrier;
      return IgnorePointer(child: barrier);
    }

    // If a custom barrier builder is provided, delegate entirely to it.
    if (config.barrierBuilder != null) {
      return applyBarrierPointerBehavior(
        config.barrierBuilder!(navigator!.context, animation!),
      );
    }

    // Build the base barrier color animation.
    final colorTween = ColorTween(
      begin: Colors.transparent,
      end: barrierColor,
    );

    if (!config.closeOnClickOutside) {
      Widget barrier = AnimatedModalBarrier(
        color: animation!.drive(colorTween),
        dismissible: false,
        semanticsLabel: barrierLabel,
      );

      if (config.backdropBlur > 0) {
        barrier = _BlurBarrier(
          animation: animation!,
          maxBlur: config.backdropBlur,
          child: barrier,
        );
      }

      return applyBarrierPointerBehavior(barrier);
    }

    return applyBarrierPointerBehavior(
      AnimatedBuilder(
        animation: animation!,
        builder: (context, child) {
          final barrierSurface = Container(
            color: Color.lerp(
              Colors.transparent,
              barrierColor,
              animation!.value,
            ),
          );

          Widget barrier = config.barrierPenetrable
              ? barrierSurface
              : GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: barrierSurface,
                );

          if (config.backdropBlur > 0) {
            final sigma = config.backdropBlur * animation!.value;
            barrier = BackdropFilter(
              filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: barrier,
            );
          }

          return barrier;
        },
      ),
    );
  }

  @override
  TickerFuture didPush() {
    final result = super.didPush();
    unawaited(result.whenComplete(() => onOpen?.call()));

    return result;
  }

  @override
  bool didPop(T? result) {
    // Defer onClose to avoid calling it during notifyListeners()
    // when the controller triggers the close.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onClose?.call();
    });

    return super.didPop(result);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final size = MediaQuery.sizeOf(context);
    final side = config.side ?? DrawerSide.right;
    final horizontal = _isHorizontal(side);

    final percentage =
        config.widthPercentage ?? _getDefaultSizePercentage(size, horizontal);

    double primarySize;
    double crossSize;

    if (horizontal) {
      primarySize = size.width * percentage;
      crossSize = size.height;
    } else {
      primarySize = size.height * percentage;
      crossSize = size.width;
    }

    // Apply min/max constraints.
    if (config.maxWidth != null && primarySize > config.maxWidth!) {
      primarySize = config.maxWidth!;
    }
    if (config.minWidth != null && primarySize < config.minWidth!) {
      primarySize = config.minWidth!;
    }

    return _DrawerContent(
      config: config,
      primarySize: primarySize,
      crossSize: crossSize,
      builder: drawerBuilder,
      drawerController: drawerController,
      route: this,
      onDragUpdate: onDragUpdate,
      onDragEnd: onDragEnd,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final side = config.side ?? DrawerSide.right;

    final Offset beginOffset;
    final Alignment alignment;

    switch (side) {
      case DrawerSide.left:
        beginOffset = const Offset(-1, 0);
        alignment = Alignment.centerLeft;
      case DrawerSide.right:
        beginOffset = const Offset(1, 0);
        alignment = Alignment.centerRight;
      case DrawerSide.top:
        beginOffset = const Offset(0, -1);
        alignment = Alignment.topCenter;
      case DrawerSide.bottom:
        beginOffset = const Offset(0, 1);
        alignment = Alignment.bottomCenter;
    }

    final slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animation, curve: config.curve),
    );

    return Align(
      alignment: alignment,
      widthFactor: 0,
      heightFactor: 0,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}

/// Animated blur barrier widget.
class _BlurBarrier extends StatelessWidget {
  const _BlurBarrier({
    required this.animation,
    required this.maxBlur,
    required this.child,
  });

  final Animation<double> animation;
  final double maxBlur;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final sigma = maxBlur * animation.value;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: child,
        );
      },
    );
  }
}

/// Stateful content widget that handles drag, keyboard, controller,
/// and lifecycle interactions for the drawer.
class _DrawerContent extends StatefulWidget {
  const _DrawerContent({
    required this.config,
    required this.primarySize,
    required this.crossSize,
    required this.builder,
    required this.route,
    this.drawerController,
    this.onDragUpdate,
    this.onDragEnd,
  });

  final DrawerConfig config;
  final double primarySize;
  final double crossSize;
  final DrawerBuilder builder;
  final AnyDrawerController? drawerController;
  final _DrawerRoute<dynamic> route;
  final DrawerDragCallback? onDragUpdate;
  final DrawerDragEndCallback? onDragEnd;

  @override
  State<_DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<_DrawerContent>
    with WidgetsBindingObserver {
  bool _popping = false;
  AnyDrawerController? _internalController;

  bool get _isHorizontalDrawer =>
      _isHorizontal(widget.config.side ?? DrawerSide.right);

  @override
  void initState() {
    super.initState();

    if (widget.drawerController != null) {
      widget.drawerController!.addListener(_onControllerChanged);
    } else {
      _internalController = AnyDrawerController();
    }

    if (widget.config.closeOnResume) {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void dispose() {
    if (widget.config.closeOnResume) {
      WidgetsBinding.instance.removeObserver(this);
    }

    if (widget.drawerController != null) {
      widget.drawerController!.removeListener(_onControllerChanged);
    }

    _internalController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && widget.config.closeOnResume) {
      _closeDrawer();
    }
  }

  void _onControllerChanged() {
    if (widget.drawerController != null && !widget.drawerController!.value) {
      _closeDrawer();
    }
  }

  void _closeDrawer() {
    if (!_popping && mounted) {
      _popping = true;
      Navigator.of(context).pop();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    widget.onDragUpdate?.call(details);

    final animController = widget.route.animationController;
    if (animController == null) return;

    final delta = details.primaryDelta!;
    final position = animController.value;
    final side = widget.config.side ?? DrawerSide.right;

    final double directionMultiplier;
    switch (side) {
      case DrawerSide.left:
        directionMultiplier = 1;
      case DrawerSide.right:
        directionMultiplier = -1;
      case DrawerSide.top:
        directionMultiplier = 1;
      case DrawerSide.bottom:
        directionMultiplier = -1;
    }

    final newPosition =
        position + delta / widget.primarySize * directionMultiplier;
    animController.value = newPosition.clamp(0.0, 1.0);
  }

  void _handleDragEnd(DragEndDetails details) {
    widget.onDragEnd?.call(details);

    final animController = widget.route.animationController;
    if (animController == null) return;
    if (animController.value < 0.5) {
      _closeDrawer();
    } else {
      unawaited(animController.forward());
    }
  }

  @override
  Widget build(BuildContext context) {
    final side = widget.config.side ?? DrawerSide.right;
    final horizontal = _isHorizontalDrawer;

    final borderRadius = _buildBorderRadius(side, widget.config.borderRadius);

    final double width;
    final double height;

    if (horizontal) {
      width = widget.primarySize;
      height = widget.crossSize;
    } else {
      width = widget.crossSize;
      height = widget.primarySize;
    }

    Widget drawerWidget = SizedBox(
      width: width,
      height: height,
      child: widget.config.elevation > 0
          ? Material(
              elevation: widget.config.elevation,
              shadowColor:
                  widget.config.shadowColor ?? Theme.of(context).shadowColor,
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
              clipBehavior: Clip.antiAlias,
              child: widget.builder(context),
            )
          : Drawer(
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
              child: widget.builder(context),
            ),
    );

    if (widget.config.dragEnabled == true) {
      if (horizontal) {
        drawerWidget = GestureDetector(
          onHorizontalDragUpdate: _handleDragUpdate,
          onHorizontalDragEnd: _handleDragEnd,
          child: drawerWidget,
        );
      } else {
        drawerWidget = GestureDetector(
          onVerticalDragUpdate: _handleDragUpdate,
          onVerticalDragEnd: _handleDragEnd,
          child: drawerWidget,
        );
      }
    }

    // Wrap with semantics if a label is provided.
    if (widget.config.semanticsLabel != null) {
      drawerWidget = Semantics(
        label: widget.config.semanticsLabel,
        scopesRoute: true,
        namesRoute: true,
        explicitChildNodes: true,
        child: drawerWidget,
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        // System-initiated pop (Escape key or Android back button)
        if (widget.config.closeOnEscapeKey || widget.config.closeOnBackButton) {
          _closeDrawer();
        }
      },
      child: drawerWidget,
    );
  }
}

/// Builds the border radius for the drawer based on its side.
BorderRadius _buildBorderRadius(DrawerSide side, double radius) {
  switch (side) {
    case DrawerSide.left:
      return BorderRadius.only(
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );
    case DrawerSide.right:
      return BorderRadius.only(
        topLeft: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
      );
    case DrawerSide.top:
      return BorderRadius.only(
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );
    case DrawerSide.bottom:
      return BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      );
  }
}

/// Private function to get the default size percentage.
/// For horizontal drawers this is width; for vertical drawers this is height.
double _getDefaultSizePercentage(Size size, bool horizontal) {
  final dimension = horizontal ? size.width : size.height;
  if (dimension < 500) {
    return 0.8;
  } else if (dimension < 900) {
    return 0.5;
  } else {
    return 0.3;
  }
}
