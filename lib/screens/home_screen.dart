import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

import 'package:flutter_map_demo/screens/point_screen.dart';
import 'package:flutter_map_demo/widgets/pin.dart';
import 'package:flutter_map_demo/app_model.dart';
import 'package:flutter_map_demo/models.dart' show Secret;

class HomePage extends StatelessWidget {
  static const double MARKER_WIDTH = 80.0;
  static const double MARKER_HEIGHT = 80.0;

  final Secret secret;
  final LayerOptions tileLayer;
  final String title;

  HomePage({
    @required this.title,
    @required this.secret,
    Key key,
  })  : tileLayer = new TileLayerOptions(
            urlTemplate: "https://api.tiles.mapbox.com/v4/"
                "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
            additionalOptions: {
              'accessToken': secret.accessToken,
              'id': 'mapbox.streets',
            }),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text(title),
        ),
        body: Consumer<PhotoLocationsModel>(
          builder: (context, model, child) {
            return FlutterMap(
              options: new MapOptions(
                center: LatLng(51.5, -0.09),
                zoom: 13.0,
                onTap: (LatLng pos) async {
                  await model.addLocation(pos);
                },
              ),
              layers: [
                tileLayer,
                new MarkerLayerOptions(
                  markers: List.from(
                    model.locations.map((location) {
                      return Marker(
                          width: MARKER_WIDTH,
                          height: MARKER_HEIGHT,
                          point: location.pos,
                          builder: (context) => Pin(
                                onMarkerTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PointScreen(
                                        pos: location.pos,
                                      ),
                                    ),
                                  );
                                },
                                onMarkerLongPress: () async {
                                  await model.deleteLocation(location);
                                },
                              ));
                    }),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
