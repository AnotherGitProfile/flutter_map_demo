import 'package:flutter/foundation.dart';
import 'package:flutter_map_demo/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:latlong/latlong.dart';

class LocationsRepository {
  Future<Database> _databaseFuture;

  LocationsRepository() {
    _databaseFuture = _connect();
  }

  Future<void> dispose() async {
    final Database db = await _databaseFuture;
    return db.close();
  }

  Future<Location> insertLocation(Location location) async {
    final Database db = await _databaseFuture;
    await db.insert(
      'locations',
      location.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return location;
  }

  Future deleteLocation(Location location) async {
    final Database db = await _databaseFuture;
    await db.delete(
      'locations',
      where: 'lat = ? and lng = ?',
      whereArgs: [location.pos.latitude, location.pos.longitude],
    );
  }

  Future<List<Location>> locations() async {
    final Database db = await _databaseFuture;
    final List<Map<String, dynamic>> maps = await db.rawQuery(""
        "SELECT locations.lat AS lat, locations.lng as lng, photos.path as path, photos.createdat as createdat "
        "FROM locations "
        "LEFT JOIN photos ON photos.lat = locations.lat AND photos.lng = locations.lng "
        "ORDER BY locations.lat ASC, locations.lng ASC, photos.createdat DESC");
    final Map<LatLng, Location> locations = new Map();

    maps.forEach((map) {
      final pos = LatLng(map['lat'], map['lng']);
      Location location = locations[pos];
      if (location == null) {
        location = Location(
          pos: pos,
          photos: [],
        );
        locations[pos] = location;
      }
      final path = map['path'];
      if (path != null) {
        location.photos.add(Photo.fromMap(map));
      }
    });

    return locations.values.toList();
  }

  Future<Location> locationByPos(LatLng pos) async {
    final Database db = await _databaseFuture;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      "SELECT locations.lat AS lat, locations.lng as lng, photos.path as path, photos.createdat as createdat "
      "FROM locations "
      "LEFT JOIN photos ON photos.lat = locations.lat AND photos.lng = locations.lng "
      "WHERE locations.lat = ? AND locations.lng = ? "
      "ORDER BY photos.createdat DESC",
      [pos.latitude, pos.longitude],
    );
    if (maps.isEmpty) {
      debugPrint("Cannot find location by pos");
      return null;
    }
    final Location location = Location(
      pos: pos,
      photos: [],
    );
    maps.forEach((map) {
      if (map['path'] != null) {
        location.photos.add(Photo.fromMap(map));
      }
    });
    return location;
  }

  Future<List<Photo>> photos(Location location) async {
    final Database db = await _databaseFuture;
    final List<Map<String, dynamic>> maps = await db.query(
      'locations',
      where: 'lat = ? and lng = ?',
      whereArgs: [location.pos.latitude, location.pos.longitude],
    );

    return List.generate(maps.length, (i) {
      return Photo.fromMap(maps[i]);
    });
  }

  Future<void> insertPhoto(Photo photo) async {
    final Database db = await _databaseFuture;
    await db.insert(
      'photos',
      photo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Database> _connect() async {
    debugPrint('Connecting to sqlite database...');
    return await openDatabase(
      join(await getDatabasesPath(), 'map_demo.db'),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE locations("
            "lng REAL,"
            "lat REAL,"
            "PRIMARY KEY(lng, lat)"
            ")");
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) {
        if (newVersion == 2) {
          db.execute("CREATE TABLE photos("
              "path TEXT PRIMARY KEY,"
              "lng REAL,"
              "lat REAL,"
              "createdat TEXT,"
              "FOREIGN KEY (lng, lat) REFERENCES locations(lng, lat)"
              ")");
        }
      },
      version: 2,
    );
  }
}
