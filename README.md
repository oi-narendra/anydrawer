# Anydrawer

The `anydrawer` package allows you to easily show a customizable drawer from any horizontal side of the screen in your Flutter applications. Unlike the default scaffold drawer that can only be shown from the scaffold itself, this package provides the flexibility to display drawers from various parts of your app's UI. The package includes a `showDrawer` function that facilitates the process of displaying the drawer, and you can also customize the drawer's appearance and behavior using the `DrawerConfig` class.

## Installation

To use the `anydrawer` package in your Flutter project, follow these steps:

1. Add the dependency to your `pubspec.yaml` file:

   ```yaml
   dependencies:
     anydrawer: ^1.0.1 # Replace with the latest version
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
     ),
     onOpen: () {
       // Optional callback when the drawer is opened
     },
     onClose: () {
       // Optional callback when the drawer is closed
     },
   );
   ```

## Screenshots

[<img src="https://raw.githubusercontent.com/oi-narendra/anydrawer/main/screenshots/sample1.gif" width="700"/>]

[<img src="https://raw.githubusercontent.com/oi-narendra/anydrawer/main/screenshots/sample2.gif" width="300"/>]

### Parameters

The `showDrawer` function takes the following parameters:

- `context`: The build context of the widget that is calling the function.
- `builder`: A builder function that returns the widget tree to be displayed inside the drawer.
- `config`: A [DrawerConfig](#drawerconfig) object that allows you to customize the behavior and appearance of the drawer.
- `onOpen`: An optional callback that is called when the drawer is opened.
- `onClose`: An optional callback that is called when the drawer is closed.

#### <a name="drawerconfig"></a>DrawerConfig has the following properties:

- `widthPercentage`: Set the width of the drawer as a percentage of the screen width.
- `maxDragExtent`: Set the maximum extent to which the drawer can be dragged open.
- `side`: Specify the side from which the drawer should appear (`DrawerSide.left` or `DrawerSide.right`).
- `closeOnClickOutside`: Determine whether the drawer should close when clicking outside of it.
- `closeOnEscapeKey`: Determine whether the drawer should close when the Escape key is pressed.
- `dragEnabled`: Allow users to drag the drawer to open and close it.
- `backdropOpacity`: Set the opacity of the backdrop that appears behind the drawer.
- `borderRadius`: Adjust the corner radius of the drawer.

This information provides an overview of the `showDrawer` function and the customizable properties of the `DrawerConfig` object, allowing you to create and control drawers in your Flutter application with ease.

### Animation and Interaction

The package includes smooth animations and interactive gestures for opening and closing the drawer:

- Drag the drawer to open or close it (can be disabled using `dragEnabled`).
- The drawer smoothly slides in and out from the specified side with customizable animations.

## Example

Here's an example of how to use the `anydrawer` package to show a drawer from the left side of the screen:

```dart
import 'package:flutter/material.dart';
import 'package:anydrawer/anydrawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('anydrawer Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showDrawer(
                context,
                builder: (context) {
                  return const Center(
                    child: Text('Left Drawer Content'),
                  );
                },
                config: const DrawerConfig(
                  side: DrawerSide.left,
                  closeOnClickOutside: true,
                ),
                onOpen: () {
                  print('Drawer opened');
                },
                onClose: () {
                  print('Drawer closed');
                },
              );
            },
            child: Text('Open Drawer'),
          ),
        ),
      ),
    );
  }
}
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## TODO

- [ ] Fix issue with drawer not closing when backbutton is pressed on mobile devices.

## License

This project is licensed under the [MIT License](LICENSE).
