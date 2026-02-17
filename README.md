# AnyDrawer

[![Pub Version](https://img.shields.io/pub/v/anydrawer)](https://pub.dev/packages/anydrawer)
[![License](https://img.shields.io/github/license/oi-narendra/anydrawer)](https://github.com/oi-narendra/anydrawer/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/oi-narendra/anydrawer)](https://github.com/oi-narendra/anydrawer/issues)
[![Very Good Analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)

A Flutter package that lets you show a fully customizable drawer from **any** widget — no `Scaffold` required. Just call `showDrawer()` with a `BuildContext` and you're done.

## Screenshots

[<img src="https://raw.githubusercontent.com/oi-narendra/anydrawer/main/screenshots/sample1.gif" width="700"/>]

[<img src="https://raw.githubusercontent.com/oi-narendra/anydrawer/main/screenshots/sample2.gif" width="300"/>]

## Features

- 🎯 **No Scaffold needed** — show a drawer from literally anywhere
- ↔️ **Left or right side** — slide in from either direction
- 🪟 **Dialog support** — `showDialog`, `showModalBottomSheet`, and menus work on top of the drawer
- 📚 **Multiple drawers** — open several drawers simultaneously (left + right, nested, etc.)
- 🎚️ **Fully configurable** — width, border radius, backdrop opacity, animation duration
- 🖱️ **Drag to close** — optional drag gesture support
- ⌨️ **Keyboard & back button** — close on Escape key or Android back button
- 🎮 **Programmatic control** — use `AnyDrawerController` to close the drawer from code
- 🔗 **Deep linking friendly** — open drawers from route handlers or push notifications

## Installation

```yaml
dependencies:
  anydrawer: ^1.0.7
```

```bash
flutter pub get
```

## Quick Start

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
    closeOnClickOutside: true,
    closeOnEscapeKey: true,
    closeOnResume: true,       // Android only
    closeOnBackButton: true,   // Requires a route navigator
    dragEnabled: true,
  ),
  onOpen: () => print('Drawer opened'),
  onClose: () => print('Drawer closed'),
);
```

### DrawerConfig Properties

| Property              | Type         | Default | Description                                      |
| --------------------- | ------------ | ------- | ------------------------------------------------ |
| `side`                | `DrawerSide` | `right` | Side the drawer slides in from                   |
| `widthPercentage`     | `double?`    | auto    | Width as a fraction of screen width (0.1 – 0.99) |
| `borderRadius`        | `double`     | `20`    | Corner radius of the drawer edge                 |
| `backdropOpacity`     | `double`     | `0.4`   | Opacity of the dark backdrop (0 – 1)             |
| `animationDuration`   | `Duration`   | 300ms   | Slide animation duration                         |
| `closeOnClickOutside` | `bool`       | `true`  | Close when tapping the backdrop                  |
| `closeOnEscapeKey`    | `bool`       | `true`  | Close on Escape key press                        |
| `closeOnResume`       | `bool`       | `false` | Close when app resumes (Android only)            |
| `closeOnBackButton`   | `bool`       | `false` | Close on Android back button                     |
| `dragEnabled`         | `bool`       | `false` | Allow drag to open/close                         |
| `maxDragExtent`       | `double`     | `300`   | Maximum drag distance                            |

## Programmatic Control

Use `AnyDrawerController` to close the drawer from code:

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

// Close the drawer later
controller.close();
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

## Contributing

Pull requests are welcome. For major changes, please [open an issue](https://github.com/oi-narendra/anydrawer/issues) first to discuss what you would like to change.

## License

This project is licensed under the [MIT License](LICENSE).
