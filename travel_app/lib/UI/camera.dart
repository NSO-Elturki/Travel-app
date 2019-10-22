import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:travel_app/UI/takenpicture.dart';
import 'package:travel_app/UI/map.dart';
import 'package:travel_app/UI/writeNote.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class Camera extends StatefulWidget {
  final CameraDescription camera;

  const Camera({Key key, this.camera}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CameraState();
  }
}

class CameraState extends State<Camera> {
  //_controller variable will store camera controller
  CameraController _controller;
  // future variable will return what is store on the cameracontroller
  Future<void> _initializeControllerFuture;
  VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    // here I get the view of camera when the camera is open
    _controller = CameraController(
      //here told system which camera to use which is pass from the main class as parameter which will be
      //back camera
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  takePictureAndStore() async {
    try {
      await _initializeControllerFuture;
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      await _controller.takePicture(path);

      print(path.toString());

      Navigator.push(context, MaterialPageRoute(builder: (context) => TakenPicture(path.toString())));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  recordVideoAndStore() async {
    try {
      File video = await ImagePicker.pickVideo(source: ImageSource.camera);
      if (video != null) {
        this.saveVideo(video);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void writeNewNote(BuildContext context) {
    try {
       Navigator.push(context, MaterialPageRoute(builder: (context) => WriteNote()));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> saveVideo(File video) async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String latp = position.latitude.toString();
    String longp = position.longitude.toString();
    final String videoName = Random().nextInt(10000).toString();

    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Videos/$videoName');
    final StorageUploadTask storageUploadTask = storageReference.putFile(video);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;

    //to get image from storge and upload to realtime
    final ref = FirebaseStorage.instance.ref().child('Videos/$videoName');
    var videoURL = await ref.getDownloadURL().then((value) {
      final databaseReference =
          FirebaseDatabase.instance.reference().child('Videos').push();
      databaseReference.set({
        'lat': position.latitude,
        'lang': position.longitude,
        'location': position.toString(),
        'video': value
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Camera'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppMap(''),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget> [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new FloatingActionButton(
                    heroTag: "cameraBtn",
                    onPressed: takePictureAndStore,
                    child: Icon(Icons.camera_alt),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new FloatingActionButton(
                    heroTag: "videoBtn",
                    onPressed: recordVideoAndStore,
                    child: Icon(Icons.videocam),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new FloatingActionButton(
                    heroTag: "noteBtn",
                    onPressed: () => writeNewNote(context),
                    child: Icon(Icons.note_add),
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}