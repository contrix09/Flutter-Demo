import 'package:location/location.dart' as LocationManager;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  final _locationManager = LocationManager.Location();

  LocationService() {
    _locationManager.changeSettings(
        accuracy: LocationManager.LocationAccuracy.HIGH);
  }

  Future<LatLng> getCurrentLocation() async {
    var locationResult = await _locationManager.getLocation();

    return LatLng(locationResult.latitude, locationResult.longitude);
  }
}