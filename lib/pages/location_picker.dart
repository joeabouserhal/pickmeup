import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class LocationPicker extends StatelessWidget {
  PickerMapController pickerMapController = PickerMapController(
    initMapWithUserPosition: true,
    initPosition: GeoPoint(latitude: 33.8547, longitude: 35.8623),
  );

  LocationPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPickerLocation(
      controller: pickerMapController,
      pickerConfig: const CustomPickerLocationConfig(initZoom: 8.5),
    );
  }
}
