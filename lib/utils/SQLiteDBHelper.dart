
import 'dart:io';

import 'package:encyclopedia_world_stories/models/OfflineStory.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class SQLiteDBHelper {
  Database _db;

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "stories.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "stories.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

    } else {
      print("Opening existing database");
    }
// open the database
    _db = await openDatabase(path, readOnly: true);
  }

  /// get all story by table name
  Future<List<OfflineStory>> getAllStory({String tableName}) async {
    await init();
    if (_db == null) {
      throw "bd is not initiated, initiate using [init(db)] function";
    }
    List<Map> stories;

    await _db.transaction((txn) async {
      stories = await txn.query(
        tableName,
        columns: [
          "id",
          "title",
          "story"
        ],
      );
    });

    return stories.map((e) => OfflineStory.fromJson(e)).toList();
  }
}