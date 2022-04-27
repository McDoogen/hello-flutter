import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp2());

class MyApp2 extends StatefulWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  State<MyApp2> createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  late Future<Thing> futureThing;

  @override
  void initState() {
    super.initState();
    futureThing = fetchThing();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fetchy Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(title: const Text('App Bar Title')),
            body: Center(
                child: FutureBuilder<Thing>(
                    future: futureThing,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!.text);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    }))));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

Future<Thing> fetchThing() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    return Thing.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load http data!');
  }
}

class Thing {
  final String text;

  const Thing({
    required this.text,
  });

  factory Thing.fromJson(Map<String, dynamic> json) {
    return Thing(
      text: json['title'],
    );
  }
}
