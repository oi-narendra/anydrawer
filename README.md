# Anydrawer

[![Pub Version](https://img.shields.io/pub/v/anydrawer)](https://pub.dev/packages/anydrawer)
[![License](https://img.shields.io/github/license/oi-narendra/anydrawer)](https://github.com/oi-narendra/anydrawer/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/oi-narendra/anydrawer)]()
[![Very Good Analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)

Introducing a revolutionary Flutter package that allows you to display a drawer from anywhere within your app, simply by providing context.

Say goodbye to the constraints of using a scaffold to show a drawer.

With this package, you gain the flexibility to display a drawer from any point in your app, enhancing your app's navigation and user experience.
Whether you're building a complex app with numerous screens or a simple one with a few, this package is designed to make your development process smoother and your app more user-friendly.

Try it today and experience the difference!

## Installation

To use the `anydrawer` package in your Flutter project, follow these steps:

1. Add the dependency to your `pubspec.yaml` file:

   ```yaml
   dependencies:
     anydrawer: ^1.0.4 # Replace with the latest version
   ```

2. Run `flutter pub get` to fetch the package.

## Usage

1. Import the required packages:

   ```dart
   import 'package:anydrawer/anydrawer.dart';
   ```

2. Utilize the `showDrawer` function to display a customized drawer:

   ```dart
   showDrawer(
     context,
     builder: (context) {
       return const Center(
         child: Text('Left Drawer'),
       );
     },
     config: const DrawerConfig(
       side: DrawerSide.left,
       closeOnClickOutside: true,
       closeOnEscapeKey: true,
       closeOnResume: true, // (Android only)
       closeOnBackButton: true, // (Requires a route navigator)
       backdropOpacity: 0.5,
       borderRadius: 24,
     ),
     onOpen: () {
       // Optional callback when the drawer is opened
     },
     onClose: () {
       // Optional callback when the drawer is closed
     },
     controller: drawerController, // Optional controller to programmatically close the drawer
   );
   ```

## Screenshots

[<img src="https://raw.githubusercontent.com/oi-narendra/anydrawer/main/screenshots/sample1.gif" width="700"/>]

[<img src="https://raw.githubusercontent.com/oi-narendra/anydrawer/main/screenshots/sample2.gif" width="300"/>]

### Parameters

| Parameter                      | Type                            | Description                                                                                          |
| ------------------------------ | ------------------------------- | ---------------------------------------------------------------------------------------------------- |
| `context`                      | `BuildContext`                  | The build context of the widget that is calling the function.                                        |
| `builder`                      | `Widget Function(BuildContext)` | A builder function that returns the widget tree to be displayed inside the drawer.                   |
| `config`                       | `DrawerConfig`                  | A `DrawerConfig` object that allows you to customize the behavior and appearance of the drawer.      |
| `onOpen`                       | `void Function()`               | An optional callback that is called when the drawer is opened.                                       |
| `onClose`                      | `void Function()`               | An optional callback that is called when the drawer is closed.                                       |
| `closeOnEscapeKey`             | `bool`                          | An optional boolean that determines whether the drawer should close when the Escape key is pressed.  |
| `closeOnResume` (Android only) | `bool`                          | An optional boolean that determines whether the drawer should close when the app is resumed.         |
| `closeOnBackButton`            | `bool`                          | An optional boolean that determines whether the drawer should close when the back button is pressed. |
| `controller`                   | `AnyDrawerController`           | A `AnyDrawerController` object that can be used to programmatically close the drawer.                |

> **Note:** ⚠️ The `controller` should be disposed of when it is no longer needed. This can be done by calling the `dispose` method of the controller. It is not automatically disposed of when the drawer is closed. ⚠️

> **Note:** ⚠️ The `closeOnResume` is only applicable on Android devices. ⚠️
> For `closeOnBackButton` to work, the app should have a route navigator. If the app does not have a route navigator, it will throw an error.

#### <a name="drawerconfig"></a>DrawerConfig has the following properties:

| Property              | Type           | Description                                                                                     |
| --------------------- | -------------- | ----------------------------------------------------------------------------------------------- |
| `widthPercentage`     | `double`       | Set the width of the drawer as a percentage of the screen width.                                |
| `maxDragExtent`       | `double`       | Set the maximum extent to which the drawer can be dragged open.                                 |
| `side`                | `DrawerSide`   | Specify the side from which the drawer should appear (`DrawerSide.left` or `DrawerSide.right`). |
| `closeOnClickOutside` | `bool`         | Determine whether the drawer should close when clicking outside of it.                          |
| `closeOnEscapeKey`    | `bool`         | Determine whether the drawer should close when the Escape key is pressed.                       |
| `closeOnResume`       | `bool`         | Determine whether the drawer should close when the app is resumed **Android only**.             |
| `closeOnBackButton`   | `bool`         | Determine whether the drawer should close when the back button is pressed **Android Only**.     |
| `dragEnabled`         | `bool`         | Allow users to drag the drawer to open and close it.                                            |
| `backdropOpacity`     | `double`       | Set the opacity of the backdrop that appears behind the drawer.                                 |
| `borderRadius`        | `BorderRadius` | Adjust the corner radius of the drawer.                                                         |

I hope this helps! Let me know if you have any further questions.

### Animation and Interaction

The package includes smooth animations and interactive gestures for opening and closing the drawer:

- Drag the drawer to open or close it (can be disabled using `dragEnabled`).
- The drawer smoothly slides in and out from the specified side with customizable animations.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## TODO

- [x] Fix issue with drawer not closing when backbutton is pressed on mobile devices.

## License

This project is licensed under the [MIT License](LICENSE).
