import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WrittenNote extends StatefulWidget {
  final double lat, long;
  WrittenNote(this.lat, this.long);

  @override
  State<StatefulWidget> createState() {
    return WrittenNoteState();
  }
}

class WrittenNoteState extends State<WrittenNote> {
  List<NoteValues> notes = new List<NoteValues>();

  @override
  initState() {
    super.initState();

    this.loadMarkers();
  }

  void loadMarkers() {
    double noteLat = widget.lat;
    double noteLong = widget.long;

    setState(() {
      DatabaseReference _firebaseDatabase =
      FirebaseDatabase.instance.reference().child('Notes');

      _firebaseDatabase.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          if (values['lat'].toString() == noteLat.toString() &&
              values['lang'].toString() == noteLong.toString()) {
            notes.add(new NoteValues(
              values['lat'].toString(),
              values['lang'].toString(),
              values['title'].toString(),
              values['content'].toString(),
              values['date_created'].toString(),
              values['time_created'].toString()
            ));

            print(values);
            print(notes);
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//          title: Text(notes),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 40.0, right: 24, bottom: 16, left: 24),
                child: AnimatedOpacity(
                  opacity: 1,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  child: new Text(
                    notes[0].title,
                    style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: new Text(
                    notes[0].dateCreated + " " + notes[0].timeCreated,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 24, left: 24),
                child: Divider(
                    color: Color(0xffd3d3d3)
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24, right: 24, bottom: 24, left: 24),
                child: new Text(
                  notes[0].content,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ],
      )
    );
  }
}


//class NotePage extends StatelessWidget {
//  final notes;
//
//  NotePage(this.notes);
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: AppBar(
//        title: Text(notes),
//      ),
//      body: Container(
//        child: Text(notes),
//      ),
//    );
//  }
//}

class NoteValues {
  String lat, lang, title, content, dateCreated, timeCreated;
//  NoteValues(this.title, this.content, this.dateCreated, this.timeCreated);
  NoteValues(String lat, String lang, String title, String content, String date, String time) {
    this.lat = lat;
    this.lang = lang;
    this.title = title;
    this.content = content;
    this.dateCreated = date;
    this.timeCreated = time;
  }
}

