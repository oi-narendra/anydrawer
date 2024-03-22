import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  // Get overlay state
  final overlayState = Overlay.of(context);

  // If the drawer config is null, create a new one
  config ??= const DrawerConfig();

  // Create the drawer
  final drawerOverlayEntry = _buildOverlayEntry(
    context: context,
    builder: builder,
    onOpen: onOpen,
    onClose: () {
      onClose?.call();
    },
    config: config,
    controller: controller,
  );

  // Insert the drawer
  overlayState.insert(drawerOverlayEntry);
}

/// Private function to build the drawer overlay entry.
/// The [context] is the build context.
/// The [builder] is the drawer builder.
/// The [onOpen] is the callback function when the drawer is opened.
/// The [onClose] is the callback function when the drawer is closed.
/// The [config] is the drawer configuration.
OverlayEntry _buildOverlayEntry({
  required BuildContext context,
  required DrawerBuilder builder,
  required void Function() onClose,
  required DrawerConfig config,
  required AnyDrawerController? controller,
  void Function()? onOpen,
}) {
  final internalController = controller ?? AnyDrawerController();

  // Get the size of the screen
  final size = MediaQuery.sizeOf(context);

  // width multiplier
  final widthMultiplier =
      config.widthPercentage ?? _getDefaultWidthPercentage(size);

  final width = size.width * widthMultiplier;

  // Get the constraints
  final constraints = BoxConstraints.tightFor(
    width: width,
    height: size.height,
  );

  // animation controller
  final animationController = AnimationController(
    vsync: Navigator.of(context).overlay!,
    duration: config.animationDuration,
  );

  late OverlayEntry drawerOverlayEntry;

  bool handler(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.escape &&
        config.closeOnEscapeKey) {
      internalController.close();

      return true;
    }

    return false;
  }

  // close drawer method
  void closeDrawer() {
    if (animationController.isAnimating) return;

    animationController.reverse().whenCompleteOrCancel(() {
      if (drawerOverlayEntry.mounted) {
        drawerOverlayEntry
          ..remove()
          ..dispose();
        if (controller == null) {
          internalController.dispose();
        }
      }
      if (config.closeOnEscapeKey) {
        HardwareKeyboard.instance.removeHandler(handler);
      }
      onClose.call();
    });
  }

  internalController.addListener(() {
    if (internalController.value) return;

    closeDrawer();
  });

  // Create the overlay entry
  return drawerOverlayEntry = OverlayEntry(
    builder: (context) {
      // Create the backdrop
      final backdrop = GestureDetector(
        onTap: () =>
            config.closeOnClickOutside ? internalController.close() : null,
        child: Container(
          color: Colors.black.withOpacity(config.backdropOpacity),
        ),
      );

      // Create the drawer
      final drawer = GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (config.dragEnabled == false) return;

          final delta = details.primaryDelta!;
          final position = animationController.value;
          final newPosition = position +
              delta / width * (config.side == DrawerSide.left ? 1 : -1);
          animationController.value = newPosition.clamp(0, 1);
        },
        onHorizontalDragEnd: (details) {
          if (animationController.value < 0.5) {
            animationController.reverse().whenCompleteOrCancel(() {
              if (drawerOverlayEntry.mounted) {
                drawerOverlayEntry
                  ..remove()
                  ..dispose();
              }
              onClose.call();
            });
          } else {
            animationController.forward();
          }
        },
        child: Align(
          alignment: config.side == DrawerSide.left
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: config.side == DrawerSide.left
                  ? const Offset(-1, 0)
                  : const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animationController,
                curve: Curves.easeInOut,
              ),
            ),
            child: Container(
              constraints: constraints,
              child: Drawer(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: config.side == DrawerSide.left
                        ? Radius.zero
                        : Radius.circular(config.borderRadius),
                    topRight: config.side == DrawerSide.left
                        ? Radius.circular(config.borderRadius)
                        : Radius.zero,
                    bottomLeft: config.side == DrawerSide.left
                        ? Radius.zero
                        : Radius.circular(config.borderRadius),
                    bottomRight: config.side == DrawerSide.left
                        ? Radius.circular(config.borderRadius)
                        : Radius.zero,
                  ),
                ),
                child: builder(context),
              ),
            ),
          ),
        ),
      );

      animationController.forward().whenCompleteOrCancel(() {
        onOpen?.call();
      });

      if (config.closeOnEscapeKey) {
        HardwareKeyboard.instance.addHandler(handler);
      }

      if (config.closeOnResume) {
        SystemChannels.lifecycle.setMessageHandler((message) {
          if (message == AppLifecycleState.resumed.toString()) {
            internalController.close();
          }

          return Future.value();
        });
      }

      if (config.closeOnBackButton) {
        final rootBackDispatcher = Router.of(context).backButtonDispatcher;

        if (rootBackDispatcher != null) {
          rootBackDispatcher.createChildBackButtonDispatcher()
            ..addCallback(() {
              internalController.close();

              return Future.value(true);
            })
            ..takePriority();
        }
      }

      return Stack(
        children: [
          backdrop,
          drawer,
        ],
      );
    },
  );
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
