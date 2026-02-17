import 'dart:async' show unawaited;

import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnyDrawer v2 Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DrawerSide _side = DrawerSide.right;
  double _widthPercentage = 0.4;
  double _borderRadius = 20;
  bool _closeOnClickOutside = true;
  bool _closeOnEscapeKey = true;
  bool _dragEnabled = false;
  double _backdropBlur = 0;
  double _elevation = 0;

  DrawerConfig get _config => DrawerConfig(
        side: _side,
        widthPercentage: _widthPercentage,
        borderRadius: _borderRadius,
        closeOnClickOutside: _closeOnClickOutside,
        closeOnEscapeKey: _closeOnEscapeKey,
        dragEnabled: _dragEnabled,
        backdropBlur: _backdropBlur,
        elevation: _elevation,
        curve: Curves.easeOutCubic,
      );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AnyDrawer v2'),
        centerTitle: true,
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- v1 Use Cases ---
                Text(
                  'Use Cases',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                _UseCaseCard(
                  icon: Icons.menu,
                  title: 'Navigation Menu',
                  subtitle: 'Side menu with navigation items',
                  color: colorScheme.primaryContainer,
                  onTap: () => _showNavigationDrawer(),
                ),
                const SizedBox(height: 8),
                _UseCaseCard(
                  icon: Icons.edit_note,
                  title: 'Form Drawer',
                  subtitle: 'Contact form inside a drawer',
                  color: colorScheme.secondaryContainer,
                  onTap: () => _showFormDrawer(),
                ),
                const SizedBox(height: 8),
                _UseCaseCard(
                  icon: Icons.layers,
                  title: 'Dialog over Drawer',
                  subtitle: 'Show a dialog on top of the drawer',
                  color: colorScheme.tertiaryContainer,
                  onTap: () => _showDialogDemoDrawer(),
                ),
                const SizedBox(height: 8),
                _UseCaseCard(
                  icon: Icons.settings,
                  title: 'Settings Panel',
                  subtitle: 'Right-side settings with toggles',
                  color: colorScheme.surfaceContainerHighest,
                  onTap: () => _showSettingsDrawer(),
                ),
                const SizedBox(height: 8),
                _UseCaseCard(
                  icon: Icons.view_sidebar,
                  title: 'Multiple Drawers',
                  subtitle: 'Open left & right drawers simultaneously',
                  color: colorScheme.errorContainer,
                  onTap: () => _showMultipleDrawers(),
                ),
                const SizedBox(height: 8),
                _UseCaseCard(
                  icon: Icons.smart_button,
                  title: 'Programmatic Control',
                  subtitle: 'Open/close via controller & deep link',
                  color: colorScheme.primaryContainer,
                  onTap: () => _showProgrammaticDrawer(),
                ),

                const SizedBox(height: 32),

                // --- v2 Use Cases ---
                Text(
                  'v2.0 Features',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 12),
                _UseCaseCard(
                  icon: Icons.vertical_align_top,
                  title: 'Top & Bottom Drawers',
                  subtitle: 'Slide panels from any edge',
                  color: colorScheme.tertiaryContainer,
                  onTap: () => _showTopBottomDemo(),
                ),
                const SizedBox(height: 8),
                _UseCaseCard(
                  icon: Icons.blur_on,
                  title: 'Backdrop Blur',
                  subtitle: 'Frosted glass effect behind the drawer',
                  color: colorScheme.secondaryContainer,
                  onTap: () => _showBackdropBlurDemo(),
                ),
                const SizedBox(height: 8),
                _UseCaseCard(
                  icon: Icons.output,
                  title: 'Return Result',
                  subtitle: 'showDrawer returns Future<T?>',
                  color: colorScheme.primaryContainer,
                  onTap: () => _showReturnResultDemo(),
                ),
                const SizedBox(height: 8),
                _UseCaseCard(
                  icon: Icons.widgets,
                  title: 'Declarative AnyDrawer',
                  subtitle: 'Widget-based API with controller',
                  color: colorScheme.errorContainer,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const _DeclarativeDemoPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _UseCaseCard(
                  icon: Icons.swipe,
                  title: 'Swipe-from-Edge',
                  subtitle: 'AnyDrawerRegion gesture widget',
                  color: colorScheme.surfaceContainerHighest,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const _SwipeRegionDemoPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _UseCaseCard(
                  icon: Icons.auto_awesome,
                  title: 'Elevation & Shadow',
                  subtitle: 'Material shadow on the drawer',
                  color: colorScheme.tertiaryContainer,
                  onTap: () => _showElevationDemo(),
                ),

                const SizedBox(height: 32),

                // --- Configuration ---
                Text(
                  'Configuration',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Drawer Side',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<DrawerSide>(
                          segments: const [
                            ButtonSegment(
                              value: DrawerSide.left,
                              label: Text('Left'),
                              icon: Icon(Icons.arrow_back),
                            ),
                            ButtonSegment(
                              value: DrawerSide.right,
                              label: Text('Right'),
                              icon: Icon(Icons.arrow_forward),
                            ),
                            ButtonSegment(
                              value: DrawerSide.top,
                              label: Text('Top'),
                              icon: Icon(Icons.arrow_upward),
                            ),
                            ButtonSegment(
                              value: DrawerSide.bottom,
                              label: Text('Bottom'),
                              icon: Icon(Icons.arrow_downward),
                            ),
                          ],
                          selected: {_side},
                          onSelectionChanged: (selected) {
                            setState(() => _side = selected.first);
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Width: ${(_widthPercentage * 100).round()}%',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Slider(
                          value: _widthPercentage,
                          min: 0.2,
                          max: 0.9,
                          divisions: 14,
                          label: '${(_widthPercentage * 100).round()}%',
                          onChanged: (value) {
                            setState(() => _widthPercentage = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Border Radius: ${_borderRadius.round()}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Slider(
                          value: _borderRadius,
                          max: 40,
                          divisions: 8,
                          label: '${_borderRadius.round()}',
                          onChanged: (value) {
                            setState(() => _borderRadius = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Backdrop Blur: ${_backdropBlur.round()}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Slider(
                          value: _backdropBlur,
                          max: 20,
                          divisions: 20,
                          label: '${_backdropBlur.round()}',
                          onChanged: (value) {
                            setState(() => _backdropBlur = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Elevation: ${_elevation.round()}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Slider(
                          value: _elevation,
                          max: 24,
                          divisions: 24,
                          label: '${_elevation.round()}',
                          onChanged: (value) {
                            setState(() => _elevation = value);
                          },
                        ),
                        const Divider(height: 24),
                        SwitchListTile(
                          title: const Text('Close on click outside'),
                          value: _closeOnClickOutside,
                          onChanged: (v) =>
                              setState(() => _closeOnClickOutside = v),
                        ),
                        SwitchListTile(
                          title: const Text('Close on Escape key'),
                          value: _closeOnEscapeKey,
                          onChanged: (v) =>
                              setState(() => _closeOnEscapeKey = v),
                        ),
                        SwitchListTile(
                          title: const Text('Drag enabled'),
                          value: _dragEnabled,
                          onChanged: (v) => setState(() => _dragEnabled = v),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- v1 Use Case Drawers ----

  void _showNavigationDrawer() {
    unawaited(
      showDrawer<void>(
        context,
        builder: (context) => const _NavigationDrawerContent(),
        config: _config.copyWith(side: DrawerSide.left),
      ),
    );
  }

  void _showFormDrawer() {
    unawaited(
      showDrawer<void>(
        context,
        builder: (context) => const _FormDrawerContent(),
        config: _config,
      ),
    );
  }

  void _showDialogDemoDrawer() {
    unawaited(
      showDrawer<void>(
        context,
        builder: (context) => const _DialogDemoDrawerContent(),
        config: _config,
      ),
    );
  }

  void _showSettingsDrawer() {
    unawaited(
      showDrawer<void>(
        context,
        builder: (context) => const _SettingsDrawerContent(),
        config: _config.copyWith(side: DrawerSide.right),
      ),
    );
  }

  void _showMultipleDrawers() {
    // Open left drawer first
    unawaited(
      showDrawer<void>(
        context,
        builder: (context) => const _MultiDrawerContent(
          side: DrawerSide.left,
          title: 'Left Drawer',
          description: 'This drawer shares the screen with the right drawer. '
              'Both can be interacted with independently.',
          icon: Icons.arrow_back,
        ),
        config: DrawerConfig(
          side: DrawerSide.left,
          widthPercentage: 0.35,
          borderRadius: _borderRadius,
          closeOnClickOutside: false,
          closeOnEscapeKey: _closeOnEscapeKey,
          backdropOpacity: 0.1,
        ),
      ),
    );

    // Open right drawer on top
    unawaited(
      showDrawer<void>(
        context,
        builder: (context) => const _MultiDrawerContent(
          side: DrawerSide.right,
          title: 'Right Drawer',
          description: 'Tap outside to close this drawer and reveal '
              'the left drawer underneath.',
          icon: Icons.arrow_forward,
        ),
        config: DrawerConfig(
          side: DrawerSide.right,
          widthPercentage: 0.35,
          borderRadius: _borderRadius,
          closeOnClickOutside: _closeOnClickOutside,
          closeOnEscapeKey: _closeOnEscapeKey,
          backdropOpacity: 0.15,
        ),
      ),
    );
  }

  void _showProgrammaticDrawer() {
    final controller = AnyDrawerController();

    unawaited(
      showDrawer<void>(
        context,
        controller: controller,
        builder: (context) => _ProgrammaticDrawerContent(
          controller: controller,
        ),
        config: _config,
        onOpen: () => debugPrint('Drawer opened'),
        onClose: () {
          debugPrint('Drawer closed');
          controller.dispose();
        },
      ),
    );
  }

  // ---- v2 Use Case Drawers ----

  void _showTopBottomDemo() {
    unawaited(
      showDrawer<void>(
        context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.vertical_align_top,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Top Drawer',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Slides in from the top of the screen. '
                'Great for notification bars or top panels.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Show bottom drawer
                      unawaited(
                        showDrawer<void>(
                          this.context,
                          builder: (context) => Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.vertical_align_bottom,
                                  size: 48,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Bottom Drawer',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Like a custom bottom sheet, but with '
                                  'all AnyDrawer features.',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                FilledButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          ),
                          config: const DrawerConfig(
                            side: DrawerSide.bottom,
                            widthPercentage: 0.35,
                            borderRadius: 20,
                            curve: Curves.easeOutBack,
                          ),
                        ),
                      );
                    },
                    child: const Text('Try Bottom'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
        config: const DrawerConfig(
          side: DrawerSide.top,
          widthPercentage: 0.3,
          borderRadius: 20,
          curve: Curves.easeOutBack,
        ),
      ),
    );
  }

  void _showBackdropBlurDemo() {
    unawaited(
      showDrawer<void>(
        context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.blur_on,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Backdrop Blur',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'The content behind the drawer has a frosted glass '
                'blur effect applied via BackdropFilter.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'backdropBlur: 8.0',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
        config: const DrawerConfig(
          backdropBlur: 8,
          backdropOpacity: 0.15,
          widthPercentage: 0.5,
        ),
      ),
    );
  }

  void _showReturnResultDemo() {
    showDrawer<String>(
      context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.output,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Pick a Color',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'showDrawer now returns Future<T?>, '
              'just like showDialog.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ...['Red', 'Green', 'Blue', 'Purple'].map(
              (color) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(color),
                  child: Text(color),
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
      config: const DrawerConfig(widthPercentage: 0.4),
    ).then((result) {
      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Drawer returned: $result'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _showElevationDemo() {
    unawaited(
      showDrawer<void>(
        context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Elevation & Shadow',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'The drawer is rendered with Material elevation, '
                'casting a natural shadow.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'elevation: 16',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
        config: const DrawerConfig(
          elevation: 16,
          backdropOpacity: 0.1,
          widthPercentage: 0.45,
        ),
      ),
    );
  }
}

// --- Use Case Card Widget ---

class _UseCaseCard extends StatelessWidget {
  const _UseCaseCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 24,
                child: Icon(icon),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Navigation Drawer Content ---

class _NavigationDrawerContent extends StatelessWidget {
  const _NavigationDrawerContent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          color: colorScheme.primaryContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: colorScheme.primary,
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Jane Doe',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'jane.doe@example.com',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const _NavItem(icon: Icons.home, label: 'Home', selected: true),
        const _NavItem(icon: Icons.explore, label: 'Explore'),
        const _NavItem(icon: Icons.bookmark_border, label: 'Bookmarks'),
        const _NavItem(icon: Icons.notifications_none, label: 'Notifications'),
        const Divider(indent: 16, endIndent: 16),
        const _NavItem(icon: Icons.settings, label: 'Settings'),
        const _NavItem(icon: Icons.help_outline, label: 'Help & Feedback'),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: selected,
      selectedTileColor:
          Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      onTap: () {},
    );
  }
}

// --- Form Drawer Content ---

class _FormDrawerContent extends StatelessWidget {
  const _FormDrawerContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Text(
            'Contact Us',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fill out the form and we\'ll get back to you.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Subject',
              prefixIcon: Icon(Icons.subject),
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'general', child: Text('General')),
              DropdownMenuItem(value: 'support', child: Text('Support')),
              DropdownMenuItem(value: 'feedback', child: Text('Feedback')),
            ],
            onChanged: (_) {},
          ),
          const SizedBox(height: 16),
          TextFormField(
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Message',
              prefixIcon: Icon(Icons.message_outlined),
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.send),
            label: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

// --- Dialog Demo Drawer Content ---

class _DialogDemoDrawerContent extends StatelessWidget {
  const _DialogDemoDrawerContent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Icon(Icons.layers, size: 48, color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Dialog over Drawer',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Dialogs, bottom sheets, and menus can now be shown '
            'on top of the drawer.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hello!'),
                  content: const Text(
                    'This dialog is rendered above the drawer. '
                    'Issue #5 is fixed! 🎉',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Nice'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Show Alert Dialog'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Bottom sheet over drawer!',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.vertical_align_bottom),
            label: const Text('Show Bottom Sheet'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'AnyDrawer',
                applicationVersion: '2.0.0',
                children: [
                  const Text(
                    'Dialogs work seamlessly from inside the drawer.',
                  ),
                ],
              );
            },
            icon: const Icon(Icons.info_outline),
            label: const Text('Show About Dialog'),
          ),
        ],
      ),
    );
  }
}

// --- Settings Drawer Content ---

class _SettingsDrawerContent extends StatefulWidget {
  const _SettingsDrawerContent();

  @override
  State<_SettingsDrawerContent> createState() => _SettingsDrawerContentState();
}

class _SettingsDrawerContentState extends State<_SettingsDrawerContent> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _analytics = false;
  double _fontSize = 14;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'Appearance',
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Use dark theme'),
                secondary: const Icon(Icons.dark_mode),
                value: _darkMode,
                onChanged: (v) => setState(() => _darkMode = v),
              ),
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: const Text('Font Size'),
                subtitle: Slider(
                  value: _fontSize,
                  min: 10,
                  max: 24,
                  divisions: 7,
                  label: '${_fontSize.round()}',
                  onChanged: (v) => setState(() => _fontSize = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'Privacy',
            children: [
              SwitchListTile(
                title: const Text('Notifications'),
                subtitle: const Text('Push notifications'),
                secondary: const Icon(Icons.notifications),
                value: _notifications,
                onChanged: (v) => setState(() => _notifications = v),
              ),
              SwitchListTile(
                title: const Text('Analytics'),
                subtitle: const Text('Share usage data'),
                secondary: const Icon(Icons.analytics),
                value: _analytics,
                onChanged: (v) => setState(() => _analytics = v),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 4),
        Card(
          margin: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    );
  }
}

// --- Multiple Drawers Content ---

class _MultiDrawerContent extends StatelessWidget {
  const _MultiDrawerContent({
    required this.side,
    required this.title,
    required this.description,
    required this.icon,
  });

  final DrawerSide side;
  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Icon(icon, size: 48, color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (side == DrawerSide.left)
            OutlinedButton.icon(
              onPressed: () {
                // Open another drawer from inside this one
                unawaited(
                  showDrawer<void>(
                    context,
                    builder: (ctx) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.layers,
                            size: 48,
                            color: colorScheme.tertiary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nested Drawer!',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Drawers can be stacked on '
                            'top of each other.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ),
                    config: const DrawerConfig(
                      side: DrawerSide.right,
                      widthPercentage: 0.35,
                      borderRadius: 20,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Open Nested Drawer'),
            ),
          const Spacer(),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// --- Programmatic Control Drawer Content ---

class _ProgrammaticDrawerContent extends StatelessWidget {
  const _ProgrammaticDrawerContent({required this.controller});

  final AnyDrawerController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.smart_button,
            size: 48,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Programmatic Control',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'This drawer was opened with an AnyDrawerController. '
            'It can be closed programmatically.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Card(
            color: colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deep Linking',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You can open this drawer in response '
                    'to a deep link or push notification '
                    'by calling showDrawer() from your '
                    'route handler.',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Example:',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '// In your route handler:\n'
                      'onGenerateRoute: (settings) {\n'
                      '  if (settings.name == "/settings") {\n'
                      '    WidgetsBinding.instance\n'
                      '      .addPostFrameCallback((_) {\n'
                      '        showDrawer(context, ...);\n'
                      '      });\n'
                      '  }\n'
                      '}',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: () {
              // Close via controller (programmatic)
              controller.close();
            },
            icon: const Icon(Icons.close),
            label: const Text('Close via Controller'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close via Navigator.pop'),
          ),
        ],
      ),
    );
  }
}

// --- Declarative AnyDrawer Demo Page ---

class _DeclarativeDemoPage extends StatefulWidget {
  const _DeclarativeDemoPage();

  @override
  State<_DeclarativeDemoPage> createState() => _DeclarativeDemoPageState();
}

class _DeclarativeDemoPageState extends State<_DeclarativeDemoPage> {
  final _controller = AnyDrawerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Declarative AnyDrawer'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.widgets,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Declarative Widget API',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'The AnyDrawer widget lets you embed drawer '
                    'lifecycle management directly in your widget '
                    'tree. Open and close it via the controller.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () => _controller.open(),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open Drawer'),
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<bool>(
                    valueListenable: _controller,
                    builder: (context, isOpen, _) {
                      return Text(
                        'controller.isOpen: $isOpen',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: isOpen
                              ? colorScheme.primary
                              : colorScheme.outline,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // The declarative AnyDrawer widget — invisible in the tree,
          // manages lifecycle automatically.
          AnyDrawer(
            controller: _controller,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Declarative Drawer',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This drawer was opened by calling '
                    'controller.open(). No manual showDrawer() '
                    'call needed!',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => _controller.close(),
                    child: const Text('Close via Controller'),
                  ),
                ],
              ),
            ),
            config: const DrawerConfig(
              side: DrawerSide.right,
              widthPercentage: 0.5,
              backdropBlur: 4,
              backdropOpacity: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Swipe Region Demo Page ---

class _SwipeRegionDemoPage extends StatelessWidget {
  const _SwipeRegionDemoPage();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipe-from-Edge'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: AnyDrawerRegion(
        side: DrawerSide.left,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.swipe_right,
                size: 48,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Swipe Drawer',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'This drawer opened because you swiped '
                'from the left edge of the screen!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
        config: const DrawerConfig(
          side: DrawerSide.left,
          widthPercentage: 0.6,
          dragEnabled: true,
          backdropBlur: 3,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.swipe,
                  size: 64,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'AnyDrawerRegion',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '← Swipe from the left edge of the screen '
                  'to open the drawer.\n\n'
                  'The AnyDrawerRegion widget wraps your page '
                  'content and detects edge swipe gestures.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'AnyDrawerRegion(\n'
                    '  side: DrawerSide.left,\n'
                    '  builder: ...,\n'
                    '  child: YourPage(),\n'
                    ')',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
