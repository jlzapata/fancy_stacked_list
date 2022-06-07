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
    return StackedList(
      itemCount: items.length,
      itemExtent: 5,
      itemBuilder: (context, index) => Center(
        child: Text(
          items[index],
          style: TextStyle(fontSize: 24, color: Colors.black),
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
          child: widget,
          index: index,
          swipeEnabled: index == widget.itemExtent - 1,
        ),
      );
    }
    return Container(
        color: Colors.red,
        child: Stack(clipBehavior: Clip.none, children: children));
  }
}

class _StackedListItem extends StatefulWidget {
  const _StackedListItem(
      {Key? key,
      required this.factor,
      required ColorTween colorTween,
      required this.child,
      required this.index,
      this.swipeEnabled = false})
      : _colorTween = colorTween,
        super(key: key);

  final int factor;
  final ColorTween _colorTween;
  final StackedList child;
  final int index;
  final bool swipeEnabled;

  @override
  State<_StackedListItem> createState() => _StackedListItemState();
}

class _StackedListItemState extends State<_StackedListItem> {
  late Alignment _alignment;
  late double verticalDrag;
  @override
  void initState() {
    verticalDrag = -widget.factor * 0.1;
    _alignment = Alignment(0, -widget.factor * 0.1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onVerticalDragUpdate: widget.swipeEnabled
          ? (details) {
              verticalDrag += details.delta.dy;
              print("Delta: ${details.delta.dy}");
              print("Vertical Drag: $verticalDrag");
              print("Distance: ${details.primaryDelta}");
              print("movement: ${verticalDrag / size.height}");
              print("Screen height: ${size.height}");
              print("real distance: ${verticalDrag / (size.height - 400) * 2}");
              setState(() {
                _alignment = Alignment(
                  0,
                  verticalDrag / (size.height - 400) * 2,
                );
              });
            }
          : null,
      child: Transform(
        alignment: Alignment.bottomCenter,
        transform: Matrix4.identity()..scale(1 - (0.085 * widget.factor), 1),
        child: Align(
          alignment: _alignment,
          child: Container(
              width: 300,
              height: 400,
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
              child: widget.child.itemBuilder(context, widget.index)),
        ),
      ),
    );
  }
}
