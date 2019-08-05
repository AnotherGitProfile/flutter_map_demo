import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

@immutable
class Location {
  final LatLng pos;
  final List<Photo> photos;

  const Location({this.pos, this.photos = const []});

  Map<String, dynamic> toMap() {
    return {
      'lng': pos.longitude,
      'lat': pos.latitude,
    };
  }
}

@immutable
class Photo {
  final String path;
  final LatLng pos;
  final DateTime createdAt;

  Photo({this.path, this.pos, this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'lat': pos.latitude,
      'lng': pos.longitude,
      'createdat': createdAt.toIso8601String(),
    };
  }

  static Photo fromMap(Map<String, dynamic> map) {
    return Photo(
      path: map['path'],
      pos: LatLng(
        map['lat'],
        map['lng'],
      ),
      createdAt: DateTime.parse(map['createdat']),
    );
  }

  @override
  int get hashCode => path.hashCode;

  @override
  bool operator ==(other) {
    return other is Photo && other.path == path;
  }
}

class Secret {
  final String accessToken;

  Secret({this.accessToken = ""});

  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(accessToken: jsonMap["accessToken"]);
  }
}
