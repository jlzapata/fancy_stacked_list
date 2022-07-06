import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StackedList extends StatefulWidget {
  const StackedList(
      {Key? key,
      required this.itemBuilder,
      required this.itemCount,
      int? itemExtent})
      : itemExtent = itemExtent ?? itemCount + 1,
        super(key: key);

  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final int itemExtent;

  @override
  State<StackedList> createState() => _StackedListState();
}

class _StackedListState extends State<StackedList>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  bool open = true;
  VerticalDirection _direction = VerticalDirection.up;

  final _colorTween = ColorTween(
      begin: Colors.white, end: const Color.fromARGB(255, 7, 219, 25));

  late final AnimationController _controller;
  late final AnimationController _openCloseController;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: -1,
      value: 0,
    );
    _openCloseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      value: 1,
    );

    _controller.addStatusListener(_updateIndex);

    super.initState();
  }

  _updateIndex(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        if (_direction == VerticalDirection.up) {
          currentIndex += 1;
        } else {
          currentIndex -= 1;
        }
      });
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _openCloseController.dispose();
    _controller.removeStatusListener(_updateIndex);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        alignment: Alignment.center,
        children: [
          for (int index = currentIndex + widget.itemExtent;
              index >= currentIndex;
              index--)
            _buildStackedListItem(index, constraints.maxHeight)
        ],
      ),
    );
  }

  _StackedListItem _buildStackedListItem(int index, double maxHeight) {
    int stackIndex = index - currentIndex;

    return _StackedListItem(
      stackIndex: stackIndex,
      colorTween: _colorTween,
      index: index,
      swipeEnabled: stackIndex == 0 && open,
      height: 400,
      maxExtent: 400 / 2 + maxHeight / 2,
      animation: _controller.view,
      openCloseAnimation: _openCloseController.view,
      onTap: () {
        if (open) {
          _openCloseController.reverse();
        } else {
          _openCloseController.forward();
        }
        setState(() {
          open = !open;
        });
      },
      onDrag: (distance) {
        _controller.value = distance;
      },
      onDragEnd: _onDragEnd,
      builder: widget.itemBuilder,
    );
  }

  _onDragEnd(double distance) {
    if (distance < -0.25) {
      _controller.animateTo(-1);
      _direction = VerticalDirection.down;
    } else if (distance < 0.25) {
      _controller.animateBack(0);
    } else {
      _controller.animateTo(1);
      _direction = VerticalDirection.up;
    }
  }
}

class _StackedListItem extends StatefulWidget {
  const _StackedListItem({
    Key? key,
    required this.stackIndex,
    required this.colorTween,
    required this.builder,
    required this.index,
    required this.height,
    required this.animation,
    required this.openCloseAnimation,
    this.onTap,
    this.onDrag,
    this.onDragEnd,
    this.swipeEnabled = false,
    required this.maxExtent,
  }) : super(key: key);

  final int stackIndex;
  final ColorTween colorTween;
  final IndexedWidgetBuilder builder;
  final int index;
  final bool swipeEnabled;
  final double height;
  final double maxExtent;
  final GestureTapCallback? onTap;
  final OnDragCallback? onDrag;
  final OnDragCallback? onDragEnd;
  final Animation<double> animation;
  final Animation<double> openCloseAnimation;

  @override
  State<_StackedListItem> createState() => _StackedListItemState();
}

class _StackedListItemState extends State<_StackedListItem> {
  late Tween<double> translationTween;
  late Animation<double> scaleAnimation;
  late Animation<double> opacityAnimation;
  double verticalDrag = 0.0;

  @override
  void initState() {
    double start = log(widget.stackIndex + 1) * -50;
    double end = widget.stackIndex == 0
        ? widget.maxExtent
        : log(widget.stackIndex) * -50;
    translationTween = Tween(begin: start, end: end);
    scaleAnimation = Tween(
            begin: 1 - (widget.stackIndex * 0.1),
            end: 1 - ((widget.stackIndex - 1) * 0.1))
        .animate(widget.animation);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant _StackedListItem oldWidget) {
    if (oldWidget.index != widget.index) {
      double start = log(widget.stackIndex + 1) * -50;
      double end = widget.stackIndex == 0
          ? widget.maxExtent
          : log(widget.stackIndex) * -50;
      translationTween = Tween(begin: start, end: end);
      scaleAnimation = Tween(
              begin: 1 - (widget.stackIndex * 0.1),
              end: 1 - ((widget.stackIndex - 1) * 0.1))
          .animate(widget.animation);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          Listenable.merge([widget.animation, widget.openCloseAnimation]),
      builder: (context, child) {
        if (widget.stackIndex == 0) {
          // print("MaxExtent: ${widget.maxExtent}");
          // print("Animation: ${widget.animation.value}");
          print("Translation: ${translationTween.evaluate(widget.animation)}");
          // print("Scale: ${scaleAnimation.value}");
        }
        return Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.identity()
              ..translate(
                  0.0,
                  translationTween.evaluate(widget.animation) *
                      widget.openCloseAnimation.value)
              ..scale(scaleAnimation.value.clamp(0.0, 1.0),
                  scaleAnimation.value.clamp(0.0, 1.0)),
            child: Opacity(
                opacity: widget.stackIndex != 5
                    ? kAlwaysCompleteAnimation.value
                    : const Interval(0.0, 0.3)
                        .transform(widget.animation.value.clamp(0.0, 1.0)),
                child: child));
      },
      child: GestureDetector(
        onTap: () => widget.onTap?.call(),
        onVerticalDragUpdate: widget.swipeEnabled
            ? (details) {
                print("Drag: $verticalDrag");
                verticalDrag += details.delta.dy;
                widget.onDrag?.call(verticalDrag / widget.maxExtent);
              }
            : null,
        onVerticalDragEnd: widget.swipeEnabled
            ? (details) {
                final distance = verticalDrag / widget.maxExtent;

                if (distance < -0.25) {
                  translationTween =
                      Tween(begin: verticalDrag, end: widget.maxExtent);
                }

                widget.onDragEnd?.call(verticalDrag / widget.maxExtent);
                verticalDrag = 0.0;
              }
            : null,
        child: Container(
            width: 300,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.colorTween
                  .transform(1 - (1 - (0.15 * widget.stackIndex))),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, -5),
                  blurRadius: 5,
                ),
              ],
            ),
            child: widget.builder(context, widget.index)),
      ),
    );
  }
}

typedef OnDragCallback = void Function(double);
