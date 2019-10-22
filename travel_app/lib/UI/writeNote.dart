import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class WriteNote extends StatefulWidget {
  @override
  WriteNotePageState createState() => WriteNotePageState();
}

class WriteNotePageState extends State<WriteNote> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _titleFocus = FocusNode();
  final _contentFocus = FocusNode();

  var currentDateTime = new DateTime.now();

  Future<void> saveNote() async {
    var currentDate = new DateFormat("yyyy-MM-dd").format(currentDateTime);
    var currentTime = new DateFormat("jms").format(currentDateTime);

    FocusScope.of(context).requestFocus(FocusNode());

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    String latP = position.latitude.toString();
    String longP = position.longitude.toString();

    final databaseReference =
        FirebaseDatabase.instance.reference().child('Notes').push();

    databaseReference.set({
      'lat': position.latitude,
      'lang': position.longitude,
      'location': position.toString(),
      'title': _titleController.text,
      'content':  _contentController.text,
      'date_created': currentDate,
      'time_created': currentTime,
    });

    print(_titleController.text);
    print(_contentController.text);
    print(currentDateTime);
    print(currentDate);
    print(currentTime);
    print(latP);
    print(longP);
  }

  Future<bool> _onWillPop(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Discard message'),
        content: new Text('Are you sure you want to discard this note?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('New note'),
          backgroundColor: null,
        ),
        body: _body(context),
        floatingActionButton: new Builder(builder: (BuildContext context) {
          return new FloatingActionButton(
            onPressed: () {
              saveNote();

              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text('Note has been saved!'),
              ));

              Future.delayed(const Duration(milliseconds: 1500), () {
                setState(() {
                  Navigator.pop(context);
                });
              });
            },
            child: Icon(Icons.save)
          );
        }),
      )
    );
  }

  Widget _body(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 12),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Container(
                padding: EdgeInsets.all(5),
                child: TextField(
  //                onChanged: (str) => {updateNoteObject()},
                  autofocus: true,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  controller: _titleController,
                  focusNode: _titleFocus,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
//                      contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: 'Title'
                  ),
                  cursorColor: Colors.blue,
//                  backgroundCursorColor: Colors.blue
                ),
              ),
            ),
            Divider(
              color: Color(0xffd3d3d3)
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(5),
                child: EditableText(
  //                onChanged: (str) => {updateNoteObject()},
                  maxLines: 100, // line limit extendable later
                  textCapitalization: TextCapitalization.sentences,
                  controller: _contentController,
                  focusNode: _contentFocus,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                  backgroundCursorColor: Colors.red,
                  cursorColor: Colors.blue,
                )
              )
            )
          ],
        ),
        left: true, right: true, top: false, bottom: false,
      )
    );
  }
}