import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
