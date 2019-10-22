import 'dart:core';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:travel_app/UI/mapsOptionButtons.dart';
import 'package:travel_app/UI/readimg.dart';
import 'package:travel_app/UI/recordedvideo.dart';
import 'package:travel_app/UI/writtenNote.dart';
import 'dart:ui' as ui;


class AppMap extends StatefulWidget {
  final String mapContent;
  AppMap(this.mapContent);

  @override
  State<StatefulWidget> createState() {
    return MapState();
  }
}

class MapState extends State<AppMap> {
  double lat = 51.4416;
  double lang = 5.4697;
  String description = ' ';
  var userLocation;
  List<Marker> _markers = [];
 // BitmapDescriptor markerIcon;
  var markerIcon;



  @override
  initState()  {
    super.initState();

    String viewTitle = widget.mapContent;

    if (viewTitle == 'images' || viewTitle == 'videos' || viewTitle == 'notes') {
      String capTitle = '${viewTitle[0].toUpperCase()}${viewTitle.substring(1)}';
      print(capTitle + ' after tap');

      setState(() {
        this.description = capTitle + ' Map';
      });
      this.loadMarkers(capTitle);
    }
    this.getMarker(viewTitle);

    this.getUserLocation();
  }

  void loadMarkers(String type) {
    setState(() {
      DatabaseReference _firebaseDatabase =
      FirebaseDatabase.instance.reference().child(type);
      _firebaseDatabase.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          addMarkers(values['lat'].toString(), values['lang'].toString(), type);
        });
      });
    });
  }

  void addMarkers(String l1, String l2, String type) {
    final String imageName = Random().nextInt(10000).toString();
    print(type + ' addMarkers');

    setState(() {
      _markers.add(Marker(
       icon: BitmapDescriptor.fromBytes(markerIcon),
        markerId: MarkerId('$imageName'),
        position: LatLng(double.parse(l1), double.parse(l2)),
        onTap: () {
          if (type == 'Images') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                  ReadImg(double.parse(l1), double.parse(l2)),
              ),
            );
          } else if(type == 'Videos') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                  RecordedVideo(double.parse(l1), double.parse(l2)),
              ),
            );
          } else if(type == 'Notes') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WrittenNote(double.parse(l1), double.parse(l2)),
              ),
            );
          }
        }
      ));
    });
  }

  getMarker(String viewType) async {
    if (viewType == 'images'){
      final Uint8List imageIcon = await resizeMarkerImg('images/photo-camera.png', 50);
      setState(() {
        this.markerIcon = imageIcon;
      });
    }
    if (viewType == 'videos'){
      final Uint8List videoIcon = await resizeMarkerImg('images/video-camera.png', 50);
      setState(() {
        this.markerIcon = videoIcon;
      });
    }
    if (viewType == 'notes'){
      final Uint8List noteIcon = await resizeMarkerImg('images/clipboard-with-pencil.png', 50);
      setState(() {
        this.markerIcon = noteIcon;
      });
    }
  }

   Future<Uint8List> resizeMarkerImg(String path, int width) async {
     ByteData data = await rootBundle.load(path);
     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
     ui.FrameInfo fi = await codec.getNextFrame();
     return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
   }





  Future<void> getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (this.mounted) {
      setState(() {
        lat = position.latitude;
        lang = position.longitude;
        print(lat);
        print(lang);
      });
    }
  }

  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(description),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: <Widget> [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, lang),
              zoom: 11.0,
            ),
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            markers: Set.from(_markers),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              color: Colors.white,
              child: MapsOptionListView(),
            ),
          ),
        ]
      ),
    );
  }
}