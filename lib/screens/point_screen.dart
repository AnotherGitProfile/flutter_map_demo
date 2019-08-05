import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong/latlong.dart';

import 'package:flutter_map_demo/models.dart';
import 'package:flutter_map_demo/widgets/capture_photo_button.dart';
import 'package:flutter_map_demo/app_model.dart';

class PointScreen extends StatelessWidget {
  final LatLng pos;

  PointScreen({
    Key key,
    @required this.pos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PhotoLocationsModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Pin details"),
          ),
          body: Center(
            child: FutureBuilder<Location>(
              future: model.locationByPos(pos),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final photos = snapshot.data.photos;
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: photos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          height: 300,
                          child: Image.file(
                            File(photos[index].path),
                            frameBuilder: (BuildContext context, Widget child,
                                int frame, bool wasSynchronousLoaded) {
                              if (frame == null) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return AnimatedOpacity(
                                child: child,
                                opacity: frame == null ? 0 : 1,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeOut,
                              );
                            },
                          ));
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          floatingActionButton: CapturePhotoButton(
            onSuccess: (path) async {
              await Provider.of<PhotoLocationsModel>(context, listen: false)
                  .savePhoto(pos, path);
            },
          ),
        );
      },
    );
  }
}
