import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ToDoCollection {
  static var _todoList = new List<ToDoItem>();
  static ToDoStorage todoStorage;

  ToDoCollection();

  static add(String t, String p, String d, bool r) {
    _todoList.add(ToDoItem(t, p, d, r));
    print("New ToDo Item added: " + t + "\t" + p + "\t" + d + "\t" + r.toString());
    print("Length of the _todoList is: " + _todoList.length.toString());

    print(_todoList.toString());
    print(jsonEncode(_todoList));
    todoStorage = ToDoStorage();
    todoStorage.writePosts(jsonEncode(_todoList));
  }
}

class ToDoItem {
  String title;
  String place;
  String datetime;
  bool isReminderNeeded;

  ToDoItem(String t, String p, String d, bool rem) {
    this.title = t;
    this.place = p;
    this.datetime = d;
    this.isReminderNeeded = rem;
  }

  Map toJson() => {
    'title': this.title,
    'place': this.place,
    'datetime': this.datetime,
    'reminder': this.isReminderNeeded,
  };

  @override
  String toString() {
    return '{ ${this.title}, ${this.place}, ${this.datetime}, ${this.isReminderNeeded} }';
  }
}

class ToDoStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/todos.txt');
  }

  Future<String> readPosts() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return na
      return 'na';
    }
  }

  Future<File> writePosts(String todos) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$todos');
  }
}
