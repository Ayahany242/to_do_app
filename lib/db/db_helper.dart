import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

//to create dataBase
  static Future<void> initDb() async {
    if (_db != null) {
      debugPrint('not null dataBase');
      return;
    } else {
      try {
        // b3rf l path + name.db
        String path = '${await getDatabasesPath()}task.db';
        debugPrint(' in database path');
        _db = await openDatabase(path, version: _version,
            onCreate: (Database db, int version) async {
          debugPrint(' creating a new one');
          await db.execute('CREATE TABLE $_tableName ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title STRING, note TEXT, date STRING,  '
              'startTime STRING, endTime STRING, '
              'remind INTEGER, repeat STRING, '
              'color INTEGER, '
              'isCompleted INTEGER)');
        });
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(Task? task) async {
    print('insert function called');
    return await _db!.insert(_tableName, task!.toJson());
  }

  static Future<int> delete(Task? task) async {
    print('delete function called');
    return await _db!
        .delete(_tableName, where: 'id = ?', whereArgs: [task!.id]);
  }

  static Future<int> update(int id) async {
    print('Update function called');
    return await _db!.rawUpdate('''
UPDATE tasks
SET isCompleted = ?
WHERE id = ?
''', [1, id]);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('query function called');
    return await _db!.query(_tableName);
  }
}
