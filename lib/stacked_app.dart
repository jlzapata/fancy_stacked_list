import 'package:flutter/material.dart';

class StackedApp extends StatelessWidget {
  const StackedApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(body: MyHomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 400,
        child: StackedList(
          itemCount: items.length,
          itemExtent: 5,
          itemBuilder: (context, index) => Center(
            child: Text(
              items[index],
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class StackedList extends StatefulWidget {
  StackedList(
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

class _StackedListState extends State<StackedList> {
  int currentIndex = 0;
  bool open = true;
  final _colorTween =
      ColorTween(begin: Colors.white, end: Color.fromARGB(255, 7, 219, 25));

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    for (int index = 0; index < currentIndex + widget.itemExtent; index++) {
      int factor = open ? widget.itemExtent - index - 1 : -1;

      print('''
        currentIndex: $currentIndex
        index: $index
        factor: $factor
        
''');

      children.add(
        _StackedListItem(
          factor: factor,
          colorTween: _colorTween,
          widget: widget,
          index: index,
          swipeEnabled: index == widget.itemExtent - 1,
        ),
      );
    }
    return Stack(clipBehavior: Clip.none, children: children);
  }
}

class _StackedListItem extends StatefulWidget {
  const _StackedListItem(
      {Key? key,
      required this.factor,
      required ColorTween colorTween,
      required this.widget,
      required this.index,
      this.swipeEnabled = false})
      : _colorTween = colorTween,
        super(key: key);

  final int factor;
  final ColorTween _colorTween;
  final StackedList widget;
  final int index;
  final bool swipeEnabled;

  @override
  State<_StackedListItem> createState() => _StackedListItemState();
}

class _StackedListItemState extends State<_StackedListItem> {
  double _verticalOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.bottomCenter,
      transform: Matrix4.identity()
        ..translate(
            0.0,
            (widget.factor * -70 + (widget.factor * widget.factor * 2)) +
                _verticalOffset)
        ..scale(1 - (0.085 * widget.factor)),
      child: GestureDetector(
        onVerticalDragUpdate: widget.swipeEnabled
            ? (details) => _handleDragUpdate(details)
            : null,
        child: Container(
            decoration: BoxDecoration(
              color: widget._colorTween
                  .transform(1 - (1 - (0.15 * widget.factor))),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, -5),
                  blurRadius: 5,
                ),
              ],
            ),
            child: widget.widget.itemBuilder(context, widget.index)),
      ),
    );
  }

  _handleDragUpdate(DragUpdateDetails details) {
    print("${widget.index}: ${details.delta.dy}");
    setState(() {
      _verticalOffset += details.delta.dy;
    });
  }
}
