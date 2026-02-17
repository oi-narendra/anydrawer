# AnyDrawer

[![Pub Version](https://img.shields.io/pub/v/anydrawer)](https://pub.dev/packages/anydrawer)
[![License](https://img.shields.io/github/license/oi-narendra/anydrawer)](https://github.com/oi-narendra/anydrawer/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/oi-narendra/anydrawer)](https://github.com/oi-narendra/anydrawer/issues)
[![Very Good Analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)

A Flutter package that lets you show a fully customizable drawer from **any** side of the screen — left, right, top, or bottom — no `Scaffold` required. Just call `showDrawer()` with a `BuildContext` and you're done.

## Screenshots

[<img src="https://raw.githubusercontent.com/oi-narendra/anydrawer/main/screenshots/sample1.gif" width="700"/>]

[<img src="https://raw.githubusercontent.com/oi-narendra/anydrawer/main/screenshots/sample2.gif" width="300"/>]

## Features

- 🎯 **No Scaffold needed** — show a drawer from literally anywhere
- ↔️ **All four sides** — slide in from left, right, top, or bottom
- 🪟 **Dialog support** — `showDialog`, `showModalBottomSheet`, and menus work on top of the drawer
- 📚 **Multiple drawers** — open several drawers simultaneously (left + right, nested, etc.)
- 🎚️ **Fully configurable** — width, border radius, backdrop opacity, animation duration & curve
- 🖱️ **Drag to close** — optional drag gesture support with callbacks
- ⌨️ **Keyboard & back button** — close on Escape key or Android back button
- 🎮 **Programmatic control** — use `AnyDrawerController` to open/close the drawer from code
- 🔗 **Deep linking friendly** — open drawers from route handlers or push notifications
- 📐 **Width constraints** — `maxWidth` and `minWidth` for responsive layouts
- 🌫️ **Backdrop blur** — frosted glass effect behind the drawer
- ✨ **Elevation & shadow** — Material shadow on the drawer edge
- 🎨 **Custom barrier** — provide your own barrier widget (gradient, blur, etc.)
- 🧩 **Declarative API** — `AnyDrawer` widget for embedding in the widget tree
- 👆 **Swipe-from-edge** — `AnyDrawerRegion` detects edge swipes to open a drawer
- ♿ **Accessibility** — built-in semantics label support
- 🔄 **Result return** — `showDrawer<T>()` returns `Future<T?>` like `showDialog`

## Installation

```yaml
dependencies:
  anydrawer: ^2.0.0
```

```bash
flutter pub get
```

## Quick Start

### Imperative API

```dart
import 'package:anydrawer/anydrawer.dart';

showDrawer(
  context,
  builder: (context) {
    return const Center(
      child: Text('Hello from the drawer!'),
    );
  },
);
```

### Declarative API

```dart
final controller = AnyDrawerController();

// In your widget tree:
AnyDrawer(
  controller: controller,
  builder: (context) => const MyDrawerContent(),
  config: const DrawerConfig(side: DrawerSide.left),
);

// Open/close from anywhere:
controller.open();
controller.close();
```

### Swipe-from-Edge

```dart
AnyDrawerRegion(
  side: DrawerSide.left,
  builder: (context) => const NavigationMenu(),
  config: const DrawerConfig(side: DrawerSide.left, dragEnabled: true),
  child: const MyPageContent(),
)
```

## Configuration

Pass a `DrawerConfig` to customize behavior and appearance:

```dart
showDrawer(
  context,
  builder: (context) => const MyDrawerContent(),
  config: const DrawerConfig(
    side: DrawerSide.left,
    widthPercentage: 0.4,
    borderRadius: 24,
    backdropOpacity: 0.5,
    backdropBlur: 5.0,
    closeOnClickOutside: true,
    closeOnEscapeKey: true,
    closeOnResume: true,       // Android only
    closeOnBackButton: true,   // Requires a route navigator
    dragEnabled: true,
    curve: Curves.easeOutCubic,
    maxWidth: 400,
    elevation: 8,
    semanticsLabel: 'Navigation drawer',
  ),
  onOpen: () => print('Drawer opened'),
  onClose: () => print('Drawer closed'),
  onDragUpdate: (details) => print('Dragging: ${details.primaryDelta}'),
  onDragEnd: (details) => print('Drag ended'),
);
```

### DrawerConfig Properties

| Property              | Type              | Default            | Description                                |
| --------------------- | ----------------- | ------------------ | ------------------------------------------ |
| `side`                | `DrawerSide`      | `right`            | Side the drawer slides in from             |
| `widthPercentage`     | `double?`         | auto               | Size fraction of primary axis (0.1 – 0.99) |
| `borderRadius`        | `double`          | `20`               | Corner radius of the drawer edge           |
| `backdropOpacity`     | `double`          | `0.4`              | Opacity of the dark backdrop (0 – 1)       |
| `backdropBlur`        | `double`          | `0.0`              | Blur sigma for frosted glass backdrop      |
| `animationDuration`   | `Duration`        | 300ms              | Slide animation duration                   |
| `curve`               | `Curve`           | `Curves.easeInOut` | Animation curve for the slide transition   |
| `closeOnClickOutside` | `bool`            | `true`             | Close when tapping the backdrop            |
| `closeOnEscapeKey`    | `bool`            | `true`             | Close on Escape key press                  |
| `closeOnResume`       | `bool`            | `false`            | Close when app resumes (Android only)      |
| `closeOnBackButton`   | `bool`            | `false`            | Close on Android back button               |
| `dragEnabled`         | `bool`            | `false`            | Allow drag to dismiss                      |
| `maxDragExtent`       | `double`          | `300`              | Maximum drag distance                      |
| `maxWidth`            | `double?`         | —                  | Maximum pixel size constraint              |
| `minWidth`            | `double?`         | —                  | Minimum pixel size constraint              |
| `elevation`           | `double`          | `0.0`              | Material shadow elevation                  |
| `shadowColor`         | `Color?`          | —                  | Shadow color when elevation > 0            |
| `barrierBuilder`      | `BarrierBuilder?` | —                  | Custom barrier widget builder              |
| `semanticsLabel`      | `String?`         | —                  | Accessibility label for screen readers     |
| `resizable`           | `bool`            | `false`            | Enable animated runtime size changes       |

## Returning Results

`showDrawer` returns a `Future<T?>`, just like `showDialog`:

```dart
final result = await showDrawer<String>(
  context,
  builder: (context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop('selected!'),
        child: const Text('Select'),
      ),
    );
  },
);
print(result); // 'selected!'
```

## Programmatic Control

Use `AnyDrawerController` to open and close the drawer from code:

```dart
final controller = AnyDrawerController();

showDrawer(
  context,
  builder: (context) => MyDrawerContent(),
  controller: controller,
  onClose: () {
    // Safe to dispose here — onClose is deferred automatically
    controller.dispose();
  },
);

// Check state
print(controller.isOpen); // true

// Close the drawer later
controller.close();
```

## Top & Bottom Drawers

Show drawers from any edge of the screen:

```dart
// Bottom panel (like a custom bottom sheet)
showDrawer(
  context,
  builder: (context) => const DetailsPanel(),
  config: const DrawerConfig(
    side: DrawerSide.bottom,
    widthPercentage: 0.4,  // 40% of screen height
    borderRadius: 20,
  ),
);

// Top notification bar
showDrawer(
  context,
  builder: (context) => const NotificationBar(),
  config: const DrawerConfig(
    side: DrawerSide.top,
    widthPercentage: 0.15,
    backdropOpacity: 0.2,
  ),
);
```

## Backdrop Blur

Add a frosted glass effect behind the drawer:

```dart
showDrawer(
  context,
  builder: (context) => const MyDrawerContent(),
  config: const DrawerConfig(
    backdropBlur: 8.0,
    backdropOpacity: 0.2,
  ),
);
```

## Custom Barrier

Provide a completely custom barrier widget:

```dart
showDrawer(
  context,
  builder: (context) => const MyDrawerContent(),
  config: DrawerConfig(
    barrierBuilder: (context, animation) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Container(
            color: Colors.purple.withValues(alpha: 0.3 * animation.value),
          ),
        ),
      );
    },
  ),
);
```

## Showing Dialogs Inside the Drawer

Dialogs, bottom sheets, and menus work seamlessly from inside the drawer:

```dart
showDrawer(
  context,
  builder: (context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Hello!'),
              content: Text('This dialog appears above the drawer.'),
            ),
          );
        },
        child: Text('Show Dialog'),
      ),
    );
  },
);
```

## Multiple Drawers

You can open multiple drawers simultaneously — for example, a left navigation drawer and a right details panel:

```dart
// Open left drawer
showDrawer(
  context,
  builder: (context) => const NavigationMenu(),
  config: const DrawerConfig(
    side: DrawerSide.left,
    widthPercentage: 0.35,
    backdropOpacity: 0.1,
    closeOnClickOutside: false,
  ),
);

// Open right drawer on top
showDrawer(
  context,
  builder: (context) => const DetailsPanel(),
  config: const DrawerConfig(
    side: DrawerSide.right,
    widthPercentage: 0.35,
  ),
);
```

You can also open nested drawers from inside an existing drawer.

## Deep Linking

Open a drawer in response to a deep link or push notification:

```dart
MaterialApp(
  onGenerateRoute: (settings) {
    if (settings.name == '/settings') {
      return MaterialPageRoute(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDrawer(
              context,
              builder: (ctx) => const SettingsDrawer(),
              config: const DrawerConfig(side: DrawerSide.right),
            );
          });
          return const HomePage();
        },
      );
    }
    return null;
  },
);
```

## Migration from 1.x

### Breaking changes in 2.0.0

1. **`showDrawer` returns `Future<T?>`** — previously returned `void`. Callers that ignore the return value need no changes.
2. **`DrawerSide` has new values** — `top` and `bottom` were added. If you have exhaustive `switch` statements on `DrawerSide`, add cases for the new values.
3. **Assertion removed** — previously, either `closeOnClickOutside` or `closeOnEscapeKey` had to be `true`. Now both can be `false`.

## Contributing

Pull requests are welcome. For major changes, please [open an issue](https://github.com/oi-narendra/anydrawer/issues) first to discuss what you would like to change.

## License

This project is licensed under the [MIT License](LICENSE).
