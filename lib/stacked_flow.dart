import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StackedFlow extends StatefulWidget {
  StackedFlow({Key? key, required this.childHeight}) : super(key: key);

  int itemExtent = 5;
  final double childHeight;

  @override
  State<StackedFlow> createState() => _StackedFlowState();
}

class _StackedFlowState extends State<StackedFlow>
    with SingleTickerProviderStateMixin {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");
  int currentIndex = 0;
  bool open = true;
  late AnimationController _controller;

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.deepPurpleAccent,
    Colors.tealAccent
  ];

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        lowerBound: -1,
        value: 0,
        duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorTween = ColorTween(
        begin: Colors.white, end: const Color.fromARGB(255, 7, 219, 25));
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.topCenter,
          child: Flow(
            clipBehavior: Clip.none,
            delegate: StackedDelegate(
                constraints.maxHeight + widget.childHeight, _controller),
            children: <Widget>[
              for (var i = currentIndex;
                  i < currentIndex + widget.itemExtent;
                  i++)
                Container(
                    height: widget.childHeight,
                    decoration: BoxDecoration(
                      color: colorTween.transform(
                          1 - (1 - (0.15 * widget.itemExtent - i - 1))),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, -5),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(items[i]),
                    ))
            ],
          ),
        );
      },
    );
  }
}

class StackedDelegate extends FlowDelegate {
  StackedDelegate(this.dragHeight, this.animation) : super(repaint: animation);

  final double dragHeight;
  final Animation<double> animation;

  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = 0; i < context.childCount; i++) {
      var childSize = context.getChildSize(i) ?? Size.zero;
      var offset = i == 4 ? 0 : getChildOffset(i);
      context.paintChild(i,
          transform: Matrix4.identity()
            ..translate(0.0, (dragHeight / 2) - childSize.height - offset)
            ..scale(1.0, 1));
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return true;
  }

  double getChildOffset(int i) {
    return 100 - (((10 + (10 * i)) / 2) * i);
  }
}
