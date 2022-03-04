import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Location extends State {
  List _cities = [];

// Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/lebanese_cities.json');
    final data = await json.decode(response);
    setState(() {
      _cities = data["Location_Name_En"] + " " + data["Location_Name_Ar"];
    });
  }

  List getCities() {
    return _cities;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
