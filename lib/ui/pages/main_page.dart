import 'dart:async';
import 'package:flutter_demo/service/location_service.dart';
import 'package:flutter_demo/service/places_service.dart';
import 'package:flutter_demo/ui/widgets/place_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final LocationService _locationService = LocationService();
  final PlacesService _placesService = PlacesService();
  bool _isRefreshing = false;
  String _searchKeyword = "";
  LatLng _currentLocation = LatLng(0, 0);
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _currentCameraPosition;
  List<Marker> _markers = List();
  List<PlacesSearchResult> _places = List<PlacesSearchResult>();
  GoogleMapController _mapController;
  PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _searchKeyword.isEmpty
              ? "Nearby Places"
              : "Nearby \"$_searchKeyword\"",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              _searchKeyword = await _showSearchInputDialog(context);
              if (_searchKeyword?.isEmpty == false) {
                await _searchNearbyPlaces();
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: _isRefreshing
            ? Container(
                margin: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.white)))
            : Icon(Icons.refresh),
        onPressed: () async {
          await _searchNearbyPlaces();
        },
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: Set.from(_markers),
            initialCameraPosition:
                CameraPosition(target: _currentLocation, zoom: 15),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 272,
              child: _buildPlacesCarousel(),
            ),
          )
        ],
      ),
    );
  }

  Future<List<Marker>> _getNearbyPlacesMarkers() async {
    var placesMarkers = new List<Marker>();
    var nearbyPlaces = await _placesService.getNearbyPlaces(
        _currentLocation.latitude, _currentLocation.longitude, _searchKeyword);

    if (nearbyPlaces.isNotEmpty) {
      _places = List.from(nearbyPlaces);
      nearbyPlaces.forEach((p) {
        var marker = Marker(
            markerId: MarkerId(p.placeId),
            position: LatLng(p.geometry.location.lat, p.geometry.location.lng),
            infoWindow: InfoWindow(title: p.name),
            onTap: () {
              var index = nearbyPlaces.indexOf(p);
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeOutSine);
            });
        placesMarkers.add(marker);
      });
    }

    return placesMarkers;
  }

  Future<String> _showSearchInputDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    return await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            title: Text(
              "Enter place to search",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Restaurants, ATMs, etc."),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("CANCEL"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("SEARCH"),
                onPressed: () {
                  Navigator.of(context).pop(controller.value.text);
                },
              )
            ],
          );
        });
  }

  PageView _buildPlacesCarousel() {
    return PageView.builder(
      itemCount: _places.length,
      controller: _pageController,
      itemBuilder: buildPlaceListItem,
    );
  }

  ListView _buildPlacesList() {
    return ListView.builder(
      itemCount: _places.length,
      itemBuilder: buildPlaceListItem,
    );
  }

  Widget buildPlaceListItem(BuildContext context, int itemIndex) {
    var place = _places[itemIndex];

    return PlaceCard(
      _places[itemIndex],
      () {
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                  place.geometry.location.lat,
                  place.geometry.location.lng,
                ),
                zoom: 17),
          ),
        );
      },
    );
  }

  _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    _mapController = controller;
    await _searchNearbyPlaces();
  }

  Future _searchNearbyPlaces() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    _currentLocation = await _locationService.getCurrentLocation();
    var placesMarkers = await _getNearbyPlacesMarkers();

    setState(() {
      _currentCameraPosition =
          CameraPosition(target: _currentLocation, zoom: 15);
      _markers = placesMarkers;
    });

    _mapController
        ?.moveCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));

    if (_places.isNotEmpty) {
      _pageController.animateToPage(0,
          duration: Duration(milliseconds: 250), curve: Curves.easeOutSine);
    }

    setState(() => _isRefreshing = false);
  }
}
