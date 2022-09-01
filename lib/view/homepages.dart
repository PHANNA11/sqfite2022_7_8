import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite7/connection/database_con.dart';
import 'package:sqflite7/view/add_date_page.dart';
import 'package:sqflite7/view/update_screen.dart';

import '../model/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseCon con;
  late Future<List<User>> list;
  Future<List<User>> getUserList() async {
    return await DatabaseCon().readDatabase();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder<List<User>>(
        future: list,
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Icon(
                Icons.info,
                color: Colors.red,
                size: 30,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading.....');
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var user = snapshot.data![index];
              return InkWell(
                onLongPress: () async {
                  await DatabaseCon().deleteDatabase(user.id).whenComplete(() {
                    setState(() {
                      list = getUserList();
                    });
                  });
                },
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditDataScreen(user: user),
                      ));
                },
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: FileImage(File(user.profileImage)),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.userDOB),
                    // trailing: const Icon(Icons.delete)
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const AddDataPage(title: 'Create new User');
            },
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
