import 'dart:async' show unawaited;

import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';

/// A declarative widget wrapper around [showDrawer].
///
/// Instead of calling [showDrawer] imperatively, embed an [AnyDrawer] in
/// your widget tree and control it via an [AnyDrawerController]:
///
/// ```dart
/// final controller = AnyDrawerController();
///
/// @override
/// Widget build(BuildContext context) {
///   return Column(
///     children: [
///       ElevatedButton(
///         onPressed: () => controller.open(),
///         child: const Text('Open Drawer'),
///       ),
///       AnyDrawer(
///         controller: controller,
///         builder: (context) => const Text('Drawer Content'),
///         config: const DrawerConfig(side: DrawerSide.left),
///       ),
///     ],
///   );
/// }
/// ```
///
/// The widget itself renders as a [SizedBox.shrink] — it only manages the
/// drawer lifecycle.
class AnyDrawer extends StatefulWidget {
  /// Creates a declarative [AnyDrawer].
  const AnyDrawer({
    required this.controller,
    required this.builder,
    this.config,
    this.onOpen,
    this.onClose,
    this.onDragUpdate,
    this.onDragEnd,
    super.key,
  });

  /// Controller used to open and close the drawer.
  final AnyDrawerController controller;

  /// Builder for the drawer content.
  final DrawerBuilder builder;

  /// Drawer configuration.
  final DrawerConfig? config;

  /// Called when the drawer finishes opening.
  final VoidCallback? onOpen;

  /// Called when the drawer finishes closing.
  final VoidCallback? onClose;

  /// Called during a drag gesture on the drawer.
  final DrawerDragCallback? onDragUpdate;

  /// Called when a drag gesture on the drawer ends.
  final DrawerDragEndCallback? onDragEnd;

  @override
  State<AnyDrawer> createState() => _AnyDrawerState();
}

class _AnyDrawerState extends State<AnyDrawer> {
  bool _isShowing = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);

    // If controller starts open, show immediately after first frame.
    if (widget.controller.isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.controller.isOpen) {
          _show();
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant AnyDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (widget.controller.isOpen && !_isShowing) {
      _show();
    }
    // Closing is handled by the controller listener inside showDrawer.
  }

  void _show() {
    if (!mounted) return;
    _isShowing = true;

    unawaited(
      showDrawer<void>(
        context,
        builder: widget.builder,
        config: widget.config,
        controller: widget.controller,
        onDragUpdate: widget.onDragUpdate,
        onDragEnd: widget.onDragEnd,
        onOpen: widget.onOpen,
        onClose: () {
          _isShowing = false;
          // Sync controller state if the drawer was dismissed externally
          // (tap outside, escape key, back button).
          if (widget.controller.isOpen) {
            widget.controller.close();
          }
          widget.onClose?.call();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This widget is invisible — it only manages the drawer lifecycle.
    return const SizedBox.shrink();
  }
}
