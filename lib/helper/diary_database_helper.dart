import 'dart:async';
import 'dart:io';

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
        '''CREATE TABLE $table($columnId INTEGER PRIMARY KEY, $columnSpraysMorning STRING,  $columnSpraysNoon STRING,  $columnSpraysEvening STRING,  $columnSpraysNight STRING, $columnRating INTEGER, $columnOthers STRING, $columnSymptoms STRING, $columnDay INTEGER, $columnMonth INTEGER, $columnYear INTEGER, $columnNotes STRING)''');
  }

  ///adds a new column
  ///returns the value of the added column
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  ///adds a list of values
  Future<int> insertList() async {
    Database db = await instance.database;
    List<Map> list = initEntries();
    for (int i = 0; i < list.length; i++) {
      print('Insert $i');
      Map<String, dynamic> row = list[i];
      await db.insert(table, row);
    }
    return Future.value(0);
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
    db.delete(table);
  }

  List<Map<String, dynamic>> initEntries() {
    List<Map<String, dynamic>> list = [
      {
        DiaryDatabaseHelper.columnId: 11102020,
        DiaryDatabaseHelper.columnDay: 11,
        DiaryDatabaseHelper.columnMonth: 10,
        DiaryDatabaseHelper.columnYear: 2020,
        DiaryDatabaseHelper.columnSymptoms: "",
        DiaryDatabaseHelper.columnOthers: "",
        DiaryDatabaseHelper.columnRating: 0,
        DiaryDatabaseHelper.columnSpraysNight: "",
        DiaryDatabaseHelper.columnSpraysMorning: "1,Flutiform,0,1",
        DiaryDatabaseHelper.columnSpraysEvening: "2,Flutiform,0,0",
        DiaryDatabaseHelper.columnSpraysNoon: "",
        DiaryDatabaseHelper.columnNotes: ""
      },
      {
        DiaryDatabaseHelper.columnId: 12102020,
        DiaryDatabaseHelper.columnDay: 12,
        DiaryDatabaseHelper.columnMonth: 10,
        DiaryDatabaseHelper.columnYear: 2020,
        DiaryDatabaseHelper.columnSymptoms: "",
        DiaryDatabaseHelper.columnOthers: "",
        DiaryDatabaseHelper.columnRating: 0,
        DiaryDatabaseHelper.columnSpraysNight: "",
        DiaryDatabaseHelper.columnSpraysMorning: "3,Flutiform,0,0",
        DiaryDatabaseHelper.columnSpraysEvening: "4,Flutiform,0,1",
        DiaryDatabaseHelper.columnSpraysNoon: "",
        DiaryDatabaseHelper.columnNotes: ""
      }
    ];
    return list;
  }
}
