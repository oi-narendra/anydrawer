import 'dart:async';

import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final side in DrawerSide.values) {
    for (final avoid in [false, true]) {
      testWidgets('$side keyboard layout (avoid: $avoid)', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(400, 800);
        addTearDown(tester.view.reset);
        late BuildContext page;
        double? childInset;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                page = context;
                return const Scaffold();
              },
            ),
          ),
        );
        unawaited(
          showDrawer<void>(
            page,
            config: DrawerConfig(
              side: side,
              widthPercentage: 0.8,
              resizeToAvoidBottomInset: avoid,
            ),
            builder: (context) {
              childInset = MediaQuery.viewInsetsOf(context).bottom;
              return const SizedBox.expand();
            },
          ),
        );
        await tester.pumpAndSettle();
        final original = tester.getRect(find.byType(Drawer));
        for (final inset in [300.0, 500.0, 200.0, 0.0]) {
          tester.view.viewInsets = FakeViewPadding(bottom: inset);
          await tester.pumpAndSettle();
          final rect = tester.getRect(find.byType(Drawer));
          if (avoid) {
            expect(rect.bottom, lessThanOrEqualTo(800 - inset));
            expect(rect.top, greaterThanOrEqualTo(0));
            expect(rect.width, original.width);
            expect(childInset, 0);
            if (side == DrawerSide.bottom) expect(rect.bottom, 800 - inset);
            if (side == DrawerSide.top) expect(rect.top, 0);
          } else {
            expect(rect, original);
            expect(childInset, inset);
          }
          expect(tester.takeException(), isNull);
        }
        expect(tester.getRect(find.byType(Drawer)), original);
      });
    }
  }

  testWidgets('keyboard bounds take precedence over minimum height',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    tester.view.viewInsets = const FakeViewPadding(bottom: 600);
    addTearDown(tester.view.reset);
    late BuildContext page;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            page = context;
            return const Scaffold();
          },
        ),
      ),
    );
    unawaited(
      showDrawer<void>(
        page,
        config: const DrawerConfig(side: DrawerSide.bottom, minWidth: 500),
        builder: (_) => const SizedBox.expand(),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byType(Drawer)),
      const Rect.fromLTWH(0, 0, 400, 200),
    );
    tester.view.viewInsets = const FakeViewPadding(bottom: 900);
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(Drawer)).height, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nested Scaffold does not consume keyboard inset twice',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.reset);
    late BuildContext page;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            page = context;
            return const Scaffold();
          },
        ),
      ),
    );
    unawaited(
      showDrawer<void>(
        page,
        config:
            const DrawerConfig(side: DrawerSide.bottom, widthPercentage: 0.8),
        builder: (_) => const Scaffold(body: SizedBox.expand(key: Key('body'))),
      ),
    );
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(const Key('body'))).height, 500);
  });

  test('copyWith preserves and overrides keyboard behavior', () {
    const config = DrawerConfig(resizeToAvoidBottomInset: false);
    expect(config.copyWith().resizeToAvoidBottomInset, isFalse);
    expect(
      config.copyWith(resizeToAvoidBottomInset: true).resizeToAvoidBottomInset,
      isTrue,
    );
  });

  testWidgets('focused field scrolls above keyboard and survives rotation',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    tester.view.padding = const FakeViewPadding(top: 24, bottom: 20);
    tester.view.viewPadding = const FakeViewPadding(top: 24, bottom: 20);
    addTearDown(tester.view.reset);
    late BuildContext page;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            page = context;
            return const Scaffold();
          },
        ),
      ),
    );
    unawaited(
      showDrawer<void>(
        page,
        config:
            const DrawerConfig(side: DrawerSide.bottom, widthPercentage: 0.8),
        builder: (_) => const SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 400),
                TextField(decoration: InputDecoration(labelText: 'Message')),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'draft');
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    tester.view.padding = const FakeViewPadding(top: 24);
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byType(EditableText)).bottom,
      lessThanOrEqualTo(500),
    );
    expect(find.text('draft'), findsOneWidget);
    tester.view.physicalSize = const Size(800, 400);
    tester.view.viewInsets = const FakeViewPadding(bottom: 200);
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(Drawer)).bottom, 200);
    expect(
      tester.getRect(find.byType(EditableText)).bottom,
      lessThanOrEqualTo(200),
    );
    expect(find.text('draft'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
