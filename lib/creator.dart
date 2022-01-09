import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'hike.dart';
import 'helper.dart';
import 'home.dart';

class Creator extends StatefulWidget {
  State <StatefulWidget> createState () {
    return CreatorState();
  }
}

class CreatorState extends State<Creator> {
  var point;
  List<LatLng> points = [];
  //bool ready = false;

  // Init start location
  Marker markerX = Marker(
      point: LatLng(52.348647, 4.886204),
      builder: (ctx) => Container(child: FlutterLogo()),
      width: 80,
      height: 80,
  );

  // Init end location
  Marker markerY = Marker(
      point: LatLng(52.348647, 4.886204),
      builder: (ctx) => Container(child: FlutterLogo()),
      width: 80,
      height: 80,
  );

  TextButton button = TextButton(
      onPressed: () {},
      child: Text("Create hike!"),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
  );

  void updateRoute(points) {
    setState(() {
      markerX = Marker(
        point: points.first, 
        builder: (ctx) => Container(child: FlutterLogo()),
        width: 80,
        height: 80,
      );
      markerY = Marker(
        point: points.last,
        builder: (ctx) => Container(child: FlutterLogo()),
        width: 80,
        height: 80,
      );
      double xLat = markerX.point.latitude;
      double xLon = markerX.point.longitude;
      double yLat = markerY.point.latitude;
      double yLon = markerY.point.longitude;
      double midLat = yLat + (xLat - yLat); // = 63 ~~~~~~ (xLat' - yLat') = -63
                                            // yLat + diff1/2 = 38
                                            // yLat' + diff2/2 = -38
      double midLon = yLon + (xLon - yLon);
      button = TextButton(
        onPressed: () { 
          Navigator.pop(
            context,
            Advert(
              description: "description", image: "images/skaubanen.jpg",
              points: [markerX.point, markerY.point], directions: "directions"
            )
          );
        },
        child: Text("Create hike!"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        )
      );

      this.points = [];
      //this.ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: 400,
              height: 60,
              child: Center(
                  child: Text(
                  "Hold your finger at the map to select start & end point",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      decoration: TextDecoration.none,
                      backgroundColor: Colors.black,
                      color: Colors.white)))),
          //Map(link: "https://www.openstreetmap.org/"),
          SizedBox(
              width: 400,
              height: 60,
              child: Center(child: button),
          ), 
          SizedBox(
                height: 400,
                child: FlutterMap(
                    options: MapOptions(
                        center: LatLng(52.348647, 4.886204),
                        zoom: 13.0,
                        onTap: (_, pos) {
                          print("$pos");
                          point = pos;
                          print(point);
                        },
                        onLongPress: (_, point) {
                          print("$point");
                          point = point;
                          print(point);
                          points.add(point);
                          print(points);
                          if (points.length == 2) {
                            updateRoute(points);
                          } else if (points.length > 2) {
                            points = [];
                          }

                        },
                        onPositionChanged: (x, _) {
                          //print("$x");
                        }
                    ),
                    layers: [
                      TileLayerOptions(
                          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayerOptions(
                          markers: [
                            markerX,
                            markerY,
                          ],
                      ),
                    ],
                ),
          ),
        ]
    );
  }
}
