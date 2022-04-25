import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                  title: const Text("Hello Tabs!"),
                  bottom: const TabBar(tabs: [
                    Tab(icon: Icon(Icons.safety_divider)),
                    Tab(icon: Icon(Icons.sailing)),
                    Tab(icon: Icon(Icons.table_chart_outlined)),
                  ])),
              body: const TabBarView(children: [
                Icon(Icons.star, color: Colors.red),
                Icon(Icons.star, color: Colors.orange),
                Icon(Icons.star, color: Colors.blue),
              ]))),
    );
  }
}
