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
}
