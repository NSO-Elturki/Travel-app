import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:travel_app/UI/readimg.dart';

class TakenPicture extends StatelessWidget {
  final String imagePath;

  TakenPicture(this.imagePath);

  Future<void> saveImage() async {
    final String imageName = Random().nextInt(10000).toString();
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String latp = position.latitude.toString();
    String longp = position.longitude.toString();

    var convertImagToFile = new File(imagePath);
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Images/$imageName');
    final StorageUploadTask storageUploadTask =
        storageReference.putFile(convertImagToFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;

    //to get image from storage and upload to realtime
    final ref = FirebaseStorage.instance.ref().child('Images/$imageName');
    var imageURL = await ref.getDownloadURL().then((value) {
      final databaseReference =
          FirebaseDatabase.instance.reference().child('Images').push();
      databaseReference.set({
        'lat': position.latitude,
        'lang': position.longitude,
        'location': position.toString(),
        'image': value
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Taken image'),
          backgroundColor: Colors.blue,
        ),
        body: Image.file(File(imagePath)),
        floatingActionButton: new FloatingActionButton(
          onPressed: saveImage,
          child: new Text('Save'),
        ));
  }
}
