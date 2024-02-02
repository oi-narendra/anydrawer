import 'package:flutter/material.dart';

/// any drawer controller class
/// This class is used to close the drawer.
class AnyDrawerController extends ValueNotifier<bool> {
  /// any drawer controller constructor
  AnyDrawerController() : super(false);

  /// close the drawer
  void close() {
    value = false;
    notifyListeners();
  }
}
