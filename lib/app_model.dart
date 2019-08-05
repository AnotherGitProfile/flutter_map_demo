import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';

import 'package:flutter_map_demo/models.dart';
import 'package:flutter_map_demo/repository/locations_repository.dart';

class PhotoLocationsModel extends ChangeNotifier {
  LocationsRepository repository;
  final Map<LatLng, Location> _locations = Map();

  PhotoLocationsModel(
      LocationsRepository repository, List<Location> locations) {
    this.repository = repository;
    this._locations.addAll(
          Map<LatLng, Location>.fromIterable(
            locations,
            key: (location) => location.pos,
            value: (location) => location,
          ),
        );
  }

  UnmodifiableListView<Location> get locations =>
      UnmodifiableListView<Location>(_locations.values);
  Future<Location> locationByPos(LatLng pos) => repository.locationByPos(pos);

  @override
  void dispose() {
    repository.dispose().then((dynamic _) {
      super.dispose();
    });
  }

  Future<void> addLocation(LatLng pos) async {
    final insertedLocation = await repository.insertLocation(
      Location(
        pos: pos,
      ),
    );
    _locations[pos] = insertedLocation;
    notifyListeners();
  }

  Future<void> deleteLocation(Location location) async {
    await repository.deleteLocation(location);
    _locations.remove(location.pos);
    notifyListeners();
  }

  Future<void> savePhoto(LatLng pos, String path) async {
    final photo = Photo(
      path: path,
      createdAt: DateTime.now(),
      pos: pos,
    );
    await repository.insertPhoto(photo);
    final location = _locations[pos];
    _locations[pos] = Location(
      pos: pos,
      photos: [...location.photos, photo],
    );
    notifyListeners();
  }
}
