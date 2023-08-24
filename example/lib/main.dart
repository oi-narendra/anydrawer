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
    return MaterialApp(
      title: 'Any Drawer Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Any Drawer Example App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DrawerConfig config = const DrawerConfig();

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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width / 2,
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
            DropdownButtonFormField<BoxConstraints>(
              isExpanded: true,
              value: config.constraints ??
                  BoxConstraints.tightFor(
                      width: MediaQuery.of(context).size.width * 0.3),
              onChanged: (value) {
                setState(() {
                  config = config.copyWith(constraints: value);
                });
              },
              items: [
                DropdownMenuItem(
                  value: BoxConstraints.tightFor(
                      width: MediaQuery.of(context).size.width * 0.3),
                  child: const Text('Width: 30%'),
                ),
                DropdownMenuItem(
                  value: BoxConstraints.tightFor(
                      width: MediaQuery.of(context).size.width * 0.5),
                  child: const Text('Width: 50%'),
                ),
                DropdownMenuItem(
                  value: BoxConstraints.tightFor(
                      width: MediaQuery.of(context).size.width * 0.7),
                  child: const Text('Width: 70%'),
                ),
                DropdownMenuItem(
                  value: BoxConstraints.tightFor(
                      width: MediaQuery.of(context).size.width * 0.9),
                  child: const Text('Width: 90%'),
                ),
              ],
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
