import 'package:flutter/material.dart';
import 'package:stacked_list/stacked_app.dart';
import 'package:stacked_list/stacked_flow.dart';

import 'draggable.dart';

void main() {
  runApp(StackedApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
        ),
        home: Scaffold(
            body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: StackedFlow(
            childHeight: 400,
          ),
        )));
  }
}

// class MyHomePage extends StatelessWidget {
//   MyHomePage({Key? key}) : super(key: key);

//   final _pages = List.generate(50, (index) => index * 2);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           clipBehavior: Clip.none,
//           child: StackedList(
//             pages: _pages,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class StackedList extends StatefulWidget {
//   const StackedList({
//     Key? key,
//     required List<int> pages,
//   })  : _pages = pages,
//         super(key: key);

//   final List<int> _pages;

//   @override
//   State<StackedList> createState() => _StackedListState();
// }

// class _StackedListState extends State<StackedList> {
//   late final ScrollController _pageController;
//   int _shownTiles = 5;
//   double _currentPage = 0.0;

//   @override
//   void initState() {
//     _pageController =
//         ScrollController(initialScrollOffset: 400.00 * widget._pages.length);
//     _pageController.addListener(_animateScroll);
//     super.initState();
//   }

//   _animateScroll() {
//     setState(() {
//       _currentPage = _pageController.offset /
//           _pageController.position.maxScrollExtent *
//           widget._pages.length;
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.removeListener(_animateScroll);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: widget._pages.length,
//       scrollDirection: Axis.vertical,
//       clipBehavior: Clip.none,
//       itemExtent: 400,
//       cacheExtent: 2800,
//       controller: _pageController,
//       itemBuilder: (ctx, i) {
//         // print(value);
//         // final scaleValue = (-0.1 * value + 1.0).clamp(0.0, 1.0);
//         // final opacityValue = (-0.3 * value + 1.0).clamp(0.0, 1.0);
//         // final translateValue = (-value * 460);
//         // return Transform(
//         //   alignment: Alignment.bottomCenter,
//         //   transform: Matrix4.identity()
//         //     ..setEntry(3, 2, 0.001)
//         //     ..translate(
//         //       0.0,
//         //       translateValue,
//         //     )
//         //     ..scale(scaleValue),
//         //   child: Opacity(
//         //       opacity: opacityValue, child: BeautyCard(text: i.toString())),
//         // );

//         return LayoutBuilder(builder: (context, constraints) {
//           print(constraints);
//           return BeautyCard(text: i.toString());
//         });
//       },
//     );
//   }
// }

// class BeautyCard extends StatelessWidget {
//   const BeautyCard({
//     Key? key,
//     required this.text,
//   }) : super(key: key);

//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color.fromRGBO(255, 255, 255, 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             spreadRadius: 5,
//           ),
//         ],
//         borderRadius: BorderRadius.circular(30),
//       ),
//       alignment: Alignment.center,
//       child: Text(text),
//     );
//   }
// }
