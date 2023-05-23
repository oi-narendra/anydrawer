import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Type definition for the drawer builder.
/// The [context] is the build context
typedef DrawerBuilder = Widget Function(BuildContext context);

/// Public function to show the drawer.
/// The [context] is the build context.
/// The [builder] is the drawer builder.
/// The [config] is the drawer configuration.
/// The [onOpen] is the callback function when the drawer is opened.
/// The [onClose] is the callback function when the drawer is closed.
void showDrawer(
  BuildContext context, {
  required DrawerBuilder builder,
  void Function()? onOpen,
  void Function()? onClose,
  DrawerConfig? config,
}) {
  // Get overlay state
  final overlayState = Overlay.of(context);

  // If the drawer config is null, create a new one
  config ??= const DrawerConfig();

  // Create the drawer
  final drawerOverlayEntry = _buildOverlayEntry(
    context,
    builder,
    onOpen,
    () {
      onClose?.call();
    },
    config,
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
OverlayEntry _buildOverlayEntry(
  BuildContext context,
  DrawerBuilder builder,
  void Function()? onOpen,
  void Function() onClose,
  DrawerConfig config,
) {
  // Get the size of the screen
  final size = MediaQuery.of(context).size;

  // width multiplier
  var widthMultiplier = 0.3;

  // Get width multiplier based on the screen size
  if (size.width < 600) {
    widthMultiplier = 0.8;
  } else if (size.width < 900) {
    widthMultiplier = 0.5;
  }

  // Get the constraints
  final constraints = config.constraints ??
      BoxConstraints.tightFor(
        width: size.width * widthMultiplier,
        height: size.height,
      );

  // animation controller
  final animationController = AnimationController(
    vsync: Navigator.of(context).overlay!,
    duration: config.animationDuration,
  );

  late OverlayEntry drawerOverlayEntry;

  // close drawer method
  void closeDrawer() {
    if (animationController.isAnimating) return;

    if (config.closeOnClickOutside == false &&
        config.closeOnEscapeKey == false) {
      return;
    }

    animationController.reverse().whenCompleteOrCancel(() {
      if (drawerOverlayEntry.mounted) {
        drawerOverlayEntry
          ..remove()
          ..dispose();
      }
      onClose.call();
    });
  }

  // Create the overlay entry
  return drawerOverlayEntry = OverlayEntry(
    builder: (context) {
      // Create the backdrop
      final backdrop = GestureDetector(
        onTap: closeDrawer,
        child: Container(
          color: Colors.black.withOpacity(config.backdropOpacity),
        ),
      );

      // Create the drawer
      final drawer = GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (config.dragEnabled == false) return;

          animationController.value +=
              details.primaryDelta! / constraints.maxWidth;
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
              child: Drawer(child: builder(context)),
            ),
          ),
        ),
      );

      animationController.forward().whenCompleteOrCancel(() {
        onOpen?.call();
      });

      RawKeyboard.instance.addListener((event) {
        if (event.logicalKey == LogicalKeyboardKey.escape) {
          closeDrawer();
        }
      });

      return WillPopScope(
        onWillPop: () {
          debugPrint('onWillPop');

          return Future.value(false);
        },
        child: Stack(
          children: [
            backdrop,
            drawer,
          ],
        ),
      );
    },
  );
}
