import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:to_do_list/ToDoCollection.dart';

class ToDoListPage extends StatefulWidget {
  String title;
  ToDoListPage({Key key, this.title}) : super(key: key);


  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  ToDoStorage ps = ToDoStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ToDo List")),
      body: Center(
        child: FutureBuilder(
          future: ps.readPosts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == 'na') {
              print("No ToDo Items found in the file");
              return Text("There are no ToDo Items");
            }
            // Decode the JSON
            var _tempToDoList = json.decode(snapshot.data.toString());
            _tempToDoList = new List.from(_tempToDoList.reversed);
            print("From file: " + snapshot.data.toString());

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 32, bottom: 32, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              // onTap: () {
                              // Navigator.push(
                              // context,
                              // MaterialPageRoute(
                              // builder: (_) => ToDoItemDetail(_tempToDoList[index])));
                              // },     // onTap logic is one of the item (#2) of final project
                              child: Text(
                                _tempToDoList[index]['title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                            Text(
                              _tempToDoList[index]['place'],
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: _tempToDoList == null ? 0 : _tempToDoList.length,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the new post screen using a named route.
          Navigator.pushNamed(context, '/newtodo');
        },
        tooltip: 'New ToDo Item',
        child: Icon(Icons.add),
      ),
    );
  }
}
