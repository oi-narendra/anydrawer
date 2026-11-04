part of 'anydrawer.dart';

List<double>? _validateSnapSizes(DrawerConfig config) {
  final sizes = config.snapSizes;
  if (sizes == null) return null;
  if (config.side != DrawerSide.top && config.side != DrawerSide.bottom) {
    throw ArgumentError('snapSizes requires a top or bottom drawer');
  }
  if (sizes.isEmpty) {
    throw ArgumentError.value(sizes, 'snapSizes', 'must not be empty');
  }
  var previous = 0.0;
  for (final size in sizes) {
    if (!size.isFinite || size <= previous || size > 1) {
      throw ArgumentError.value(
        sizes,
        'snapSizes',
        'must be strictly increasing values in (0, 1]',
      );
    }
    previous = size;
  }
  return List<double>.unmodifiable(sizes);
}

class _SnapDrawer extends StatefulWidget {
  const _SnapDrawer({
    required this.sizes,
    required this.availableExtent,
    required this.config,
    required this.canResize,
    required this.onDismiss,
    required this.builder,
    this.onDragUpdate,
    this.onDragEnd,
  });

  final List<double> sizes;
  final double availableExtent;
  final DrawerConfig config;
  final bool Function() canResize;
  final VoidCallback onDismiss;
  final Widget Function(double, Widget) builder;
  final DrawerDragCallback? onDragUpdate;
  final DrawerDragEndCallback? onDragEnd;

  @override
  State<_SnapDrawer> createState() => _SnapDrawerState();
}

class _SnapDrawerState extends State<_SnapDrawer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _extent;
  late int _selected;
  bool _dragging = false;

  bool get _enabled => widget.config.dragEnabled == true && widget.canResize();
  double get _direction => widget.config.side == DrawerSide.top ? 1 : -1;

  List<double> get _pixels => widget.sizes.map((fraction) {
        var size = widget.availableExtent * fraction;
        if (widget.config.maxWidth != null && size > widget.config.maxWidth!) {
          size = widget.config.maxWidth!;
        }
        if (widget.config.minWidth != null && size < widget.config.minWidth!) {
          size = widget.config.minWidth!;
        }
        return size.clamp(0.0, widget.availableExtent);
      }).toList();

  @override
  void initState() {
    super.initState();
    _selected = 0;
    final initial = widget.config.widthPercentage;
    if (initial != null) {
      for (var i = 1; i < widget.sizes.length; i++) {
        if ((widget.sizes[i] - initial).abs() <
            (widget.sizes[_selected] - initial).abs()) {
          _selected = i;
        }
      }
    }
    _extent =
        AnimationController.unbounded(vsync: this, value: _pixels[_selected]);
  }

  @override
  void didUpdateWidget(covariant _SnapDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.availableExtent != widget.availableExtent) {
      _dragging = false;
      _extent.stop();
      _extent.value = _pixels[_selected];
    }
  }

  @override
  void dispose() {
    _extent.dispose();
    super.dispose();
  }

  void _snapTo(int index) {
    _selected = index;
    _extent.animateTo(
      _pixels[index],
      duration: widget.config.animationDuration,
      curve: widget.config.curve,
    );
  }

  void _start(DragStartDetails details) {
    if (!_enabled || widget.availableExtent <= 0) return;
    _dragging = true;
    _extent.stop();
  }

  void _update(DragUpdateDetails details) {
    if (!_dragging || !_enabled) return;
    widget.onDragUpdate?.call(details);
    _extent.value = (_extent.value + details.primaryDelta! * _direction)
        .clamp(0.0, _pixels.last);
  }

  void _end(DragEndDetails details) {
    if (!_dragging) return;
    _dragging = false;
    widget.onDragEnd?.call(details);
    if (!_enabled) {
      _snapTo(_selected);
      return;
    }
    final sizes = _pixels;
    if (_extent.value < sizes.first / 2) {
      _snapTo(_selected);
      widget.onDismiss();
      return;
    }
    var nearest = 0;
    for (var i = 1; i < sizes.length; i++) {
      if ((sizes[i] - _extent.value).abs() <
          (sizes[nearest] - _extent.value).abs()) {
        nearest = i;
      }
    }
    _snapTo(nearest);
  }

  void _cancel() {
    _dragging = false;
    _snapTo(_selected);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _extent,
      builder: (context, _) {
        final height = _extent.value.clamp(0.0, widget.availableExtent);
        final handle = SizedBox(
          height: height.clamp(0.0, 48.0),
          child: Semantics(
            label: 'Resize drawer',
            value: '${(widget.sizes[_selected] * 100).round()}%',
            increasedValue: _selected < widget.sizes.length - 1
                ? '${(widget.sizes[_selected + 1] * 100).round()}%'
                : null,
            decreasedValue: _selected > 0
                ? '${(widget.sizes[_selected - 1] * 100).round()}%'
                : null,
            onIncrease: _enabled && _selected < widget.sizes.length - 1
                ? () {
                    if (_enabled) _snapTo(_selected + 1);
                  }
                : null,
            onDecrease: _enabled && _selected > 0
                ? () {
                    if (_enabled) _snapTo(_selected - 1);
                  }
                : null,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragStart: _start,
              onVerticalDragUpdate: _update,
              onVerticalDragEnd: _end,
              onVerticalDragCancel: _cancel,
              child: InkWell(
                onTap: widget.config.dragEnabled == true
                    ? () {
                        if (_enabled) {
                          _snapTo((_selected + 1) % widget.sizes.length);
                        }
                      }
                    : null,
                child: Center(
                  child: Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        return widget.builder(height, handle);
      },
    );
  }
}
