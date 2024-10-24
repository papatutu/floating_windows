import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:equatable/equatable.dart';

part 'floating_overlay_controller.dart';
part 'floating_overlay_cursor.dart';
part 'floating_overlay_offset.dart';
part 'floating_overlay_scale.dart';
part 'floating_overlay_data.dart';
part 'reposition.dart';
part 'rescale.dart';
part 'cursor_resizing.dart';
part 'size_extension.dart';
part 'cursor_border_side.dart';

class FloatingOverlay extends StatefulWidget {
  const FloatingOverlay({
    Key? key,

    /// The child underneath this widget inside the widget tree.
    this.child,

    /// Used to controll the visibility state of the [floatingChild].
    this.controllers,

    /// Widget that will be floating around.
    this.floatingChildren,

    /// When you push pages on top, the floating child will vanish and reappear
    /// when you return if you give it an RouteObserver linked to the main
    /// MaterialApp.
    this.routeObserver,
  })  : assert(
          controllers == null || floatingChildren == null || controllers.length == floatingChildren.length,
          'The length of controllers and floatingChildren must be the same.',
        ),
        super(key: key);

  /// The child underneath this widget inside the widget tree.
  final Widget? child;

  /// Widget that will be floating around.
  final List<Widget>? floatingChildren;

  /// Used to controll the visibility state of the [floatingChild].
  final List<FloatingOverlayController>? controllers;

  /// When you push pages on top, the floating child will vanish and reappear
  /// when you return if you give it an RouteObserver linked to the main
  /// MaterialApp.
  final RouteObserver? routeObserver;

  @override
  State<FloatingOverlay> createState() => _FloatingOverlayState();
}

class _FloatingOverlayState extends State<FloatingOverlay> with RouteAware {
  static const empty = SizedBox.shrink();

  final key = GlobalKey();
  final floatingWidgetKey = GlobalKey();
  bool floating = false;

  void startControllers(BuildContext context, BoxConstraints constraints) {
    final offset = widgetOffset();
    final _endOffset = endOffset(offset, constraints.biggest);
    final limits = Rect.fromPoints(offset, _endOffset);
    for (int i = 0; i < widget.controllers!.length; i++) {
      widget.controllers![i]._initState(context, widget.floatingChildren![i], limits);
    }
  }

  Offset widgetOffset() {
    final box = key.currentContext!.findRenderObject()! as RenderBox;
    return box.localToGlobal(Offset.zero);
  }

  Offset endOffset(Offset start, Size maxSize) {
    final maxSizeOffset = Offset(maxSize.width, maxSize.height);
    return start + maxSizeOffset;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver?.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    for (int i = 0; i < widget.controllers!.length; i++) {
      if (widget.controllers![i].isFloating) {
        widget.controllers![i].show();
      }
    }
  }

  @override
  void didPushNext() {
    for (int i = 0; i < widget.controllers!.length; i++) {
      if (widget.controllers![i].isFloating) {
        widget.controllers![i].hide();
      }
    }
  }

  @override
  void dispose() {
    widget.routeObserver?.unsubscribe(this);
    for (final controller in widget.controllers!) {
      controller._dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return LayoutBuilder(
          key: key,
          builder: (context, constraints) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => startControllers(context, constraints),
            );
            return widget.child ?? empty;
          },
        );
      },
    );
  }
}
