// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:note_keeper_app/screens/note_detail.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';
import '../utils/database_helpers.dart';

class NoteList extends StatefulWidget {
  NoteList({Key? key}) : super(key: key);

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DataBaseHelpers dataBaseHelpers = DataBaseHelpers();
  List<Note>? noteList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if(noteList == null){
      noteList = <Note>[];
      updateListView();
    }
    TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getColorPriority(noteList![position].priority),
                child: getIconPriority(noteList![position].priority),
              ),
              title: Text(
                noteList![position].title,
                style: titleStyle,
              ),
              subtitle: Text(
                noteList![position].date,
              ),
              trailing: GestureDetector(
                child: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                onTap: (){
                  _delete(context, noteList![position]);
                },
              ),
              onTap: () {
                navigateToDetail(noteList![position],"Edit Note");
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note("", "", 2,''), "Add Note");
        },
        tooltip: "add note",
        child: const Icon(Icons.add),
      ),
    );
  }

  void navigateToDetail(Note note, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetail( appBarTitle: title, note: note,),
      ),
    );
    updateListView();
  }

  Color getColorPriority(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  Icon getIconPriority(int priority) {
    switch (priority) {
      case 1:
        return const Icon(Icons.play_arrow);
      case 2:
        return const Icon(Icons.keyboard_arrow_right);
      default:
        return const Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await dataBaseHelpers.deleteNote(note.id!);
    if (result != 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Note Deleted Successfully."),
        duration: Duration(seconds: 3),
      ),);
      updateListView();
    }
  }
  void updateListView(){
    final Future<Database> dbFuture = dataBaseHelpers.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = dataBaseHelpers.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }
}
