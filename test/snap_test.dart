import 'dart:async';
import 'dart:ui' show SemanticsAction;

import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _bodyKey = Key('snap body');

class _SnapHarness {
  late BuildContext context;
  int closed = 0;
  int updates = 0;
  int ends = 0;

  Future<void> open(
    WidgetTester tester, {
    DrawerConfig config = const DrawerConfig(
      side: DrawerSide.bottom,
      snapSizes: [0.25, 0.5, 1],
      dragEnabled: true,
    ),
    DrawerCloseGuard? guard,
    Widget? content,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (c) {
            context = c;
            return const Scaffold();
          },
        ),
      ),
    );
    unawaited(
      showDrawer<void>(
        context,
        config: config,
        onWillClose: guard,
        onClose: () => closed++,
        onDragUpdate: (_) => updates++,
        onDragEnd: (_) => ends++,
        builder: (_) => content ?? const SizedBox.expand(key: _bodyKey),
      ),
    );
    await tester.pumpAndSettle();
  }
}

Finder get _handle => find.byWidgetPredicate(
      (widget) =>
          widget is Semantics && widget.properties.label == 'Resize drawer',
    );
double _height(WidgetTester tester) =>
    tester.getSize(find.byType(Drawer)).height;

void main() {
  for (final side in [DrawerSide.top, DrawerSide.bottom]) {
    final direction = side == DrawerSide.top ? 1.0 : -1.0;
    testWidgets('$side drags to nearest snap and can reach full height',
        (tester) async {
      final h = _SnapHarness();
      await h.open(
        tester,
        config: DrawerConfig(
          side: side,
          snapSizes: const [0.25, 0.5, 1],
          dragEnabled: true,
        ),
      );
      expect(_height(tester), 200);
      await tester.drag(_handle, Offset(0, direction * 220));
      await tester.pumpAndSettle();
      expect(_height(tester), 400);
      await tester.drag(_handle, Offset(0, direction * 450));
      await tester.pumpAndSettle();
      expect(_height(tester), 800);
      await tester.drag(_handle, Offset(0, -direction * 390));
      await tester.pumpAndSettle();
      expect(_height(tester), 400);
      expect(h.updates, greaterThan(0));
      expect(h.ends, 3);
      expect(h.closed, 0);
      expect(tester.takeException(), isNull);
    });

    for (final allow in [true, false]) {
      testWidgets('$side close drag respects guard $allow', (tester) async {
        var checks = 0;
        final h = _SnapHarness();
        await h.open(
          tester,
          guard: () {
            checks++;
            return allow;
          },
          config: DrawerConfig(
            side: side,
            snapSizes: const [0.25, 0.5, 1],
            dragEnabled: true,
          ),
        );
        await tester.drag(_handle, Offset(0, -direction * 180));
        await tester.pumpAndSettle();
        expect(checks, 1);
        expect(h.closed, allow ? 1 : 0);
        if (!allow) expect(_height(tester), 200);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('uses nearest initial size and keeps original list immutable',
      (tester) async {
    final sizes = [0.25, 0.5, 1.0];
    final h = _SnapHarness();
    await h.open(
      tester,
      config: DrawerConfig(
        side: DrawerSide.bottom,
        snapSizes: sizes,
        widthPercentage: 0.6,
        dragEnabled: true,
      ),
    );
    expect(_height(tester), 400);
    sizes.clear();
    await tester.tap(_handle);
    await tester.pumpAndSettle();
    expect(_height(tester), 800);
  });

  testWidgets('short drag returns to same stop', (tester) async {
    final h = _SnapHarness();
    await h.open(tester);
    await tester.drag(_handle, const Offset(0, -40));
    await tester.pumpAndSettle();
    expect(_height(tester), 200);
    expect(h.closed, 0);
  });

  testWidgets('cancelled drag returns to selected size', (tester) async {
    final h = _SnapHarness();
    await h.open(tester);
    final gesture = await tester.startGesture(tester.getCenter(_handle));
    await gesture.moveBy(const Offset(0, -160));
    await tester.pump();
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(_height(tester), 200);
    expect(h.closed, 0);
  });

  testWidgets('content scrolling does not resize drawer', (tester) async {
    final h = _SnapHarness();
    await h.open(
      tester,
      content: ListView.builder(
        itemCount: 40,
        itemExtent: 48,
        itemBuilder: (_, i) => Text('Item $i'),
      ),
    );
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(_height(tester), 200);
    expect(find.text('Item 0'), findsNothing);
    expect(h.updates, 0);
  });

  testWidgets('disabled drag keeps initial snap and does not dismiss',
      (tester) async {
    final h = _SnapHarness();
    await h.open(
      tester,
      config: const DrawerConfig(
        side: DrawerSide.bottom,
        snapSizes: [0.25, 0.5, 1],
      ),
    );
    await tester.drag(_handle, const Offset(0, -200));
    await tester.tap(_handle);
    await tester.pumpAndSettle();
    expect(_height(tester), 200);
    expect(h.closed, 0);
  });

  testWidgets('keyboard and rotation preserve selected snap', (tester) async {
    final h = _SnapHarness();
    await h.open(tester);
    await tester.tap(_handle);
    await tester.pumpAndSettle();
    expect(_height(tester), 400);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    expect(_height(tester), 250);
    expect(tester.getRect(find.byType(Drawer)).bottom, 500);
    tester.view.physicalSize = const Size(800, 400);
    tester.view.viewInsets = const FakeViewPadding(bottom: 100);
    await tester.pumpAndSettle();
    expect(_height(tester), 150);
    tester.view.viewInsets = FakeViewPadding.zero;
    await tester.pumpAndSettle();
    expect(_height(tester), 200);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keyboard avoidance can be disabled for snap drawers',
      (tester) async {
    final h = _SnapHarness();
    await h.open(
      tester,
      config: const DrawerConfig(
        side: DrawerSide.bottom,
        snapSizes: [0.25, 0.5, 1],
        resizeToAvoidBottomInset: false,
      ),
    );
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    expect(_height(tester), 200);
    expect(tester.getRect(find.byType(Drawer)).bottom, 800);
  });

  testWidgets('respects size limits and clamps to tiny available space',
      (tester) async {
    final h = _SnapHarness();
    await h.open(
      tester,
      config: const DrawerConfig(
        side: DrawerSide.bottom,
        snapSizes: [0.25, 0.5, 1],
        minWidth: 300,
        maxWidth: 600,
        dragEnabled: true,
      ),
    );
    expect(_height(tester), 300);
    await tester.tap(_handle);
    await tester.pumpAndSettle();
    expect(_height(tester), 400);
    await tester.tap(_handle);
    await tester.pumpAndSettle();
    expect(_height(tester), 600);
    tester.view.viewInsets = const FakeViewPadding(bottom: 780);
    await tester.pumpAndSettle();
    expect(_height(tester), 20);
    tester.view.viewInsets = const FakeViewPadding(bottom: 900);
    await tester.pumpAndSettle();
    expect(_height(tester), 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('async close guard blocks resizing until resolved',
      (tester) async {
    final answer = Completer<bool>();
    final h = _SnapHarness();
    var checks = 0;
    await h.open(
      tester,
      guard: () {
        checks++;
        return answer.future;
      },
    );
    await tester.drag(_handle, const Offset(0, 180));
    await tester.pumpAndSettle();
    await tester.tap(_handle);
    await tester.drag(_handle, const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(_height(tester), 200);
    expect(checks, 1);
    answer.complete(false);
    await tester.pumpAndSettle();
    await tester.tap(_handle);
    await tester.pumpAndSettle();
    expect(_height(tester), 400);
  });

  testWidgets('handle exposes adjustable semantics', (tester) async {
    final semantics = tester.ensureSemantics();

    final h = _SnapHarness();
    await h.open(tester);
    final node = tester.getSemantics(_handle);
    node.owner!.performAction(node.id, SemanticsAction.increase);
    await tester.pumpAndSettle();
    expect(_height(tester), 400);
    node.owner!.performAction(node.id, SemanticsAction.decrease);
    await tester.pumpAndSettle();
    expect(_height(tester), 200);
    semantics.dispose();
  });

  testWidgets('safe to dispose while settling', (tester) async {
    final h = _SnapHarness();
    await h.open(tester);
    await tester.tap(_handle);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  for (final sizes in <List<double>>[
    [],
    [0],
    [-0.1],
    [1.1],
    [double.nan],
    [double.infinity],
    [0.5, 0.25],
    [0.5, 0.5],
  ]) {
    testWidgets('rejects invalid snap list $sizes', (tester) async {
      final h = _SnapHarness();
      Object? error;
      try {
        await h.open(
          tester,
          config: DrawerConfig(side: DrawerSide.bottom, snapSizes: sizes),
        );
      } on Object catch (caught) {
        error = caught;
      }
      expect(error, isArgumentError);
      expect(find.byType(Drawer), findsNothing);
    });
  }

  testWidgets('rejects snapping on horizontal drawers', (tester) async {
    final h = _SnapHarness();
    Object? error;
    try {
      await h.open(
        tester,
        config: const DrawerConfig(side: DrawerSide.left, snapSizes: [0.5, 1]),
      );
    } on Object catch (caught) {
      error = caught;
    }
    expect(error, isArgumentError);
  });

  testWidgets('single snap and zero animation duration work', (tester) async {
    final h = _SnapHarness();
    await h.open(
      tester,
      config: const DrawerConfig(
        side: DrawerSide.bottom,
        snapSizes: [1],
        dragEnabled: true,
        animationDuration: Duration.zero,
      ),
    );
    await tester.drag(_handle, const Offset(0, 80));
    await tester.pumpAndSettle();
    expect(_height(tester), 800);
  });

  test('copyWith preserves and overrides snap sizes', () {
    const config = DrawerConfig(side: DrawerSide.bottom, snapSizes: [0.25, 1]);
    expect(config.copyWith().snapSizes, [0.25, 1]);
    expect(config.copyWith(snapSizes: [0.5, 1]).snapSizes, [0.5, 1]);
  });

  testWidgets('handle supports keyboard activation and animated settling',
      (tester) async {
    final h = _SnapHarness();
    await h.open(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(_height(tester), greaterThan(200));
    expect(_height(tester), lessThan(400));
    await tester.pumpAndSettle();
    expect(_height(tester), 400);
  });

  testWidgets(
      'focused field stays visible when snap drawer shrinks for keyboard',
      (tester) async {
    final h = _SnapHarness();
    await h.open(
      tester,
      content: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
            TextField(),
            SizedBox(height: 200),
          ],
        ),
      ),
    );
    await tester.ensureVisible(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'draft');
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byType(EditableText)).bottom,
      lessThanOrEqualTo(500),
    );
    expect(find.text('draft'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keyboard appearing mid-drag restores selected snap safely',
      (tester) async {
    final h = _SnapHarness();
    await h.open(tester);
    final gesture = await tester.startGesture(tester.getCenter(_handle));
    await gesture.moveBy(const Offset(0, -150));
    await tester.pump();
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(_height(tester), 125);
    expect(h.closed, 0);
    expect(tester.takeException(), isNull);
  });
}
