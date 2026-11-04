import 'dart:async';

import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final duringAnimation in [false, true]) {
    testWidgets(
        'removing drawer closes its route (animating: $duringAnimation)',
        (tester) async {
      final controller = AnyDrawerController();
      var visible = true;
      late StateSetter update;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return visible
                    ? AnyDrawer(
                        controller: controller,
                        builder: (_) => const Text('drawer content'),
                      )
                    : const Text('page content');
              },
            ),
          ),
        ),
      );
      controller.open();
      if (duringAnimation) {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 20));
      } else {
        await tester.pumpAndSettle();
        expect(find.text('drawer content'), findsOneWidget);
      }
      update(() => visible = false);
      await tester.pumpAndSettle();
      expect(find.text('drawer content'), findsNothing);
      expect(find.text('page content'), findsOneWidget);
      expect(tester.takeException(), isNull);
      controller.dispose();
    });
  }

  testWidgets('removing drawer leaves a dialog above it open', (tester) async {
    final controller = AnyDrawerController();
    var visible = true;
    late StateSetter update;
    late BuildContext drawerContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return visible
                  ? AnyDrawer(
                      controller: controller,
                      builder: (context) {
                        drawerContext = context;
                        return const Text('drawer content');
                      },
                    )
                  : const Text('page content');
            },
          ),
        ),
      ),
    );
    controller.open();
    await tester.pumpAndSettle();
    unawaited(
      showDialog<void>(
        context: drawerContext,
        builder: (_) => const AlertDialog(content: Text('dialog content')),
      ),
    );
    await tester.pumpAndSettle();
    update(() => visible = false);
    await tester.pumpAndSettle();
    expect(find.text('dialog content'), findsOneWidget);
    expect(find.text('drawer content', skipOffstage: false), findsNothing);
    Navigator.of(tester.element(find.text('dialog content'))).pop();
    await tester.pumpAndSettle();
    expect(find.text('page content'), findsOneWidget);
    expect(tester.takeException(), isNull);
    controller.dispose();
  });

  testWidgets('replacing the controller transfers control to the new drawer',
      (tester) async {
    final oldController = AnyDrawerController();
    final newController = AnyDrawerController();
    var controller = oldController;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return AnyDrawer(
                controller: controller,
                builder: (_) => const Text('drawer content'),
              );
            },
          ),
        ),
      ),
    );
    oldController.open();
    await tester.pumpAndSettle();
    newController.open();
    update(() => controller = newController);
    await tester.pumpAndSettle();
    expect(find.text('drawer content'), findsOneWidget);
    oldController.close();
    await tester.pumpAndSettle();
    expect(find.text('drawer content'), findsOneWidget);
    newController.close();
    await tester.pumpAndSettle();
    expect(find.text('drawer content'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    oldController.dispose();
    newController.dispose();
  });

  testWidgets('unmounting the navigator while open is safe', (tester) async {
    final controller = AnyDrawerController();
    await tester.pumpWidget(
      MaterialApp(
        home: AnyDrawer(
          controller: controller,
          builder: (_) => const Text('drawer content'),
        ),
      ),
    );
    controller.open();
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
