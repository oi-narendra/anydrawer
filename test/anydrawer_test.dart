import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('showDrawer should show the drawer', (WidgetTester tester) async {
    // Build a MaterialApp with a Scaffold
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
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
    WidgetTester tester,
  ) async {
    // Build a MaterialApp with a Scaffold
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  showDrawer(
                    context,
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

    // Tap outside the drawer to close it
    await tester.tapAt(Offset.zero);
    await tester.pumpAndSettle();

    // Verify that the drawer is closed
    expect(find.text('Test Drawer'), findsNothing);
  });

  testWidgets('showDrawer should show the drawer with custom border radius', (
    WidgetTester tester,
  ) async {
    // Build a MaterialApp with a Scaffold
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
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
    WidgetTester tester,
  ) async {
    // Build a MaterialApp with a Scaffold
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
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

  testWidgets('''
showDrawer should not close the drawer on escape key
        press when closeOnEscapeKey is false''', (
    WidgetTester tester,
  ) async {
    // Build a MaterialApp with a Scaffold
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
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
  });

  testWidgets('''
showDrawer should not close the drawer on click outside
      when closeOnClickOutside is false''', (
    WidgetTester tester,
  ) async {
    // Build a MaterialApp with a Scaffold
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
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
  });

  testWidgets('showDrawer should constrain the drawer to the given constraints',
      (
    WidgetTester tester,
  ) async {
    // Build a MaterialApp with a Scaffold
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
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
                      constraints: BoxConstraints(
                        minWidth: 200,
                        maxWidth: 300,
                        minHeight: 100,
                        maxHeight: 200,
                      ),
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

    // Verify that the drawer is shown with the given constraints
    expect(
      tester
          .widget<Container>(
            find.descendant(
              of: find.byType(SlideTransition),
              matching: find.byType(Container),
            ),
          )
          .constraints,
      const BoxConstraints(
        minWidth: 200,
        maxWidth: 300,
        minHeight: 100,
        maxHeight: 200,
      ),
    );
  });
}
