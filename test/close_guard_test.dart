import 'dart:async';

import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _Harness {
  final controller = AnyDrawerController();
  late BuildContext drawerContext;
  late BuildContext pageContext;
  Future<String?>? result;
  int closed = 0;

  Future<void> open(
    WidgetTester tester, {
    DrawerCloseGuard? guard,
    DrawerConfig config = const DrawerConfig(
      widthPercentage: 0.5,
      dragEnabled: true,
      closeOnBackButton: true,
      closeOnResume: true,
    ),
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            pageContext = context;
            return const Scaffold(body: Text('page'));
          },
        ),
      ),
    );
    result = showDrawer<String>(
      pageContext,
      config: config,
      controller: controller,
      onWillClose: guard,
      onClose: () => closed++,
      builder: (context) {
        drawerContext = context;
        return const SizedBox.expand(child: Text('drawer'));
      },
    );
    await tester.pumpAndSettle();
    addTearDown(controller.dispose);
  }
}

Future<void> _dismiss(WidgetTester tester, _Harness h, String method) async {
  switch (method) {
    case 'backdrop':
      await tester.tapAt(const Offset(10, 300));
    case 'escape':
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    case 'back':
      await tester.binding.handlePopRoute();
    case 'controller':
      h.controller.close();
    case 'navigator':
      Navigator.of(h.drawerContext).pop('saved');
    case 'swipe':
      await tester.drag(find.byType(Drawer), const Offset(300, 0));
    case 'resume':
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  }
  await tester.pumpAndSettle();
}

void main() {
  for (final method in [
    'backdrop',
    'escape',
    'back',
    'controller',
    'navigator',
    'swipe',
    'resume',
  ]) {
    for (final allow in [false, true]) {
      testWidgets('$method respects guard returning $allow', (tester) async {
        var calls = 0;
        final h = _Harness();
        await h.open(
          tester,
          guard: () {
            calls++;
            return allow;
          },
        );
        final originalRect = tester.getRect(find.byType(Drawer));
        await _dismiss(tester, h, method);
        expect(calls, 1);
        expect(find.text('drawer'), allow ? findsNothing : findsOneWidget);
        expect(h.closed, allow ? 1 : 0);
        if (allow) {
          expect(await h.result, method == 'navigator' ? 'saved' : isNull);
        } else {
          expect(tester.getRect(find.byType(Drawer)), originalRect);
          if (method == 'controller') expect(h.controller.isOpen, isTrue);
        }
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('pending guard coalesces requests and can be retried',
      (tester) async {
    var answer = Completer<bool>();
    var calls = 0;
    final h = _Harness();
    await h.open(
      tester,
      guard: () {
        calls++;
        return answer.future;
      },
    );
    h.controller.close();
    await tester.pump();
    h.controller.close();
    Navigator.of(h.drawerContext).pop('duplicate');
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(calls, 1);
    expect(h.closed, 0);
    answer.complete(false);
    await tester.pumpAndSettle();
    expect(h.controller.isOpen, isTrue);
    answer = Completer<bool>();
    Navigator.of(h.drawerContext).pop('retry');
    await tester.pump();
    expect(calls, 2);
    answer.complete(true);
    await tester.pumpAndSettle();
    expect(await h.result, 'retry');
    expect(h.closed, 1);
  });

  for (final asyncError in [false, true]) {
    testWidgets('guard error keeps drawer open (async: $asyncError)',
        (tester) async {
      var fail = true;
      final h = _Harness();
      await h.open(
        tester,
        guard: () {
          if (!fail) return true;
          if (asyncError) return Future<bool>.error(StateError('guard failed'));
          throw StateError('guard failed');
        },
      );
      h.controller.close();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isStateError);
      expect(find.text('drawer'), findsOneWidget);
      expect(h.controller.isOpen, isTrue);
      fail = false;
      h.controller.close();
      await tester.pumpAndSettle();
      expect(h.closed, 1);
    });
  }

  testWidgets('guard can show a dialog and preserve the pop result',
      (tester) async {
    final h = _Harness();
    await h.open(
      tester,
      guard: () async {
        return await showDialog<bool>(
              context: h.drawerContext,
              builder: (context) => AlertDialog(
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Discard'),
                  ),
                ],
              ),
            ) ??
            false;
      },
    );
    Navigator.of(h.drawerContext).pop('result');
    await tester.pumpAndSettle();
    expect(find.text('Discard'), findsOneWidget);
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(await h.result, 'result');
    expect(h.closed, 1);
  });

  for (final pending in [false, true]) {
    testWidgets('never pops a dialog above drawer (pending: $pending)',
        (tester) async {
      final answer = Completer<bool>();
      final h = _Harness();
      await h.open(tester, guard: pending ? () => answer.future : null);
      if (pending) {
        h.controller.close();
        await tester.pump();
      }
      unawaited(
        showDialog<void>(
          context: h.drawerContext,
          builder: (_) => const AlertDialog(content: Text('other dialog')),
        ),
      );
      await tester.pumpAndSettle();
      if (pending) {
        answer.complete(true);
      } else {
        h.controller.close();
      }
      await tester.pumpAndSettle();
      expect(find.text('other dialog'), findsOneWidget);
      expect(find.text('drawer', skipOffstage: false), findsOneWidget);
      expect(h.closed, 0);
    });
  }

  for (final escape in [false, true]) {
    for (final back in [false, true]) {
      for (final method in ['escape', 'back']) {
        testWidgets(
            '$method respects independent flags escape=$escape back=$back',
            (tester) async {
          final h = _Harness();
          var calls = 0;
          await h.open(
            tester,
            guard: () {
              calls++;
              return true;
            },
            config: DrawerConfig(
              closeOnEscapeKey: escape,
              closeOnBackButton: back,
            ),
          );
          await _dismiss(tester, h, method);
          final allowed = method == 'escape' ? escape : back;
          expect(calls, allowed ? 1 : 0);
          expect(h.closed, allowed ? 1 : 0);
        });
      }
    }
  }

  testWidgets('disabled barrier and drag do not invoke guard', (tester) async {
    final h = _Harness();
    var calls = 0;
    await h.open(
      tester,
      guard: () {
        calls++;
        return true;
      },
      config: const DrawerConfig(closeOnClickOutside: false),
    );
    await _dismiss(tester, h, 'backdrop');
    await _dismiss(tester, h, 'swipe');
    expect(calls, 0);
    expect(find.text('drawer'), findsOneWidget);
  });

  for (final removeNavigator in [false, true]) {
    testWidgets(
        'pending guard is safe after removal (navigator: $removeNavigator)',
        (tester) async {
      final answer = Completer<bool>();
      final h = _Harness();
      await h.open(tester, guard: () => answer.future);
      h.controller.close();
      await tester.pump();
      if (removeNavigator) {
        await tester.pumpWidget(const SizedBox.shrink());
      } else {
        Navigator.of(h.drawerContext)
            .removeRoute(ModalRoute.of(h.drawerContext)!);
      }
      await tester.pumpAndSettle();
      answer.complete(true);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(h.closed, 0);
    });
  }

  testWidgets('maybePop preserves its result through the guard',
      (tester) async {
    final h = _Harness();
    await h.open(tester, guard: () => true);
    await Navigator.of(h.drawerContext).maybePop('selected');
    await tester.pumpAndSettle();
    expect(await h.result, 'selected');
  });

  for (final side in DrawerSide.values) {
    testWidgets('full swipe on $side restores drawer when denied',
        (tester) async {
      final h = _Harness();
      await h.open(
        tester,
        guard: () => false,
        config:
            DrawerConfig(side: side, dragEnabled: true, widthPercentage: 0.5),
      );
      final rect = tester.getRect(find.byType(Drawer));
      final offset = switch (side) {
        DrawerSide.left => const Offset(-500, 0),
        DrawerSide.right => const Offset(500, 0),
        DrawerSide.top => const Offset(0, -400),
        DrawerSide.bottom => const Offset(0, 400),
      };
      await tester.drag(find.byType(Drawer), offset);
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byType(Drawer)), rect);
      expect(h.closed, 0);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('declarative guard uses updated callback and restores controller',
      (tester) async {
    final controller = AnyDrawerController();
    addTearDown(controller.dispose);
    var allow = false;
    var closed = 0;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            final current = allow;
            return AnyDrawer(
              controller: controller,
              onWillClose: () => current,
              onClose: () => closed++,
              builder: (_) => const Text('declarative'),
            );
          },
        ),
      ),
    );
    controller.open();
    await tester.pumpAndSettle();
    controller.close();
    await tester.pumpAndSettle();
    expect(controller.isOpen, isTrue);
    expect(find.text('declarative'), findsOneWidget);
    update(() => allow = true);
    await tester.pumpAndSettle();
    controller.close();
    await tester.pumpAndSettle();
    expect(controller.isOpen, isFalse);
    expect(find.text('declarative'), findsNothing);
    expect(closed, 1);
  });

  testWidgets('removing owning widget bypasses pending guard', (tester) async {
    final controller = AnyDrawerController();
    addTearDown(controller.dispose);
    final answer = Completer<bool>();
    var visible = true;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return visible
                ? AnyDrawer(
                    controller: controller,
                    onWillClose: () => answer.future,
                    builder: (_) => const Text('owned'),
                  )
                : const Text('page');
          },
        ),
      ),
    );
    controller.open();
    await tester.pumpAndSettle();
    controller.close();
    await tester.pump();
    update(() => visible = false);
    await tester.pumpAndSettle();
    expect(find.text('owned'), findsNothing);
    answer.complete(false);
    await tester.pumpAndSettle();
    expect(controller.isOpen, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('edge region passes its close guard to drawer', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnyDrawerRegion(
            side: DrawerSide.left,
            onWillClose: () {
              calls++;
              return false;
            },
            builder: (_) => const Text('edge drawer'),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.dragFrom(const Offset(5, 300), const Offset(100, 0));
    await tester.pumpAndSettle();
    expect(find.text('edge drawer'), findsOneWidget);
    Navigator.of(tester.element(find.text('edge drawer'))).pop();
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(find.text('edge drawer'), findsOneWidget);
  });

  testWidgets('Escape with a focused text field still checks the guard',
      (tester) async {
    final h = _Harness();
    await h.open(tester);
    Navigator.of(h.drawerContext).pop();
    await tester.pumpAndSettle();
    var calls = 0;
    unawaited(
      showDrawer<void>(
        h.pageContext,
        onWillClose: () {
          calls++;
          return false;
        },
        builder: (_) => const TextField(autofocus: true),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'draft');
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(find.text('draft'), findsOneWidget);
  });

  testWidgets('local history does not reuse approval or fire onClose early',
      (tester) async {
    final h = _Harness();
    var calls = 0;
    await h.open(
      tester,
      guard: () {
        calls++;
        return true;
      },
    );
    ModalRoute.of(h.drawerContext)!.addLocalHistoryEntry(LocalHistoryEntry());
    Navigator.of(h.drawerContext).pop();
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(h.closed, 0);
    expect(find.text('drawer'), findsOneWidget);
    Navigator.of(h.drawerContext).pop('done');
    await tester.pumpAndSettle();
    expect(calls, 2);
    expect(h.closed, 1);
    expect(await h.result, 'done');
  });
}
