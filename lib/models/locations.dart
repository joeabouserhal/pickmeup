import 'dart:convert';
import 'package:flutter/services.dart';

class Location {
  int latitude;

  int longitude;

  String name;

  Location(
      {required this.latitude, required this.longitude, required this.name});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'],
      longitude: json['longitude'],
      name: json['name'],
    );
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/my_text.txt');
  }

  late String NESTED_JSON;
  setState() {
    NESTED_JSON = loadAsset() as String;
  }

  Future<List<Location>> getLocations() async {
    return await Future.delayed(const Duration(seconds: 2), () {
      List<dynamic> data = json.decode(NESTED_JSON);
      List<Location> locations =
          data.map((data) => Location.fromJson(data)).toList();
      return locations;
    });
  }
}
