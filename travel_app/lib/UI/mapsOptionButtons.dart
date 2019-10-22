import 'package:flutter/material.dart';
import 'package:travel_app/UI/map.dart';

class MapsOptionListView extends StatefulWidget {
  @override
  MapsOptionListViewState createState() => MapsOptionListViewState();
}

class MapsOptionListViewState extends State<MapsOptionListView> {
  @override
  Widget build(BuildContext context) {

    final listTitles = ['Photos', 'Videos', 'Notes'];
    final listIcons = [Icons.photo_size_select_actual, Icons.video_library, Icons.note];
    final listOnTap = ['images', 'videos', 'notes'];

    return ConstrainedBox(
      constraints: new BoxConstraints(
        minHeight: 35.0,
        maxHeight: 160.0,
      ),
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listTitles.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return new GestureDetector(
            onTap: () {
              var name = listTitles[index];
              debugPrint('$name has been tapped');

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AppMap(listOnTap[index]),
                ),
              );
            },
            child: new Card(
              child: Container(
                height: 100,
                width: 160.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Icon(listIcons[index]),
                    new Text(listTitles[index])
                  ],
                ),
              )
            ),
          );
        },
      ),
    );
  }
}