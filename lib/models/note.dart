import 'package:flutter/cupertino.dart';

class Note {
  int? id ;
  late String title;
  late String description;
  late String date;
  late int priority;

  Note( this.title, this.date, this.priority, this.description);
  Note.withID(this.id, this.title, this.date, this.priority,
      this.description);

  get getId => id;

  get getTitle => title;

  set setTitle(String title) => this.title = title;

  get getDescription => description;

  set setDescription(String description) => this.description = description;

  get getDate => date;

  set setDate(date) => this.date = date;

  get getPriority => priority;

  set setPriority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      priority = newPriority;
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['description'] = description;
    map['date'] = date;
    map['priority'] = priority;
    return map;
  }

  Note.fromMap({required Map<String, dynamic> map}){
    id = map['id'] ;
    title = map['title'];
    description = map['description'];
    date = map['date'];
    priority = map['priority'];
  }
}
