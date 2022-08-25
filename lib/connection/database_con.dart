import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import '../model/user_model.dart';

class DatabaseCon {
  String tableName = 'User';
  String fId = 'id';
  String fName = 'name';
  Future<Database> intializeDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = await getDatabasesPath();
    return openDatabase(join(path, 'userdb.db'), onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $tableName($fId INTEGER PRIMIRY KEY,$fName TEXT)');
    }, version: 1);
  }

  Future<void> insertDatabase(User user) async {
    final db = await intializeDatabase();
    await db.insert(tableName, user.toJson());
    print('Create success');
  }

  Future<List<User>> readDatabase() async {
    final db = await intializeDatabase();
    List<Map<String, dynamic>> result = await db.query(tableName);
    return result.map((e) => User.fromJson(e)).toList();
  }

  Future<void> updateDatabase(User user) async {
    final db = await intializeDatabase();
    await db.update(tableName, user.toJson(),
        where: '$fId=?', whereArgs: [user.id]);
  }

  Future<void> deleteDatabase(int id) async {
    print('id=$id');
    final db = await intializeDatabase();
    await db.delete(tableName, where: '$fId = ?', whereArgs: [id]);
  }
}
