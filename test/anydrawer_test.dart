import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
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
}
