import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:flutter_map_demo/screens/take_photo_screen.dart';

class CapturePhotoButton extends StatelessWidget {
  final Function onSuccess;

  const CapturePhotoButton({Key key, @required this.onSuccess})
      : super(key: key);

  void _navigateToTakePhotoScreen(
      BuildContext context, CameraDescription camera) async {
    final pathToPhoto = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TakePhotoScreen(
                camera: camera,
              )),
    );
    onSuccess(pathToPhoto);
  }

  Future<void> _requestPhotoFromCamera(BuildContext context) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _navigateToTakePhotoScreen(context, firstCamera);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text('+'),
      onPressed: () async {
        await _requestPhotoFromCamera(context);
      },
    );
  }
}
