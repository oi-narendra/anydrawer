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
      title: 'AnyDrawer Example',
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

// ---------------------------------------------------------------------------
// Shared configuration state
// ---------------------------------------------------------------------------

class _DrawerSettings {
  DrawerSide side = DrawerSide.right;
  double widthPercentage = 0.4;
  double borderRadius = 20;
  bool closeOnClickOutside = true;
  bool closeOnEscapeKey = true;
  bool dragEnabled = false;
  double backdropBlur = 0;
  double elevation = 0;

  DrawerConfig toConfig() => DrawerConfig(
        side: side,
        widthPercentage: widthPercentage,
        borderRadius: borderRadius,
        closeOnClickOutside: closeOnClickOutside,
        closeOnEscapeKey: closeOnEscapeKey,
        dragEnabled: dragEnabled,
        backdropBlur: backdropBlur,
        elevation: elevation,
        curve: Curves.easeOutCubic,
      );
}

/// Returns a responsive widthPercentage based on screen size.
double _responsiveWidth(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  if (w < 600) return 0.7;
  if (w < 1000) return 0.4;
  return 0.3;
}

// ---------------------------------------------------------------------------
// Home page
// ---------------------------------------------------------------------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _settings = _DrawerSettings();

  DrawerConfig get _config =>
      _settings.toConfig().copyWith(widthPercentage: _responsiveWidth(context));

  // All use-case definitions in one flat list.
  late final List<_UseCase> _useCases = [
    _UseCase(
      icon: Icons.menu,
      title: 'Navigation Menu',
      subtitle: 'Side menu with nav items',
      color: _seed(0),
      onTap: _showNavigationDrawer,
    ),
    _UseCase(
      icon: Icons.edit_note,
      title: 'Form Drawer',
      subtitle: 'Contact form in a drawer',
      color: _seed(1),
      onTap: _showFormDrawer,
    ),
    _UseCase(
      icon: Icons.layers,
      title: 'Dialog over Drawer',
      subtitle: 'Show dialogs on top',
      color: _seed(2),
      onTap: _showDialogDemoDrawer,
    ),
    _UseCase(
      icon: Icons.settings,
      title: 'Settings Panel',
      subtitle: 'Right-side toggles',
      color: _seed(3),
      onTap: _showSettingsDrawer,
    ),
    _UseCase(
      icon: Icons.view_sidebar,
      title: 'Multiple Drawers',
      subtitle: 'Left + right simultaneously',
      color: _seed(4),
      onTap: _showMultipleDrawers,
    ),
    _UseCase(
      icon: Icons.smart_button,
      title: 'Programmatic Control',
      subtitle: 'Controller & deep linking',
      color: _seed(5),
      onTap: _showProgrammaticDrawer,
    ),
    _UseCase(
      icon: Icons.vertical_align_top,
      title: 'Top & Bottom',
      subtitle: 'Panels from any edge',
      color: _seed(6),
      onTap: _showTopBottomDemo,
    ),
    _UseCase(
      icon: Icons.blur_on,
      title: 'Backdrop Blur',
      subtitle: 'Frosted glass effect',
      color: _seed(7),
      onTap: _showBackdropBlurDemo,
    ),
    _UseCase(
      icon: Icons.output,
      title: 'Return Result',
      subtitle: 'Future<T?> like showDialog',
      color: _seed(8),
      onTap: _showReturnResultDemo,
    ),
    _UseCase(
      icon: Icons.widgets,
      title: 'Declarative Widget',
      subtitle: 'AnyDrawer widget API',
      color: _seed(9),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const _DeclarativeDemoPage(),
        ),
      ),
    ),
    _UseCase(
      icon: Icons.swipe,
      title: 'Swipe-from-Edge',
      subtitle: 'AnyDrawerRegion gesture',
      color: _seed(10),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const _SwipeRegionDemoPage(),
        ),
      ),
    ),
    _UseCase(
      icon: Icons.auto_awesome,
      title: 'Elevation & Shadow',
      subtitle: 'Material shadow on drawer',
      color: _seed(11),
      onTap: _showElevationDemo,
    ),
  ];

  /// Derive a colour from the seed palette for visual variety.
  Color _seed(int index) {
    const hues = [
      0xFF6750A4,
      0xFF3F8CFF,
      0xFF00BFA5,
      0xFFFF8A65,
      0xFFEC407A,
      0xFF7E57C2,
      0xFF26A69A,
      0xFF42A5F5,
      0xFFAB47BC,
      0xFF66BB6A,
      0xFFEF5350,
      0xFFFFCA28,
    ];
    return Color(hues[index % hues.length]).withValues(alpha: 0.2);
  }

  // ---- Settings bottom sheet ----

  void _openSettings() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _SettingsSheet(
        settings: _settings,
        onChanged: () => setState(() {}),
      ),
    );
  }

  // ---- Build ----

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AnyDrawer'),
        centerTitle: true,
        backgroundColor: colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Drawer Settings',
            onPressed: _openSettings,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive column count.
          final width = constraints.maxWidth;
          final int crossAxisCount;
          if (width < 400) {
            crossAxisCount = 1;
          } else if (width < 700) {
            crossAxisCount = 2;
          } else if (width < 1000) {
            crossAxisCount = 3;
          } else {
            crossAxisCount = 4;
          }

          // For single column, cards are wide so use a wider ratio.
          // For multi-column, use a squarer ratio to fit content.
          final double aspectRatio = crossAxisCount == 1 ? 2.8 : 1.1;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: aspectRatio,
            ),
            itemCount: _useCases.length,
            itemBuilder: (context, index) {
              final uc = _useCases[index];
              return _UseCaseCard(
                icon: uc.icon,
                title: uc.title,
                subtitle: uc.subtitle,
                color: uc.color,
                onTap: uc.onTap,
              );
            },
          );
        },
      ),
    );
  }

  // ---- Use-case drawer handlers ----

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
    unawaited(
      showDrawer<void>(
        context,
        builder: (context) => const _MultiDrawerContent(
          side: DrawerSide.left,
          title: 'Left Drawer',
          description: 'This drawer shares the screen with the right drawer.',
          icon: Icons.arrow_back,
        ),
        config: DrawerConfig(
          side: DrawerSide.left,
          widthPercentage: _responsiveWidth(context) * 0.6,
          borderRadius: _settings.borderRadius,
          closeOnClickOutside: false,
          backdropOpacity: 0.1,
        ),
      ),
    );
    unawaited(
      showDrawer<void>(
        context,
        builder: (context) => const _MultiDrawerContent(
          side: DrawerSide.right,
          title: 'Right Drawer',
          description: 'Tap outside to close and reveal the left drawer.',
          icon: Icons.arrow_forward,
        ),
        config: DrawerConfig(
          side: DrawerSide.right,
          widthPercentage: _responsiveWidth(context) * 0.6,
          borderRadius: _settings.borderRadius,
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
        builder: (context) =>
            _ProgrammaticDrawerContent(controller: controller),
        config: _config,
        onClose: () => controller.dispose(),
      ),
    );
  }

  void _showTopBottomDemo() {
    unawaited(
      showDrawer<void>(
        context,
        builder: (context) => _CenteredDemoContent(
          icon: Icons.vertical_align_top,
          title: 'Top Drawer',
          description: 'Slides from the top. '
              'Great for notification bars.',
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                unawaited(
                  showDrawer<void>(
                    this.context,
                    builder: (_) => const _CenteredDemoContent(
                      icon: Icons.vertical_align_bottom,
                      title: 'Bottom Drawer',
                      description: 'Like a custom bottom sheet with '
                          'all AnyDrawer features.',
                    ),
                    config: DrawerConfig(
                      side: DrawerSide.bottom,
                      widthPercentage: _responsiveWidth(this.context),
                      curve: Curves.easeOutBack,
                    ),
                  ),
                );
              },
              child: const Text('Try Bottom'),
            ),
          ],
        ),
        config: DrawerConfig(
          side: DrawerSide.top,
          widthPercentage: _responsiveWidth(context),
          curve: Curves.easeOutBack,
        ),
      ),
    );
  }

  void _showBackdropBlurDemo() {
    unawaited(
      showDrawer<void>(
        context,
        builder: (_) => const _CenteredDemoContent(
          icon: Icons.blur_on,
          title: 'Backdrop Blur',
          description: 'Frosted glass behind the drawer via BackdropFilter.\n'
              'backdropBlur: 8.0',
        ),
        config: DrawerConfig(
          backdropBlur: 8,
          backdropOpacity: 0.15,
          widthPercentage: _responsiveWidth(context),
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.output,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Pick a Color',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'showDrawer returns Future<T?>, just like showDialog.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ...['Red', 'Green', 'Blue', 'Purple'].map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(c),
                  child: Text(c),
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
      config: DrawerConfig(widthPercentage: _responsiveWidth(context)),
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
        builder: (_) => const _CenteredDemoContent(
          icon: Icons.auto_awesome,
          title: 'Elevation & Shadow',
          description: 'Material elevation shadow on the drawer.\n'
              'elevation: 16',
        ),
        config: DrawerConfig(
          elevation: 16,
          backdropOpacity: 0.1,
          widthPercentage: _responsiveWidth(context),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Use-case data class
// ---------------------------------------------------------------------------

class _UseCase {
  const _UseCase({
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
}

// ---------------------------------------------------------------------------
// Settings bottom sheet
// ---------------------------------------------------------------------------

class _SettingsSheet extends StatefulWidget {
  const _SettingsSheet({
    required this.settings,
    required this.onChanged,
  });

  final _DrawerSettings settings;
  final VoidCallback onChanged;

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  _DrawerSettings get s => widget.settings;

  void _update(VoidCallback fn) {
    setState(fn);
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Drawer Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'These apply to the use-case demos.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),

          // Side
          Text('Side', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<DrawerSide>(
            segments: const [
              ButtonSegment(
                value: DrawerSide.left,
                label: Text('L'),
                icon: Icon(Icons.arrow_back, size: 16),
              ),
              ButtonSegment(
                value: DrawerSide.right,
                label: Text('R'),
                icon: Icon(Icons.arrow_forward, size: 16),
              ),
              ButtonSegment(
                value: DrawerSide.top,
                label: Text('T'),
                icon: Icon(Icons.arrow_upward, size: 16),
              ),
              ButtonSegment(
                value: DrawerSide.bottom,
                label: Text('B'),
                icon: Icon(Icons.arrow_downward, size: 16),
              ),
            ],
            selected: {s.side},
            onSelectionChanged: (sel) => _update(() => s.side = sel.first),
          ),
          const SizedBox(height: 20),

          // Sliders
          _SliderRow(
            label: 'Width',
            value: s.widthPercentage,
            min: 0.2,
            max: 0.9,
            divisions: 14,
            format: (v) => '${(v * 100).round()}%',
            onChanged: (v) => _update(() => s.widthPercentage = v),
          ),
          _SliderRow(
            label: 'Border Radius',
            value: s.borderRadius,
            max: 40,
            divisions: 8,
            format: (v) => '${v.round()}',
            onChanged: (v) => _update(() => s.borderRadius = v),
          ),
          _SliderRow(
            label: 'Backdrop Blur',
            value: s.backdropBlur,
            max: 20,
            divisions: 20,
            format: (v) => '${v.round()}',
            onChanged: (v) => _update(() => s.backdropBlur = v),
          ),
          _SliderRow(
            label: 'Elevation',
            value: s.elevation,
            max: 24,
            divisions: 24,
            format: (v) => '${v.round()}',
            onChanged: (v) => _update(() => s.elevation = v),
          ),
          const Divider(height: 24),

          // Toggles
          SwitchListTile(
            title: const Text('Close on tap outside'),
            value: s.closeOnClickOutside,
            onChanged: (v) => _update(() => s.closeOnClickOutside = v),
          ),
          SwitchListTile(
            title: const Text('Close on Escape key'),
            value: s.closeOnEscapeKey,
            onChanged: (v) => _update(() => s.closeOnEscapeKey = v),
          ),
          SwitchListTile(
            title: const Text('Drag to dismiss'),
            value: s.dragEnabled,
            onChanged: (v) => _update(() => s.dragEnabled = v),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.max,
    required this.divisions,
    required this.format,
    required this.onChanged,
    this.min = 0,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String Function(double) format;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label: ${format(value)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Grid card
// ---------------------------------------------------------------------------

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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 22,
                child: Icon(icon, size: 22, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable centered demo content
// ---------------------------------------------------------------------------

class _CenteredDemoContent extends StatelessWidget {
  const _CenteredDemoContent({
    required this.icon,
    required this.title,
    required this.description,
    this.actions = const [],
  });

  final IconData icon;
  final String title;
  final String description;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(description, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ...actions,
          if (actions.isNotEmpty) const SizedBox(height: 8),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Navigation Drawer Content
// ---------------------------------------------------------------------------

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
                child:
                    Icon(Icons.person, size: 32, color: colorScheme.onPrimary),
              ),
              const SizedBox(height: 12),
              Text(
                'Jane Doe',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
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

// ---------------------------------------------------------------------------
// Form Drawer Content
// ---------------------------------------------------------------------------

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
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
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

// ---------------------------------------------------------------------------
// Dialog Demo Drawer Content
// ---------------------------------------------------------------------------

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
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Dialogs, bottom sheets, and menus render on top of the drawer.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Hello!'),
                  content: const Text('This dialog is above the drawer. 🎉'),
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
                builder: (_) => Padding(
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
                  const Text('Dialogs work seamlessly inside drawers.'),
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

// ---------------------------------------------------------------------------
// Settings Drawer Content
// ---------------------------------------------------------------------------

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
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _SectionCard(
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
          _SectionCard(
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

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

// ---------------------------------------------------------------------------
// Multiple Drawers Content
// ---------------------------------------------------------------------------

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
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(description, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          if (side == DrawerSide.left)
            OutlinedButton.icon(
              onPressed: () {
                unawaited(
                  showDrawer<void>(
                    context,
                    builder: (_) => const _CenteredDemoContent(
                      icon: Icons.layers,
                      title: 'Nested Drawer!',
                      description: 'Drawers can be stacked.',
                    ),
                    config: DrawerConfig(
                      side: DrawerSide.right,
                      widthPercentage: _responsiveWidth(context),
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

// ---------------------------------------------------------------------------
// Programmatic Control Drawer Content
// ---------------------------------------------------------------------------

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
          Icon(Icons.smart_button, size: 48, color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Programmatic Control',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Opened via AnyDrawerController. '
            'Use controller.close() to dismiss.',
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
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Call showDrawer() from your route handler '
                    'to open a drawer on deep-link navigation.',
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: () => controller.close(),
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

// ---------------------------------------------------------------------------
// Declarative AnyDrawer Demo Page
// ---------------------------------------------------------------------------

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
                  Icon(Icons.widgets, size: 64, color: colorScheme.primary),
                  const SizedBox(height: 24),
                  Text(
                    'Declarative Widget API',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'AnyDrawer widget manages drawer lifecycle '
                    'in your widget tree. Open/close via the controller.',
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
                    builder: (context, isOpen, _) => Text(
                      'controller.isOpen: $isOpen',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color:
                            isOpen ? colorScheme.primary : colorScheme.outline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnyDrawer(
            controller: _controller,
            builder: (context) => const _CenteredDemoContent(
              icon: Icons.check_circle,
              title: 'Declarative Drawer',
              description: 'Opened by controller.open(). '
                  'No manual showDrawer() call needed!',
            ),
            config: DrawerConfig(
              side: DrawerSide.right,
              widthPercentage: _responsiveWidth(context),
              backdropBlur: 4,
              backdropOpacity: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Swipe Region Demo Page
// ---------------------------------------------------------------------------

class _SwipeRegionDemoPage extends StatelessWidget {
  const _SwipeRegionDemoPage();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final drawerWidth = _responsiveWidth(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipe-from-Edge'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      // Nest two AnyDrawerRegions: left wraps right wraps content.
      body: AnyDrawerRegion(
        side: DrawerSide.left,
        builder: (_) => const _CenteredDemoContent(
          icon: Icons.swipe_right,
          title: 'Left Swipe Drawer',
          description: 'Opened by swiping from the left edge!',
        ),
        config: DrawerConfig(
          side: DrawerSide.left,
          widthPercentage: drawerWidth,
          dragEnabled: true,
          backdropBlur: 3,
        ),
        child: AnyDrawerRegion(
          side: DrawerSide.right,
          builder: (_) => const _CenteredDemoContent(
            icon: Icons.swipe_left,
            title: 'Right Swipe Drawer',
            description: 'Opened by swiping from the right edge!',
          ),
          config: DrawerConfig(
            side: DrawerSide.right,
            widthPercentage: drawerWidth,
            dragEnabled: true,
            backdropBlur: 3,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.swipe, size: 64, color: colorScheme.primary),
                  const SizedBox(height: 24),
                  Text(
                    'AnyDrawerRegion',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '← Swipe from the left edge\n'
                    'Swipe from the right edge →\n\n'
                    'Both directions are active. '
                    'AnyDrawerRegion widgets can be nested.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
