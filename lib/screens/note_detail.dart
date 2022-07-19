// ignore_for_file: no_logic_in_create_state, must_be_immutable, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:note_keeper_app/screens/note_detail.dart';
import 'package:note_keeper_app/screens/note_list.dart';
import 'package:note_keeper_app/utils/database_helpers.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  NoteDetail({super.key, required this.note, required this.appBarTitle});

  @override
  State<NoteDetail> createState() => _NoteDetailState(this.note, appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  String appBarTitle;
  Note note;
  static var priorities = ['High', 'Low'];
  DataBaseHelpers helpers = DataBaseHelpers();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _NoteDetailState(this.note, this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    TextStyle? txtStyle = Theme.of(context).textTheme.titleMedium;
    titleController.text = note.title;
    descriptionController.text = note.description;
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
        child: ListView(
          children: [
            ListTile(
              title: DropdownButton<String>(
                  items: priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style: txtStyle,
                  value: getPriorityAsString(note.priority),
                  onChanged: (val) {
                    setState(() {
                      updatePriorityAsInt(val!);
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: txtStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (v) {
                  note.title = titleController.text;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: txtStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (v) {
                  note.description = descriptionController.text;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: const Text(
                        "Save",
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          _save();
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: const Text(
                        "Delete",
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          _delete();
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority = priorities[1];
    switch (value) {
      case 1:
        priority = priorities[0];
        break;
      case 2:
        priority = priorities[1];
        break;
    }
    return priority;
  }

  void _save() async {
     
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await helpers.updateNote(note);
    } else {
      result = await helpers.insertNote(note);
    }

    if (result != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Note Saved Successfully"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Problem Saving Note"),
        ),
      );
    }
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoteList(),
        ));
  }

  void _delete() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoteList(),
        ));
    if (note.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No note deleted."),
        ),
      );
      return;
    }
    int result = await helpers.deleteNote(note.id!);
    if (result != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Note Deleted Successfully"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error Occured"),
        ),
      );
    }
  }
}
