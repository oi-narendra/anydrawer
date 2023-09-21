import 'dart:async';

import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Any Drawer Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerDelegate: AnyDrawerRouterDelegate(
        builder: (context) => const MyHomePage(title: 'Any Drawer Example'),
      ),
    );
  }
}

class AnyDrawerRouterDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
  AnyDrawerRouterDelegate({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          child: builder(context),
        ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        notifyListeners();

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  Uri? get currentConfiguration => null;

  @override
  Future<void> setNewRoutePath(Uri configuration) async {}
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DrawerConfig config = const DrawerConfig();

  final AnyDrawerController controller = AnyDrawerController();

  void _showDrawer() {
    showDrawer(
      context,
      builder: (context) {
        return Center(
          child: config.side == DrawerSide.left
              ? const Text('Left Drawer')
              : const Text('Right Drawer'),
        );
      },
      config: config,
      onClose: () {
        debugPrint('Drawer closed');
      },
      onOpen: () {
        debugPrint('Drawer opened');
      },
      controller: controller,
    );

    Timer(const Duration(seconds: 5), () {
      controller.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: width > 600 ? width / 2 : width,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text('Any Drawer Example App',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 50),
            DropdownButton<DrawerSide>(
              isExpanded: true,
              value: config.side,
              onChanged: (value) {
                setState(() {
                  config = config.copyWith(side: value);
                });
              },
              items: const [
                DropdownMenuItem(
                  value: DrawerSide.left,
                  child: Text('Left'),
                ),
                DropdownMenuItem(
                  value: DrawerSide.right,
                  child: Text('Right'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<double>(
              isExpanded: true,
              value: config.widthPercentage ?? 0.3,
              onChanged: (value) {
                setState(() {
                  config = config.copyWith(widthPercentage: value);
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 0.3,
                  child: Text('Width: 30%'),
                ),
                DropdownMenuItem(
                  value: 0.5,
                  child: Text('Width: 50%'),
                ),
                DropdownMenuItem(
                  value: 0.7,
                  child: Text('Width: 70%'),
                ),
                DropdownMenuItem(
                  value: 0.8,
                  child: Text('Width: 90%'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: config.borderRadius.toString(),
              onChanged: (value) {
                setState(() {
                  config = config.copyWith(borderRadius: double.parse(value));
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Border Radius',
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text('Close on click outside'),
              value: config.closeOnClickOutside,
              onChanged: (value) {
                setState(() {
                  config = config.copyWith(closeOnClickOutside: value);
                });
              },
            ),
            const SizedBox(width: 20),
            CheckboxListTile(
              title: const Text('Close on Esc Pressed'),
              value: config.closeOnEscapeKey,
              onChanged: (value) {
                setState(() {
                  config = config.copyWith(closeOnEscapeKey: value);
                });
              },
            ),
            const SizedBox(width: 20),
            CheckboxListTile(
              title: const Text('Enable edge drag'),
              value: config.dragEnabled,
              onChanged: (value) {
                setState(() {
                  config = config.copyWith(enableEdgeDrag: value);
                });
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                _showDrawer();
              },
              child: const Text('Show Drawer'),
            ),
          ],
        ),
      ),
    );
  }
}
