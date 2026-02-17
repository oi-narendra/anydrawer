import 'dart:async' show unawaited;

import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('showDrawer should show the drawer', (tester) async {
    // Build a MaterialApp with a Scaffold
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDrawer(
                    context,
                    builder: (context) {
                      return const Center(
                        child: Text('Test Drawer'),
                      );
                    },
                    config: const DrawerConfig(
                      side: DrawerSide.left,
                    ),
                  );
                },
                child: const Text('Show Drawer'),
              );
            },
          ),
        ),
      ),
    );

    // Tap the button to show the drawer
    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    // Verify that the drawer is shown
    expect(find.text('Test Drawer'), findsOneWidget);
  });

  testWidgets('showDrawer should close the drawer when tapped outside', (
    tester,
  ) async {
    // Build a MaterialApp with a Scaffold
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDrawer(
                    context,
                    config: const DrawerConfig(),
                    builder: (context) {
                      return const Center(
                        child: Text('Test Drawer'),
                      );
                    },
                  );
                },
                child: const Text('Show Drawer'),
              );
            },
          ),
        ),
      ),
    );

    // Tap the button to show the drawer
    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    // Verify that the drawer is shown
    expect(find.text('Test Drawer'), findsOneWidget);

    // Tap outside the drawer (left side of screen, drawer is on the right)
    await tester.tapAt(const Offset(10, 300));
    await tester.pumpAndSettle();

    // Verify that the drawer is closed
    expect(find.text('Test Drawer'), findsNothing);
  });

  testWidgets('showDrawer should show the drawer with custom border radius', (
    tester,
  ) async {
    // Build a MaterialApp with a Scaffold
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDrawer(
                    context,
                    builder: (context) {
                      return const Center(
                        child: Text('Test Drawer'),
                      );
                    },
                    config: const DrawerConfig(side: DrawerSide.left),
                  );
                },
                child: const Text('Show Drawer'),
              );
            },
          ),
        ),
      ),
    );

    // Tap the button to show the drawer
    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    // Verify that the drawer is shown with the custom border radius
    expect(
      (tester
              .widget<Drawer>(
                find.byType(Drawer),
              )
              .shape! as RoundedRectangleBorder)
          .borderRadius,
      const BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    );
  });

  testWidgets('showDrawer should close the drawer on escape key press', (
    tester,
  ) async {
    // Build a MaterialApp with a Scaffold
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDrawer(
                    context,
                    builder: (context) {
                      return const Center(
                        child: Text('Test Drawer'),
                      );
                    },
                    config: const DrawerConfig(),
                  );
                },
                child: const Text('Show Drawer'),
              );
            },
          ),
        ),
      ),
    );

    // Tap the button to show the drawer
    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    // Verify that the drawer is shown
    expect(find.text('Test Drawer'), findsOneWidget);

    // Press the escape key to close the drawer
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    // Verify that the drawer is closed
    expect(find.text('Test Drawer'), findsNothing);
  });

  testWidgets(
    '''
showDrawer should not close the drawer on escape key
        press when closeOnEscapeKey is false''',
    (
      tester,
    ) async {
      // Build a MaterialApp with a Scaffold
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDrawer(
                      context,
                      builder: (context) {
                        return const Center(
                          child: Text('Test Drawer'),
                        );
                      },
                      config: const DrawerConfig(
                        closeOnEscapeKey: false,
                      ),
                    );
                  },
                  child: const Text('Show Drawer'),
                );
              },
            ),
          ),
        ),
      );

      // Tap the button to show the drawer
      await tester.tap(find.text('Show Drawer'));
      await tester.pumpAndSettle();

      // Verify that the drawer is shown
      expect(find.text('Test Drawer'), findsOneWidget);

      // Press the escape key to close the drawer
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      // Verify that the drawer is still open
      expect(find.text('Test Drawer'), findsOneWidget);
    },
  );

  testWidgets(
    '''
showDrawer should not close the drawer on click outside
when closeOnClickOutside is false''',
    (
      tester,
    ) async {
      // Build a MaterialApp with a Scaffold
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDrawer(
                      context,
                      builder: (context) {
                        return const Center(
                          child: Text('Test Drawer'),
                        );
                      },
                      config: const DrawerConfig(
                        closeOnClickOutside: false,
                      ),
                    );
                  },
                  child: const Text('Show Drawer'),
                );
              },
            ),
          ),
        ),
      );

      // Tap the button to show the drawer
      await tester.tap(find.text('Show Drawer'));
      await tester.pumpAndSettle();

      // Verify that the drawer is shown
      expect(find.text('Test Drawer'), findsOneWidget);

      // Tap outside the drawer to close it
      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();

      // Verify that the drawer is still open
      expect(find.text('Test Drawer'), findsOneWidget);
    },
  );

  testWidgets('showDrawer should constrain the drawer to the given width', (
    tester,
  ) async {
    // Build a MaterialApp with a Scaffold
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDrawer(
                    context,
                    builder: (context) {
                      return const Center(
                        child: Text('Test Drawer'),
                      );
                    },
                    config: const DrawerConfig(
                      widthPercentage: 0.5,
                    ),
                  );
                },
                child: const Text('Show Drawer'),
              );
            },
          ),
        ),
      ),
    );

    // Tap the button to show the drawer
    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    // Verify that the drawer is shown with the given width
    final sizedBox = tester.widget<SizedBox>(
      find.descendant(
        of: find.byType(SlideTransition),
        matching: find.byType(SizedBox).first,
      ),
    );
    expect(sizedBox.width, 400);
    expect(sizedBox.height, 600);
  });
  testWidgets('showDrawer should allow dialog to appear over drawer', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDrawer(
                    context,
                    builder: (context) {
                      return Center(
                        child: ElevatedButton(
                          onPressed: () {
                            unawaited(
                              showDialog<void>(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  title: Text('Test Dialog'),
                                ),
                              ),
                            );
                          },
                          child: const Text('Show Dialog'),
                        ),
                      );
                    },
                    config: const DrawerConfig(),
                  );
                },
                child: const Text('Show Drawer'),
              );
            },
          ),
        ),
      ),
    );

    // Open the drawer
    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    // Tap the button inside the drawer to show a dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Verify that the dialog is visible above the drawer
    expect(find.text('Test Dialog'), findsOneWidget);
  });
}
