import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/constants/app_constants.dart';
import 'package:flutter_demo/ui/resources/app_theme.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PlaceCard extends StatelessWidget {
  final PlacesSearchResult _place;
  final GestureTapCallback _onTap;

  PlaceCard(this._place, this._onTap);

  @override
  Widget build(BuildContext context) {
    String photoUrl;
    if (_place.photos != null) {
      photoUrl =
          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=512&photoreference=${_place.photos.first.photoReference}&key=${AppConstants.placesApiKey}";
    }

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: InkWell(
          onTap: _onTap,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: SizedBox(
                    height: 128,
                    width: double.infinity,
                    child: Container(
                      color: Color.fromARGB(255, 200, 200, 200),
                      child: photoUrl != null
                          ? CachedNetworkImage(
                              imageUrl: photoUrl,
                              fadeInDuration: Duration(milliseconds: 250),
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.image,
                              size: 128,
                              color: Color.fromARGB(80, 0, 0, 0),
                            ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _place.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.PlaceTitleTextStyle,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        child: Text(_place.vicinity,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.PlaceAddressTextStyle),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        child: Row(
                          children: <Widget>[
                            SmoothStarRating(
                              allowHalfRating: true,
                              starCount: 5,
                              size: 16,
                              color: Colors.yellow,
                              borderColor: Colors.yellow,
                              rating: _place.rating != null
                                  ? _place.rating.toDouble()
                                  : 0.0,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 2),
                              child: Text(
                                _place.rating != null
                                    ? "${_place.rating}"
                                    : "No rating",
                                style: AppTheme.PlaceRatingTextStyle,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
