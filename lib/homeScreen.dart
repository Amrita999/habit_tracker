import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:my_app_new/addhabit.dart';
import 'package:my_app_new/database/database.dart';
import 'package:my_app_new/noteModel.dart';
import 'package:sqflite/sqflite.dart';

class MyHomeScreen extends StatefulWidget {
  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  late Future<List<Note>>? _noteList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, YYYY');
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  void initState() {
    super.initState();
    _updateNoteList();
  }

  _updateNoteList() {
    _noteList = DatabaseHelper.instance.getNoteList();
  }

  Widget _buildNote(Note note) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          ListTile(
            title: Text(
              note.title!,
              style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 202, 7, 7),
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            subtitle: Text(
              '${_dateFormatter.format(note.date!)} - ${note.priority}',
              style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 6, 163, 11),
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            trailing: Checkbox(
              onChanged: (value) {
                note.status = value! ? 1 : 0;
                DatabaseHelper.instance.updateNote(note);
                _updateNoteList();
                Navigator.pushNamed(context, 'homeScreen');
              },
              activeColor: Theme.of(context).primaryColor,
              value: note.status == 1 ? true : false,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (_) => AddHabit(
                            updateNoteList: _updateNoteList(),
                            note: note,
                          )));
            },
          ),
          Divider(
            height: 7,
            color: Colors.black,
            thickness: 7,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 173, 244, 245),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddHabit(
                          updateNoteList: _updateNoteList,
                        )));
          },
          child: Icon(Icons.add),
        ),
        body: FutureBuilder(
            future: _noteList,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final int completedNoteCount = snapshot.data!
                  .where((Note note) => note.status == 1)
                  .toList()
                  .length;
              return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 80.0),
                  itemCount: int.parse(snapshot.data!.length.toString()) + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  "MY HABITS",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: Text(
                                  "$completedNoteCount of ${snapshot.data.length}",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 31, 5, 176),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ));
                    }
                    return _buildNote(snapshot.data![index - 1]);
                  });
            }));
  }
}
