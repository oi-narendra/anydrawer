import 'package:flutter/material.dart';

/// any drawer controller class
/// This class is used to close the drawer.
class AnyDrawerController extends ValueNotifier<bool> {
  /// any drawer controller constructor
  AnyDrawerController({bool isOpened = true}) : super(isOpened);

  /// close the drawer
  void close() {
    value = false;
  }
}
