## 1.0.7

- **Breaking fix:** Rewrote drawer internals to use `PopupRoute` instead of raw `OverlayEntry`. Dialogs, bottom sheets, and menus now correctly display above the drawer ([#5](https://github.com/oi-narendra/anydrawer/issues/5)).
- **Fixed:** Click-outside dismiss now works reliably via a custom modal barrier.
- **Fixed:** `AnyDrawerController.dispose()` crash when called from `onClose` callback — `onClose` is now deferred to avoid re-entrancy during `notifyListeners()`.
- **New:** Multiple drawers can be opened simultaneously (e.g., left + right side).
- **New:** Nested drawer support — open a drawer from inside another drawer.
- **Improved:** Revamped example app with 6 use case demos: Navigation Menu, Form, Dialog-over-Drawer, Settings Panel, Multiple Drawers, and Programmatic Control with deep linking pattern.

## 1.0.6

- Fixed drawer not closing when controller was not provided.
- Fixed `AnydrawerController` dispose issue.
-

## 1.0.5

- Updated deprecated `RawKeyboard` with `HardwareKeyboard` for handling `closeOnEscapeKey`.

## 1.0.4

- Minor bug fixes.

## 1.0.3

- Added `closeOnResume` property to close drawer when app is resumed (Android only).
- Added `closeOnBackButton` property to close drawer when back button is pressed (Requires a route navigator).
- Added `closeOnEscapeKey` property to close drawer when Escape key is pressed.

## 1.0.2

- Added `controller` property showDrawer function to close drawer programmatically.

## 1.0.1

- Added screenshots to README.md
- Fixed right drawer drag issue.

## 1.0.0

- Initial release
