part of 'anydrawer.dart';

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
    this.onWillClose,
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

  /// Checks whether dismissal is allowed. See [showDrawer].
  final DrawerCloseGuard? onWillClose;

  /// Called during a drag gesture on the drawer.
  final DrawerDragCallback? onDragUpdate;

  /// Called when a drag gesture on the drawer ends.
  final DrawerDragEndCallback? onDragEnd;

  @override
  State<AnyDrawer> createState() => _AnyDrawerState();
}

class _AnyDrawerState extends State<AnyDrawer> {
  _DrawerRoute<void>? _route;

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
      _removeDrawer();
      widget.controller.addListener(_onControllerChanged);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _onControllerChanged();
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _removeDrawer();
    super.dispose();
  }

  void _removeDrawer() {
    final route = _route;
    _route = null;
    if (route == null) return;
    // Widget disposal can happen while the navigator is building or locked.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = route.navigator;
      if (navigator != null && navigator.mounted && route.isActive) {
        navigator.removeRoute(route);
      }
    });
  }

  void _onControllerChanged() {
    if (widget.controller.isOpen && _route == null) {
      _show();
    }
    // Closing is handled by the controller listener inside showDrawer.
  }

  void _show() {
    if (!mounted) return;
    final controller = widget.controller;
    late final _DrawerRoute<void> route;
    route = _DrawerRoute<void>(
      drawerBuilder: widget.builder,
      config: widget.config ?? const DrawerConfig(),
      drawerController: controller,
      onWillClose: () => widget.onWillClose?.call() ?? true,
      onDragUpdate: widget.onDragUpdate,
      onDragEnd: widget.onDragEnd,
      onOpen: () {
        if (mounted && _route == route) widget.onOpen?.call();
      },
      onClose: () {
        if (!mounted || _route != route) return;
        _route = null;
        // Sync controller state if the drawer was dismissed externally
        // (tap outside, escape key, back button).
        if (controller.isOpen) {
          controller.close();
        }
        widget.onClose?.call();
      },
    );
    _route = route;
    Navigator.of(context).push<void>(route);
  }

  @override
  Widget build(BuildContext context) {
    // This widget is invisible — it only manages the drawer lifecycle.
    return const SizedBox.shrink();
  }
}
