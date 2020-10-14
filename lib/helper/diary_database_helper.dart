import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DiaryDatabaseHelper {
  static final _databaseName = "Diary";
  static final _databaseVersion = 1;

  static final table = 'workout_table';

  static final columnId = '_id';
  static final columnSpraysMorning = 'spraysMorning';
  static final columnSpraysNoon = 'spraysNoon';
  static final columnSpraysEvening = 'spraysEvening';
  static final columnSpraysNight = 'spraysNight';
  static final columnRating = 'rating';
  static final columnOthers = 'others';
  static final columnSymptoms = 'symptoms';
  static final columnDay = 'day';
  static final columnMonth = 'month';
  static final columnYear = 'year';
  static final columnNotes = 'notes';
  static final columnSpraysDemand = 'spraysDemand';

  DiaryDatabaseHelper._privateConstructor();

  static final DiaryDatabaseHelper instance =
      DiaryDatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  ///opens and possibly creates the database
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  ///creates the table
  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE $table($columnId INTEGER PRIMARY KEY, $columnSpraysMorning STRING,  $columnSpraysNoon STRING,  $columnSpraysEvening STRING,  $columnSpraysNight STRING, $columnRating INTEGER, $columnOthers STRING, $columnSymptoms STRING, $columnDay INTEGER, $columnMonth INTEGER, $columnYear INTEGER, $columnNotes STRING, $columnSpraysDemand STRING)''');
  }

  ///adds a new column
  ///returns the value of the added column
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  ///returns the column which fits to the id as a map
  Future<List> getList(int id) async {
    Database db = await instance.database;
    final Future<List<Map<String, dynamic>>> map =
        db.query(table, where: '$columnId = ?', whereArgs: [id]);
    var m = await map;
    return m;
  }

  ///returns all columns
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  ///returns the amount of columns
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  ///updates the column with a given column
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  ///deletes the column with the given id
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  ///deletes the whole database
  Future<int> deleteAll() async {
    Database db = await instance.database;
    return db.delete(table);
  }

  Future<Directory> get _downloadsDirectory async {
    Future<Directory> downloadsDirectory = DownloadsPathProvider.downloadsDirectory;
    return downloadsDirectory;
  }

  Future<File> get _localFile async {
    Directory path = await _downloadsDirectory;
    String s = path.path + '/asthma_diary_database.txt';
    print(s);
    return File(s);
  }

  Future<File> writeDatabaseAsTxt() async {
    final file = await _localFile;
    List<Map<String, dynamic>> m  = await queryAllRows();
    String s = "";
    for (int i = 0; i < m.length; i++){
      print(m[i].toString());
        s += json.encode(m[i]) + "\n";
    }
    print("s: $s");
    return file.writeAsString(s);
  }

  Future<int> readTxtInDatabase(File s) async {
    try {
      String contents = await s.readAsString();

      List<String> list = contents.split("\n");
      list.removeAt(list.length-1);

      for(int i = 0; i < list.length; i++){
        Map row = json.decode(list[i]);
        insert(row);
      }
      return 0;
    } catch (e) {
      print("Fehler beim lesen der txt: " + e);
      return 1;
    }
  }

}
