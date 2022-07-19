// ignore_for_file: unused_local_variable

import 'package:note_keeper_app/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class DataBaseHelpers {
  static DataBaseHelpers? _dataBaseHelpers;
  static Database? _database;
  String noteTable = "note_table";
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';
  String colPriority = 'priority';

  DataBaseHelpers._createInstance();

  factory DataBaseHelpers() {
    _dataBaseHelpers ??= DataBaseHelpers._createInstance();
    return _dataBaseHelpers!;
  }
  Future<Database> get database async{
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase()async{
    Directory directory =await getApplicationDocumentsDirectory();
    String path = '${directory.path}notes.db';
    var notesDatabase = await openDatabase(path, version: 3, onCreate: _createDB);
    return notesDatabase;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colDate TEXT, $colPriority INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async{
    Database db = await database;
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }
  Future<int> insertNote(Note note) async {
    Database db = await database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }
  Future<int> updateNote(Note note) async {
    Database db = await database;
    var result =  await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }
  Future<int> deleteNote(int id) async {
    Database db = await database;
    int result = await db.rawDelete("DELETE FROM $noteTable WHERE $colId = $id");
    return result;
  }
  Future<int> getCount(Note note) async {
    Database db = await database;
    List<Map<String, dynamic>> x = await db.rawQuery("SELECT COUNT (*) from $noteTable");
    var result = Sqflite.firstIntValue(x);
    return result!; 
  }
  Future<List<Note>> getNoteList()async{
    List<Map<String, dynamic>> noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = <Note>[];
    for(int i =0; i< count; i++){
      noteList.add(Note.fromMap(map: noteMapList[i]));
      
    }
    return noteList;
  }
}
