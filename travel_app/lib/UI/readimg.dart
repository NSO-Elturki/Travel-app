import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ReadImg extends StatefulWidget {
  final double lat, long;
  ReadImg(this.lat, this.long);

  @override
  State<StatefulWidget> createState() {
    return ReadState();
  }
}

class ReadState extends State<ReadImg> {
  var images = [];

  @override
  initState() {
    super.initState();

    this.loadMarkers();
  }

  void loadMarkers() {
    double imageLat = widget.lat;
    double imageLong = widget.long;

    //here i get the images of the given lat and long
    setState(() {
      DatabaseReference _firebaseDatabase =
          FirebaseDatabase.instance.reference().child('Images');
      _firebaseDatabase.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          if (values['lat'].toString() == imageLat.toString() &&
              values['lang'].toString() == imageLong.toString()) {
            images.add(values['image'].toString());
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Gallery'),
        backgroundColor: Colors.blue,
      ),
      body: GridView.count(
        // Create a grid with 3 columns
        crossAxisCount: 3,
        // the grid since here will be the list of images size, and index i use to get position of the image in the list
        children: List.generate(images.length, (index) {
          return Center(
            child: Image.network(images[index]),
          );
        }),
      ),
    );
  }
}
