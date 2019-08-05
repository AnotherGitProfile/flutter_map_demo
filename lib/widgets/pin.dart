import 'package:flutter/material.dart';

class Pin extends StatelessWidget {
  final Function onMarkerTap;
  final Function onMarkerLongPress;

  Pin({Key key, this.onMarkerTap, this.onMarkerLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new GestureDetector(
        child: new FlutterLogo(),
        onTap: () {
          onMarkerTap();
        },
        onLongPress: () {
          onMarkerLongPress();
        },
      ),
    );
  }
}
