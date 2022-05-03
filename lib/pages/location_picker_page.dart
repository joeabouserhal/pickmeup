// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

PickerMapController _pickerMapController = PickerMapController();

class LocationPickerScreen extends StatelessWidget {
  LocationPickerScreen({Key? key, required this.option}) : super(key: key);

  late String option;

  @override
  Widget build(BuildContext context) {
    return CustomPickerLocation(
        pickerConfig: const CustomPickerLocationConfig(
          initZoom: 15,
          stepZoom: 1.0,
        ),
        appBarPicker: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light),
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "'Choose $option'",
          ),
          elevation: 0,
        ),
        controller: _pickerMapController);
  }
}
