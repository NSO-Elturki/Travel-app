import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/UI/map.dart';
import 'dart:async';
import 'package:travel_app/UI/takenpicture.dart';
import 'package:travel_app/UI/camera.dart';
import 'package:travel_app/UI/readimg.dart';

Future<void> main() async {
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: Camera(
        // Pass the back camera of the device then it will be use to take the image
        camera: firstCamera,
      ),
//      home: AppMap(''),
    ),
  );
}

//void main() {
//
//  runApp(new MaterialApp(
//
//    home: new ReadImg(),
//  ));
//}
//class home extends StatelessWidget{
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Scaffold(
//      appBar: new AppBar(
//        title: new Text('test'),
//        backgroundColor: Colors.green,
//      ),
//
//    );
//  }
//
//}
