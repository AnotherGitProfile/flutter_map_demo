import 'package:flutter/material.dart';

import 'package:flutter_map_demo/screens/home_screen.dart';
import 'package:flutter_map_demo/models.dart' show Secret;

class MapDemoApp extends StatelessWidget {
  final Secret secret;

  MapDemoApp({
    Key key,
    this.secret,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        title: 'Flutter Demo Home Page',
        secret: secret,
      ),
    );
  }
}
