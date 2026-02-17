import 'dart:async';

import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';

/// Type definition for the drawer builder.
/// The [context] is the build context
typedef DrawerBuilder = Widget Function(BuildContext context);

/// anydrawer is a package that allows you to show a drawer from any horizontal
/// side of the screen. You can also customize the drawer. This package removes
/// the limitation of the default scaffold drawer which can only be shown from
/// the scaffold. Just call the [showDrawer] function to show the drawer. You
/// can also specify the [DrawerConfig] to customize the drawer.
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
/// Example:
/// ```dart
/// showDrawer(
///  context,
/// builder: (context) {
///   return const Center(
///    child: Text('Left Drawer'),
///  );
/// },
/// config: const DrawerConfig(
///  side: DrawerSide.left,
/// closeOnClickOutside: true,
/// ),
/// );
/// ```
///
void showDrawer(
  BuildContext context, {
  required DrawerBuilder builder,
  void Function()? onOpen,
  void Function()? onClose,
  DrawerConfig? config,
  AnyDrawerController? controller,
}) {
  config ??= const DrawerConfig();

  unawaited(
    Navigator.of(context).push<void>(
      _DrawerRoute(
        drawerBuilder: builder,
        config: config,
        onOpen: onOpen,
        onClose: onClose,
        drawerController: controller,
      ),
    ),
  );
}

/// Route-based drawer implementation.
/// Using [PopupRoute] ensures that dialogs, bottom sheets, and menus
/// shown from inside the drawer naturally stack above it.
class _DrawerRoute extends PopupRoute<void> {
  _DrawerRoute({
    required this.drawerBuilder,
    required this.config,
    this.onOpen,
    this.onClose,
    this.drawerController,
  });

  final DrawerBuilder drawerBuilder;
  final DrawerConfig config;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final AnyDrawerController? drawerController;

  /// Exposes the route's [AnimationController] so that the drawer content
  /// widget can drive drag animations without accessing protected members.
  AnimationController? get animationController => controller;

  @override
  Color? get barrierColor =>
      Colors.black.withValues(alpha: config.backdropOpacity);

  @override
  bool get barrierDismissible => config.closeOnClickOutside;

  @override
  String? get barrierLabel => 'Dismiss drawer';

  @override
  Duration get transitionDuration => config.animationDuration;

  /// Custom barrier that calls [Navigator.pop] directly instead of
  /// [Navigator.maybePop]. This bypasses [PopScope]'s `canPop: false` so
  /// that barrier taps always dismiss the drawer when `closeOnClickOutside`
  /// is true, while system Escape/back button pops are still controlled
  /// by the [PopScope] in the content widget.
  @override
  Widget buildModalBarrier() {
    if (!config.closeOnClickOutside) {
      return AnimatedModalBarrier(
        color: animation!.drive(
          ColorTween(begin: Colors.transparent, end: barrierColor),
        ),
        dismissible: false,
        semanticsLabel: barrierLabel,
      );
    }

    return AnimatedBuilder(
      animation: animation!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.lerp(
              Colors.transparent,
              barrierColor,
              animation!.value,
            ),
          ),
        );
      },
    );
  }

  @override
  TickerFuture didPush() {
    final result = super.didPush();
    unawaited(result.whenComplete(() => onOpen?.call()));

    return result;
  }

  @override
  bool didPop(void result) {
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
    final widthMultiplier =
        config.widthPercentage ?? _getDefaultWidthPercentage(size);
    final width = size.width * widthMultiplier;

    return _DrawerContent(
      config: config,
      width: width,
      height: size.height,
      builder: drawerBuilder,
      drawerController: drawerController,
      route: this,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final slideAnimation = Tween<Offset>(
      begin: config.side == DrawerSide.left
          ? const Offset(-1, 0)
          : const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animation, curve: Curves.easeInOut),
    );

    return Align(
      alignment: config.side == DrawerSide.left
          ? Alignment.centerLeft
          : Alignment.centerRight,
      widthFactor: 0,
      heightFactor: 0,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}

/// Stateful content widget that handles drag, keyboard, controller,
/// and lifecycle interactions for the drawer.
class _DrawerContent extends StatefulWidget {
  const _DrawerContent({
    required this.config,
    required this.width,
    required this.height,
    required this.builder,
    required this.route,
    this.drawerController,
  });

  final DrawerConfig config;
  final double width;
  final double height;
  final DrawerBuilder builder;
  final AnyDrawerController? drawerController;
  final _DrawerRoute route;

  @override
  State<_DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<_DrawerContent>
    with WidgetsBindingObserver {
  bool _popping = false;
  AnyDrawerController? _internalController;

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

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.only(
      topLeft: widget.config.side == DrawerSide.left
          ? Radius.zero
          : Radius.circular(widget.config.borderRadius),
      topRight: widget.config.side == DrawerSide.left
          ? Radius.circular(widget.config.borderRadius)
          : Radius.zero,
      bottomLeft: widget.config.side == DrawerSide.left
          ? Radius.zero
          : Radius.circular(widget.config.borderRadius),
      bottomRight: widget.config.side == DrawerSide.left
          ? Radius.circular(widget.config.borderRadius)
          : Radius.zero,
    );

    Widget drawerWidget = SizedBox(
      width: widget.width,
      height: widget.height,
      child: Drawer(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        child: widget.builder(context),
      ),
    );

    if (widget.config.dragEnabled == true) {
      drawerWidget = GestureDetector(
        onHorizontalDragUpdate: (details) {
          final animController = widget.route.animationController;
          if (animController == null) return;
          final delta = details.primaryDelta!;
          final position = animController.value;
          final newPosition = position +
              delta /
                  widget.width *
                  (widget.config.side == DrawerSide.left ? 1 : -1);
          animController.value = newPosition.clamp(0.0, 1.0);
        },
        onHorizontalDragEnd: (details) {
          final animController = widget.route.animationController;
          if (animController == null) return;
          if (animController.value < 0.5) {
            _closeDrawer();
          } else {
            unawaited(animController.forward());
          }
        },
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

/// Private function to get the default width percentage.
/// The [size] is the size of the screen.
/// Returns the default width percentage.
double _getDefaultWidthPercentage(Size size) {
  if (size.width < 500) {
    return 0.8;
  } else if (size.width < 900) {
    return 0.5;
  } else {
    return 0.3;
  }
}
