import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:intl/intl.dart';
import 'package:my_app_new/database/database.dart';
import 'package:my_app_new/noteModel.dart';

class AddHabit extends StatefulWidget {
  final Note? note;
  final Function? updateNoteList;
  AddHabit({this.note, this.updateNoteList});

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _priority = 'Low';
  DateTime _date = DateTime.now();
  String btnText = 'Add habit';
  String titleText = 'Add habit';

  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  void initState() {
    super.initState();
    if (widget.note != null) {
      _title = widget.note!.title!;
      _date = widget.note!.date!;
      _priority = widget.note!.priority!;
      setState(() {
        btnText = 'Update Habit';
        titleText = 'Update Habit';
      });
    } else {
      setState(() {
        btnText = ' Add habit';
        titleText = 'Add habit';
      });
    }
    _dateController.text = _dateFormatter.format(_date);
  }

  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handledatePicker() async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteNote(widget.note!.id!);
    Navigator.pushNamed(context, 'homeScreen');
    widget.updateNoteList!();
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('$_title,$_date,$_priority');
      Note note = Note(title: _title, date: _date, priority: _priority);
      if (widget.note == null) {
        note.status = 0;
        DatabaseHelper.instance.insertNote(note);
        Navigator.pushNamed(context, 'homeScreen');
      } else {
        note.id = widget.note!.id;
        note.status = widget.note!.status;
        DatabaseHelper.instance.updateNote(note);
        Navigator.pushNamed(context, 'homeScreen');
      }
      widget.updateNoteList!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 94, 227, 230),
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(255, 94, 227, 230),
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'login');
                    },
                    child: Icon(
                      Icons.logout,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    titleText,
                    style: TextStyle(
                        color: Color.fromARGB(31, 141, 7, 7),
                        fontSize: 40,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            validator: (input) => input!.trim().isEmpty
                                ? 'Please enter a habit title'
                                : null,
                            onSaved: (input) => _title = input!,
                            initialValue: _title,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            readOnly: true,
                            controller: _dateController,
                            style: TextStyle(fontSize: 18),
                            onTap: _handledatePicker,
                            decoration: InputDecoration(
                                labelText: 'Date',
                                labelStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: DropdownButtonFormField(
                            isDense: true,
                            icon: Icon(Icons.arrow_drop_down_circle),
                            iconSize: 22,
                            iconEnabledColor: Color.fromARGB(255, 22, 1, 2),
                            items: _priorities.map((String priority) {
                              return DropdownMenuItem(
                                value: priority,
                                child: Text(
                                  priority,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 7, 197, 121),
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }).toList(),
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              labelText: 'Priority',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (input) => _priority == null
                                ? "Please select a priority level"
                                : null,
                            onChanged: (value) {
                              setState(() {
                                _priority = value.toString();
                              });
                            },
                            value: _priority,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 30),
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 18, 199, 85),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                            child: Text(
                              btnText,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 241, 239, 239)),
                            ),
                            onPressed: _submit,
                          ),
                        ),
                        widget.note != null
                            ? Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: ElevatedButton(
                                  child: Text(
                                    'Delete habit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  onPressed: _delete,
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
