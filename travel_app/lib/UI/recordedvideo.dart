import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_database/firebase_database.dart';

class RecordedVideo extends StatefulWidget {
  final double lat, long;
  RecordedVideo(this.lat, this.long);

  @override
  State<StatefulWidget> createState() {
    return RecordedVideoState();
  }
}

class RecordedVideoState extends State<RecordedVideo> {
  ChewieController chewieController;
  var videos = [];

  @override
  void initState() {
    super.initState();

    this.loadMarkers();
  }

  void showVideo(String videoToShow) {
    chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(videoToShow),
//      aspectRatio: 16 / 9,
      aspectRatio: 6 / 9,
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  void loadMarkers() {
    double videoLat = widget.lat;
    double videoLong = widget.long;
    setState(() {
      DatabaseReference _firebaseDatabase =
          FirebaseDatabase.instance.reference().child('Videos');
      _firebaseDatabase.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          if (values['lat'].toString() == videoLat.toString() &&
              values['lang'].toString() == videoLong.toString()) {
            this.showVideo(values['video']);
            videos.add(values['video'].toString());
          }
        });
        var g = videos.length.toString();
        print('$g Nagiiiiii');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('videos'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          Chewie(
            controller: chewieController,
          )
        ],
      ),
    );
  }
}
