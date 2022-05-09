// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pickmeup/widgets/common_elevated_button.dart';

PickerMapController _pickerMapController = PickerMapController();

class LocationPickerPage extends StatelessWidget {
  LocationPickerPage({required this.option});

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
          centerTitle: true,
          title: Text(
            "Choose $option",
          ),
          elevation: 0,
        ),
        controller: _pickerMapController,
        bottomWidgetPicker: Column(children: [
          Expanded(child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomElevatedButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                color: const Color.fromARGB(255, 229, 115, 115),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CustomElevatedButton(
                child: const Text(
                  "Pick",
                  style: TextStyle(color: Colors.white),
                ),
                color: const Color.fromARGB(255, 129, 199, 132),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
        ]));
  }
}
