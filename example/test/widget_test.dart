import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('navigation drawer opens and dismisses', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Navigation Menu'));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);
    Navigator.of(tester.element(find.byType(Drawer))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('form keeps edits or discards them after confirmation',
      (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Form Drawer'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Narendra');
    await tester.tap(find.byTooltip('Close form'));
    await tester.pumpAndSettle();
    expect(find.text('Discard changes?'), findsOneWidget);
    await tester.tap(find.text('Keep editing'));
    await tester.pumpAndSettle();
    expect(find.text('Narendra'), findsOneWidget);
    await tester.tap(find.byTooltip('Close form'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unchanged form closes without confirmation', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Form Drawer'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Close form'));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsNothing);
    expect(find.text('Discard changes?'), findsNothing);
  });

  testWidgets(
      'form stays usable above keyboard and submits without discard prompt',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Form Drawer'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Narendra');
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(Drawer)).bottom, 500);
    await tester.ensureVisible(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.text('Submit')).bottom, lessThanOrEqualTo(500));
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsNothing);
    expect(find.text('Discard changes?'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('snap example expands with handle and scrolls independently',
      (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Snap Drawer'));
    await tester.tap(find.text('Snap Drawer'));
    await tester.pumpAndSettle();
    final handle = find.bySemanticsLabel('Resize drawer');
    expect(tester.getSize(find.byType(Drawer)).height, 150);
    await tester.tap(handle);
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(Drawer)).height, 300);
    await tester.drag(find.byType(ListView).last, const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(Drawer)).height, 300);
    await tester.tap(handle);
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(Drawer)).height, 600);
    expect(tester.takeException(), isNull);
  });
}
