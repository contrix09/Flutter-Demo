import 'package:flutter_demo/constants/app_constants.dart';
import 'package:google_maps_webservice/places.dart';

class PlacesService {
  static const num _radius = 3000;
  final _googlePlacesService =
      GoogleMapsPlaces(apiKey: AppConstants.PlacesApiKey);

  Future<List<PlacesSearchResult>> getNearbyPlaces(
      double latitude, double longitude, String keyword) async {
    var searchResults = await _googlePlacesService.searchNearbyWithRadius(
        Location(latitude, longitude), _radius,
        keyword: keyword);

    if (searchResults.status == "OK") {
      return searchResults.results;
    }

    return List();
  }
}
