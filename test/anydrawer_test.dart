import 'dart:async' show unawaited;

import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('showDrawer should show the drawer', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    showDrawer<void>(
                      context,
                      builder: (context) {
                        return const Center(
                          child: Text('Test Drawer'),
                        );
                      },
                      config: const DrawerConfig(
                        side: DrawerSide.left,
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

    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    expect(find.text('Test Drawer'), findsOneWidget);
  });

  testWidgets('showDrawer should close the drawer when tapped outside', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    showDrawer<void>(
                      context,
                      config: const DrawerConfig(),
                      builder: (context) {
                        return const Center(
                          child: Text('Test Drawer'),
                        );
                      },
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

    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    expect(find.text('Test Drawer'), findsOneWidget);

    // Tap outside the drawer (left side of screen, drawer is on the right)
    await tester.tapAt(const Offset(10, 300));
    await tester.pumpAndSettle();

    expect(find.text('Test Drawer'), findsNothing);
  });

  testWidgets('showDrawer should show the drawer with custom border radius', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    showDrawer<void>(
                      context,
                      builder: (context) {
                        return const Center(
                          child: Text('Test Drawer'),
                        );
                      },
                      config: const DrawerConfig(side: DrawerSide.left),
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

    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

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
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    showDrawer<void>(
                      context,
                      builder: (context) {
                        return const Center(
                          child: Text('Test Drawer'),
                        );
                      },
                      config: const DrawerConfig(),
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

    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    expect(find.text('Test Drawer'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('Test Drawer'), findsNothing);
  });

  testWidgets(
    '''showDrawer should not close the drawer on escape key press when closeOnEscapeKey is false''',
    (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    unawaited(
                      showDrawer<void>(
                        context,
                        builder: (context) {
                          return const Center(
                            child: Text('Test Drawer'),
                          );
                        },
                        config: const DrawerConfig(
                          closeOnEscapeKey: false,
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

      await tester.tap(find.text('Show Drawer'));
      await tester.pumpAndSettle();

      expect(find.text('Test Drawer'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Test Drawer'), findsOneWidget);
    },
  );

  testWidgets(
    '''showDrawer should not close the drawer on click outside when closeOnClickOutside is false''',
    (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    unawaited(
                      showDrawer<void>(
                        context,
                        builder: (context) {
                          return const Center(
                            child: Text('Test Drawer'),
                          );
                        },
                        config: const DrawerConfig(
                          closeOnClickOutside: false,
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

      await tester.tap(find.text('Show Drawer'));
      await tester.pumpAndSettle();

      expect(find.text('Test Drawer'), findsOneWidget);

      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();

      expect(find.text('Test Drawer'), findsOneWidget);
    },
  );

  testWidgets('showDrawer should constrain the drawer to the given width', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    showDrawer<void>(
                      context,
                      builder: (context) {
                        return const Center(
                          child: Text('Test Drawer'),
                        );
                      },
                      config: const DrawerConfig(
                        widthPercentage: 0.5,
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

    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

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
                  unawaited(
                    showDrawer<void>(
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

    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Test Dialog'), findsOneWidget);
  });

  // --- v2.0.0 Tests ---

  testWidgets('showDrawer returns result via Future<T?>', (tester) async {
    String? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await showDrawer<String>(
                    context,
                    builder: (context) {
                      return Center(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop('hello'),
                          child: const Text('Return Result'),
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

    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    expect(find.text('Return Result'), findsOneWidget);

    await tester.tap(find.text('Return Result'));
    await tester.pumpAndSettle();

    expect(result, equals('hello'));
  });

  testWidgets('top drawer shows at top of screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    showDrawer<void>(
                      context,
                      builder: (context) {
                        return const Center(
                          child: Text('Top Drawer'),
                        );
                      },
                      config: const DrawerConfig(
                        side: DrawerSide.top,
                        widthPercentage: 0.3,
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

    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    expect(find.text('Top Drawer'), findsOneWidget);

    // Verify the drawer has correct border radius for top side
    final drawer = tester.widget<Drawer>(find.byType(Drawer));
    final shape = drawer.shape! as RoundedRectangleBorder;
    expect(
      shape.borderRadius,
      const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    );
  });

  testWidgets('bottom drawer shows at bottom of screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    showDrawer<void>(
                      context,
                      builder: (context) {
                        return const Center(
                          child: Text('Bottom Drawer'),
                        );
                      },
                      config: const DrawerConfig(
                        side: DrawerSide.bottom,
                        widthPercentage: 0.3,
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

    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    expect(find.text('Bottom Drawer'), findsOneWidget);

    final drawer = tester.widget<Drawer>(find.byType(Drawer));
    final shape = drawer.shape! as RoundedRectangleBorder;
    expect(
      shape.borderRadius,
      const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    );
  });

  testWidgets('maxWidth clamps drawer width', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    showDrawer<void>(
                      context,
                      builder: (context) {
                        return const Center(
                          child: Text('Test Drawer'),
                        );
                      },
                      config: const DrawerConfig(
                        widthPercentage: 0.9,
                        maxWidth: 200,
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

    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    final sizedBox = tester.widget<SizedBox>(
      find.descendant(
        of: find.byType(SlideTransition),
        matching: find.byType(SizedBox).first,
      ),
    );
    expect(sizedBox.width, 200);
  });

  testWidgets('minWidth clamps drawer width', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    showDrawer<void>(
                      context,
                      builder: (context) {
                        return const Center(
                          child: Text('Test Drawer'),
                        );
                      },
                      config: const DrawerConfig(
                        widthPercentage: 0.1,
                        minWidth: 300,
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

    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    final sizedBox = tester.widget<SizedBox>(
      find.descendant(
        of: find.byType(SlideTransition),
        matching: find.byType(SizedBox).first,
      ),
    );
    expect(sizedBox.width, 300);
  });

  testWidgets('backdrop blur shows BackdropFilter', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    showDrawer<void>(
                      context,
                      builder: (context) {
                        return const Center(
                          child: Text('Test Drawer'),
                        );
                      },
                      config: const DrawerConfig(
                        backdropBlur: 5,
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

    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    expect(find.byType(BackdropFilter), findsOneWidget);
  });

  testWidgets('elevation renders Material widget with elevation', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    showDrawer<void>(
                      context,
                      builder: (context) {
                        return const Center(
                          child: Text('Test Drawer'),
                        );
                      },
                      config: const DrawerConfig(
                        elevation: 8,
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

    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    // Find the Material widget inside the drawer content area
    // (not the Material from the Scaffold)
    final materialWidgets = tester.widgetList<Material>(
      find.descendant(
        of: find.byType(SlideTransition),
        matching: find.byType(Material),
      ),
    );

    expect(
      materialWidgets.any((m) => m.elevation == 8),
      isTrue,
    );
  });

  testWidgets('controller open/close works', (tester) async {
    final controller = AnyDrawerController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    showDrawer<void>(
                      context,
                      builder: (context) {
                        return const Center(
                          child: Text('Controller Drawer'),
                        );
                      },
                      config: const DrawerConfig(),
                      controller: controller,
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

    // Open via button
    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    expect(find.text('Controller Drawer'), findsOneWidget);

    // Close via controller
    controller.close();
    await tester.pumpAndSettle();

    expect(find.text('Controller Drawer'), findsNothing);
    expect(controller.isOpen, isFalse);

    controller.dispose();
  });

  testWidgets('semanticsLabel is applied', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    showDrawer<void>(
                      context,
                      builder: (context) {
                        return const Center(
                          child: Text('Test Drawer'),
                        );
                      },
                      config: const DrawerConfig(
                        semanticsLabel: 'Navigation drawer',
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

    await tester.tap(find.text('Show Drawer'));
    await tester.pumpAndSettle();

    expect(
      find.bySemanticsLabel('Navigation drawer'),
      findsOneWidget,
    );
  });

  testWidgets(
    'both closeOnClickOutside and closeOnEscapeKey false does not assert',
    (tester) async {
      // This should not throw an assertion error in v2.0.0.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    final controller = AnyDrawerController();
                    unawaited(
                      showDrawer<void>(
                        context,
                        builder: (context) {
                          return Center(
                            child: ElevatedButton(
                              onPressed: controller.close,
                              child: const Text('Close'),
                            ),
                          );
                        },
                        config: const DrawerConfig(
                          closeOnClickOutside: false,
                          closeOnEscapeKey: false,
                          closeOnBackButton: true,
                        ),
                        controller: controller,
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

      await tester.tap(find.text('Show Drawer'));
      await tester.pumpAndSettle();

      expect(find.text('Close'), findsOneWidget);
    },
  );

  testWidgets('AnyDrawer declarative widget opens and closes', (
    tester,
  ) async {
    final controller = AnyDrawerController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: controller.open,
                    child: const Text('Open'),
                  ),
                  ElevatedButton(
                    onPressed: controller.close,
                    child: const Text('Close Btn'),
                  ),
                  AnyDrawer(
                    controller: controller,
                    builder: (context) => const Center(
                      child: Text('Declarative Drawer'),
                    ),
                    config: const DrawerConfig(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    // Initially drawer is not shown
    expect(find.text('Declarative Drawer'), findsNothing);

    // Open via controller
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Declarative Drawer'), findsOneWidget);

    // Close via controller
    await tester.tap(find.text('Close Btn'));
    await tester.pumpAndSettle();

    expect(find.text('Declarative Drawer'), findsNothing);

    controller.dispose();
  });
}
