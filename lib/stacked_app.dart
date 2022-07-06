import 'package:flutter/material.dart';
import 'package:stacked_list/stacked_list.dart';

class StackedPage extends StatelessWidget {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");

  StackedPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: StackedList(
        itemCount: items.length,
        itemExtent: 5,
        itemBuilder: (context, index) => Center(
          child: Text(
            items[index],
            style: const TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
