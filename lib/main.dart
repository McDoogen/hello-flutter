import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(const MyApp());

class RecipeHandler {
  Future<Database> intializeDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'recipe_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE recipes(id INTEGER PRIMARY KEY, name TEXT, difficulty TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertRecipe(Recipe recipe) async {
    final db = await intializeDB();
    await db.insert(
      'recipes',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Recipe>> recipes() async {
    final db = await intializeDB();
    final List<Map<String, dynamic>> maps = await db.query('recipes');
    return List.generate(maps.length, (i) {
      return Recipe(
        id: maps[i]['id'],
        name: maps[i]['name'],
        difficulty: maps[i]['difficulty'],
      );
    });
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final db = await intializeDB();
    await db.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<void> deleteRecipe(int id) async {
    final db = await intializeDB();
    await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class SqlWidgetThing extends StatefulWidget {
  const SqlWidgetThing({Key? key}) : super(key: key);

  @override
  State<SqlWidgetThing> createState() => _SqlWidgetThingState();
}

class _SqlWidgetThingState extends State<SqlWidgetThing> {
  late RecipeHandler handler;

  @override
  void initState() {
    super.initState();
    handler = RecipeHandler();
    handler.intializeDB().whenComplete(() async {
      await this.recipes();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FutureThing extends StatefulWidget {
  const FutureThing({Key? key}) : super(key: key);

  @override
  State<FutureThing> createState() => _FutureThingState();
}

class _FutureThingState extends State<FutureThing> {
  late Future<Thing> futureThing;

  @override
  void initState() {
    super.initState();
    futureThing = fetchThing();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<Thing>(
            future: futureThing,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.text);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }));
  }
}

class WarningToast extends StatelessWidget {
  const WarningToast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
            child: const Text("Hello :)"),
            onPressed: () {
              final snacky = SnackBar(
                content: const Text('CLICKED!!! >:O'),
                action: SnackBarAction(label: '???', onPressed: () {}),
              );
              ScaffoldMessenger.of(context).showSnackBar(snacky);
            }));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
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
                FutureThing(),
                WarningToast(),
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

// SQL Things

class Recipe {
  final int id;
  final String name;
  final String difficulty;

  const Recipe({
    required this.id,
    required this.name,
    required this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'difficulty': difficulty,
    };
  }

  @override
  String toString() {
    return 'Recipe{id: $id, name: $name, difficulty: $difficulty}';
  }
}

void sqlExample() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'recipe_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE recipes(id INTEGER PRIMARY KEY, name TEXT, difficulty TEXT)',
      );
    },
    version: 1,
  );

  Future<void> insertRecipe(Recipe recipe) async {
    final db = await database;
    await db.insert(
      'recipes',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Recipe>> recipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipes');
    return List.generate(maps.length, (i) {
      return Recipe(
        id: maps[i]['id'],
        name: maps[i]['name'],
        difficulty: maps[i]['difficulty'],
      );
    });
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final db = await database;
    await db.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<void> deleteRecipe(int id) async {
    final db = await database;
    await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Test 1
  var cake1 = const Recipe(
    id: 0,
    name: 'lemon cake',
    difficulty: 'complex',
  );
  await insertRecipe(cake1);
  print(await recipes());

  // Test 2
  cake1 = const Recipe(
    id: 0,
    name: 'chocolate cake',
    difficulty: 'easy',
  );
  await updateRecipe(cake1);
  print(await recipes());

  // Test 3
  await deleteRecipe(cake1.id);
  print(await recipes());
}
