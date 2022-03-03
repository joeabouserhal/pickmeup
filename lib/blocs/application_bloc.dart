import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../services/geolocator_service.dart';

class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();

  late Position currentLocation;

  ApplicationBloc() {
    setCurrentPosition();
  }

  Future<void> setCurrentPosition() async {
    currentLocation = (await geoLocatorService.getCurrentPosition())!;
    notifyListeners();
  }
}
