## 2.1.0

### 🚀 New Features

- **Barrier gesture penetration** — `DrawerConfig.barrierPenetrable` lets pointer events pass through the backdrop to widgets behind the drawer ([#6](https://github.com/oi-narendra/anydrawer/issues/6)).

### 🔧 Maintenance

- Narrowed Dart SDK upper bound from `<5.0.0` to `<4.0.0`.
- Updated `very_good_analysis` to 10.3.0 and refreshed lockfile dependencies.

## 2.0.0

### ⚠️ Breaking Changes

- **`showDrawer` now returns `Future<T?>`** — the drawer can return a result (like `showDialog`). Existing callers that ignore the return value are unaffected.
- **`DrawerSide` gains `top` and `bottom`** — exhaustive `switch` on `DrawerSide` in user code will need updating.
- **Removed assertion** requiring either `closeOnClickOutside` or `closeOnEscapeKey` to be `true`. Both can now be `false`; use a controller or back button to close.

### 🚀 New Features

- **Top & bottom drawers** — `DrawerSide.top` and `DrawerSide.bottom` for sliding panels from any edge.
- **Custom animation curve** — `DrawerConfig.curve` property (default: `Curves.easeInOut`).
- **Width constraints** — `DrawerConfig.maxWidth` and `DrawerConfig.minWidth` to clamp drawer size.
- **Backdrop blur** — `DrawerConfig.backdropBlur` applies a `BackdropFilter` behind the drawer.
- **Elevation & shadow** — `DrawerConfig.elevation` and `DrawerConfig.shadowColor` for Material shadow.
- **Custom barrier** — `DrawerConfig.barrierBuilder` for fully custom barrier widgets (e.g., gradient, blur).
- **Drag callbacks** — `onDragUpdate` and `onDragEnd` parameters on `showDrawer`.
- **Controller enhancements** — `AnyDrawerController.open()` and `isOpen` getter for two-way programmatic control.
- **Accessibility** — `DrawerConfig.semanticsLabel` for screen reader announcements.
- **Declarative widget** — `AnyDrawer` widget for embedding in the widget tree, driven by `AnyDrawerController`.
- **Swipe-from-edge** — `AnyDrawerRegion` widget detects edge swipes to open a drawer (all 4 sides).
- **Resizable drawers** — `DrawerConfig.resizable` enables animated runtime size changes.

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
