import 'package:flutter/material.dart';

/// Controller for programmatically opening and closing an `AnyDrawer` or
/// a drawer shown via `showDrawer`.
///
/// The controller is a [ValueNotifier<bool>] where `true` means open and
/// `false` means closed.
///
/// Example:
/// ```dart
/// final controller = AnyDrawerController();
///
/// // Open the drawer
/// controller.open();
///
/// // Check state
/// print(controller.isOpen); // true
///
/// // Close the drawer
/// controller.close();
///
/// // Don't forget to dispose when done
/// controller.dispose();
/// ```
class AnyDrawerController extends ValueNotifier<bool> {
  /// Creates a new [AnyDrawerController] in the closed state.
  AnyDrawerController() : super(false);

  /// Whether the drawer is currently open.
  bool get isOpen => value;

  /// Opens the drawer.
  ///
  /// When used with the declarative `AnyDrawer` widget, this triggers the
  /// drawer to show. When used with the imperative `showDrawer` API, calling
  /// `open` has no effect — use `showDrawer` instead.
  void open() {
    value = true;
    notifyListeners();
  }

  /// Closes the drawer.
  void close() {
    value = false;
    notifyListeners();
  }
}
