import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sqflite7/connection/database_con.dart';
import 'package:sqflite7/model/user_model.dart';

void main() {
  runApp(const MyApp());
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  Future<List<User>>? listUser;
  late DatabaseCon db;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DatabaseCon();
    db.intializeDatabase().whenComplete(() {
      setState(() {
        listUser = db.readDatabase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                  hintText: 'Enter name', border: OutlineInputBorder()),
            ),
          ),
          Container(
            height: 600,
            width: double.infinity,
            child: FutureBuilder(
              future: listUser,
              builder: (context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var datadb = snapshot.data![index];
                    return Card(
                      child: ListTile(
                        title: Text(datadb.name),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await DatabaseCon().insertDatabase(
              User(id: Random().nextInt(100), name: controller.text));
        },
        tooltip: 'save',
        child: const Icon(Icons.done),
      ),
    );
  }
}
