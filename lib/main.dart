import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import 'package:flutter_map_demo/app.dart';
import 'package:flutter_map_demo/repository/locations_repository.dart';
import 'package:flutter_map_demo/app_model.dart';
import 'package:flutter_map_demo/models.dart';

Future<void> main() async {
  final repository = LocationsRepository();
  final locations = await repository.locations();
  final secret = await rootBundle.loadStructuredData<Secret>("secrets.json",
      (jsonStr) async {
    final secret = Secret.fromJson(json.decode(jsonStr));
    return secret;
  });

  return runApp(ChangeNotifierProvider(
    builder: (context) => PhotoLocationsModel(repository, locations),
    child: MapDemoApp(
      secret: secret,
    ),
  ));
}
