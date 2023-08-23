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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Close on click outside'),
                    value: config.closeOnClickOutside,
                    onChanged: (value) {
                      setState(() {
                        config = config.copyWith(closeOnClickOutside: value);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Enable edge drag'),
                    value: config.dragEnabled,
                    onChanged: (value) {
                      setState(() {
                        config = config.copyWith(enableEdgeDrag: value);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 20),
                // drawer side
                Expanded(
                  child: DropdownButton<DrawerSide>(
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
                ),
              ],
            ),
            const SizedBox(height: 20),
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
