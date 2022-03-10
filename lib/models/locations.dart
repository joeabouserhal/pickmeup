import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class Locations {
  var location;

  Locations({required this.location});
  static Locations? fromJson(Map<String, dynamic> json) {
    try {
      Locations(location: json['Location_Name_En']);
    } on Exception catch (e) {
      print(e);
    }
  }

// Fetch content from the json file
  static Future<Iterable<Locations?>> getCities() async {
    final String response =
        await rootBundle.loadString('assets/lebanese_cities.json');
    final data = await json.decode(response);
    return data.map<Locations>((json) => Locations.fromJson(json));
    //return data["Location_Name_En"] + " " + data["Location_Name_Ar"];
  }
}
