import 'package:flutter/material.dart';

class Test2 extends StatelessWidget {
  const Test2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Test 2 App',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        home: const Center(
          child: Text("Welcome to Test 2!"),
        ));
  }
}
