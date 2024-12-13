import 'package:location/location.dart';

class LocationFinder {
  LocationFinder._();
  static Future<String> getLocation() async {
    final Location location = new Location();
    LocationData position = await location.getLocation();
    return "${position.latitude},${position.longitude}";
  }
}
