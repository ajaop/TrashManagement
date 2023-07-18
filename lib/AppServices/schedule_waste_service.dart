import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Models/recent_location.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import '../Provider/location_provider.dart';
import '../Provider/search_location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_polyline_points/src/utils/request_enums.dart' as travel;

import '../secrets.dart';

const kGoogleApiKey = Secrets.API_KEY;

class ScheduleWasteService {
  final BuildContext context;
  double screenHeight = 0;
  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];

  ScheduleWasteService(this.context);

  Future<void> getUserCurrentLocation() async {
    Provider.of<LocationProvider>(context, listen: false).updateLoading();
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });

    Position currentLocation = await Geolocator.getCurrentPosition();

    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);
    var address = placemarks.first.name;

    Provider.of<LocationProvider>(context, listen: false)
        .updateLocation(address ?? 'No Location');

    setCamera(currentLocation.latitude, currentLocation.longitude, address!);

    await getRecentLocations();

    Provider.of<LocationProvider>(context, listen: false).updateLoading();
  }

  Future<void> handlePressSearch() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: Mode.overlay,
        language: 'en',
        logo: Text(''),
        strictbounds: false,
        overlayBorderRadius: BorderRadius.all(Radius.circular(20)),
        types: [""],
        resultTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Color(0xff1B3823),
            fontSize: 17.0,
            fontWeight: FontWeight.w300),
        hint: 'Search Location',
        textStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
            color: Color(0xff1B3823),
            fontSize: 17.0,
            fontWeight: FontWeight.bold),
        textDecoration: const InputDecoration(
            hintStyle: TextStyle(
                color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)))),
        components: [
          Component(Component.country, "ng"),
          Component(Component.country, "usa")
        ]);
    if (p == null) {
      Provider.of<SearchLocation>(context, listen: false).updateState();
    } else {
      displayPrediction(p);
      Provider.of<SearchLocation>(context, listen: false).updateState();
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red[600],
      content: Text(
        response.errorMessage!,
        textAlign: TextAlign.center,
      ),
    ));
  }

  Future<void> displayPrediction(Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    storeRecentLocation(p, lat, lng, detail.result.formattedAddress);

    setCamera(lat, lng, detail.result.name);
  }

  Future<void> setCamera(double lat, double lng, String name) async {
    Provider.of<LocationProvider>(context, listen: false).updateMarkers(Marker(
        markerId: MarkerId('1'),
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'images/location_marker.png'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: name)));

    Provider.of<LocationProvider>(context, listen: false)
        .controllerAnimateCamera(lat, lng);

    //getDistance(lat, lng);
  }

  Future<void> getRecentLocations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? recentLocationString = prefs.getString('recent-locations');

    if (recentLocationString != null) {
      Provider.of<LocationProvider>(context, listen: false)
          .initializeLocations(RecentLocation.decode(recentLocationString));
    }
  }

  Future<void> storeRecentLocation(Prediction p, lat, lng, name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? recentLocationString = prefs.getString('recent-locations');
    String encodedData = '';
    List<RecentLocation>? recentLocationsList =
        Provider.of<LocationProvider>(context, listen: false)
            .recentLocationsList;

    if (recentLocationString == null) {
      Provider.of<LocationProvider>(context, listen: false)
          .updateRecentLocation(RecentLocation(
              lat: lat,
              lng: lng,
              description: p.description ?? 'No Description',
              name: name));

      encodedData = RecentLocation.encode(recentLocationsList!);
      await prefs.setString('recent-locations', encodedData);
    } else {
      if (recentLocationsList!.length >= 3) {
        Provider.of<LocationProvider>(context, listen: false)
            .removeRecentLocation(0);

        Provider.of<LocationProvider>(context, listen: false)
            .updateRecentLocation(RecentLocation(
                lat: lat,
                lng: lng,
                description: p.description ?? 'No Description',
                name: name));

        encodedData = RecentLocation.encode(recentLocationsList);

        await prefs.setString('recent-locations', encodedData);
      } else {
        for (int i = 0; i < recentLocationsList.length; i++) {
          if (recentLocationsList[i].description == p.description) {
            recentLocationsList.removeAt(i);
          }
        }

        Provider.of<LocationProvider>(context, listen: false)
            .updateRecentLocation(RecentLocation(
                lat: lat,
                lng: lng,
                description: p.description ?? 'No Description',
                name: name));

        encodedData = RecentLocation.encode(recentLocationsList);
      }

      await prefs.setString('recent-locations', encodedData);
    }
  }

  Future<void> getDistance(startLat, startLng, name) async {
    var destinationLat = 7.395412900000002;
    var destinationLng = 3.918210800000001;

    Provider.of<LocationProvider>(context, listen: false).updateMarkers(Marker(
        markerId: MarkerId('1'),
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'images/location_marker.png'),
        position: LatLng(startLat, startLng),
        infoWindow: InfoWindow(title: name)));

    Provider.of<LocationProvider>(context, listen: false).updateMarkers(Marker(
        markerId: MarkerId('2'),
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'images/location_marker.png'),
        position: LatLng(destinationLat, destinationLng),
        infoWindow: InfoWindow(title: 'Oyo Waste Management')));

    double miny = (startLat <= destinationLat) ? startLat : destinationLat;
    double minx = (startLng <= destinationLng) ? startLng : destinationLng;
    double maxy = (startLat <= destinationLat) ? destinationLat : startLat;
    double maxx = (startLng <= destinationLng) ? destinationLng : startLng;

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;

    Provider.of<LocationProvider>(context, listen: false)
        .controllerAnimateCamera2(northEastLatitude, northEastLongitude,
            southWestLatitude, southWestLongitude);

    createPolyLines(startLat, startLng, destinationLat, destinationLng);
  }

  createPolyLines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY,
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: travel.TravelMode.driving,
    );
    print(result.errorMessage);
    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map

    Provider.of<LocationProvider>(context, listen: false)
        .updatePolyLine(polyline, id);
  }
}
