/// AnyDrawer is a Flutter package that allows you to show drawers from any
/// side of the screen — left, right, top, or bottom. You can also fully
/// customize the drawers.
///
/// This package removes the limitation of the default scaffold drawer which
/// can only be shown from the scaffold.
///
/// **Imperative API** — call `showDrawer` to show a drawer:
/// ```dart
/// final result = await showDrawer<String>(
///   context,
///   builder: (context) => const MyDrawerContent(),
/// );
/// ```
///
/// **Declarative API** — embed an `AnyDrawer` widget in your tree:
/// ```dart
/// AnyDrawer(
///   controller: myController,
///   builder: (context) => const MyDrawerContent(),
/// )
/// ```
///
/// **Swipe-to-open** — wrap your page with `AnyDrawerRegion`:
/// ```dart
/// AnyDrawerRegion(
///   side: DrawerSide.left,
///   builder: (context) => const MyDrawerContent(),
///   child: const MyPage(),
/// )
/// ```
library;

export 'src/any_drawer_region.dart';
export 'src/any_drawer_widget.dart';
export 'src/anydrawer.dart';
export 'src/anydrawer_controller.dart';
export 'src/drawer_config.dart';
export 'src/drawer_side.dart';
