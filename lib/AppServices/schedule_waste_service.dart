import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trash_management/Models/schedule_pickup.dart';
import 'package:trash_management/Models/truck_type.dart';
import 'package:trash_management/Screens/schedule_waste_page.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Widgets/select_truck_bottomsheet.dart';
import '../secrets.dart';

const kGoogleApiKey = Secrets.API_KEY;

class ScheduleWasteService {
  final BuildContext context;
  final _messangerKey;
  double screenHeight = 0;
  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  FirebaseAuth auth = FirebaseAuth.instance;

  ScheduleWasteService(this.context, this._messangerKey);

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

    Provider.of<LocationProvider>(context, listen: false).updateLocation(
        address ?? 'No Location',
        currentLocation.latitude,
        currentLocation.longitude);

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

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    var state =
        placemarks.first.administrativeArea?.toLowerCase() ?? 'No State';
    if (state.contains('oyo') || state.contains('lagos')) {
      storeRecentLocation(p, lat, lng, detail.result.name);
      getDistance(lat, lng, detail.result.name);
      selectTruckType(detail.result.name, lat, lng);
    } else {
      error('Outside Jurisdiction', _messangerKey);
    }
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
  }

  Future<void> getRecentLocations() async {
    Provider.of<LocationProvider>(context, listen: false).clearMarkers();
    Provider.of<LocationProvider>(context, listen: false).clearPolyLine();

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

    Provider.of<LocationProvider>(context, listen: false).clearMarkers();

    Provider.of<LocationProvider>(context, listen: false).updateMarkers(Marker(
        markerId: MarkerId('1'),
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'images/location_marker.png'),
        position: LatLng(startLat, startLng),
        infoWindow: InfoWindow(title: name)));

    Provider.of<LocationProvider>(context, listen: false).updateMarkers(Marker(
        markerId: MarkerId('2'),
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'images/waste_marker.png'),
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
      Secrets.API_KEY2,
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: travel.TravelMode.driving,
    );
    print(result.errorMessage);
    // Adding the coordinates to the list
    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = const PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Color(0xff1B3823),
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map

    Provider.of<LocationProvider>(context, listen: false)
        .updatePolyLine(polyline, id);
  }

  Future<void> selectTruckType(
      String locationName, double locationLat, double locationLng) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    return showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50.0),
          ),
        ),
        elevation: 10,
        builder: (BuildContext context) {
          return select_truck_bottomsheet(
            screenHeight: screenHeight,
            locationName: locationName,
            locationLat: locationLat,
            locationLng: locationLng,
            messangerKey: _messangerKey,
          );
        });
  }

  selectDate(BuildContext context, String locationName, double locationLat,
      double locationLng, TruckType truckType) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
      lastDate: DateTime(DateTime.now().year + 1),
      helpText: 'Select Pickup Date',
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primaryColor: Color(0xffA2D1AE),
            colorScheme:
                ThemeData().colorScheme.copyWith(primary: Color(0xff1B3823)),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      bool isScheduled = await schedulePickupDate(
          locationName, locationLat, locationLng, truckType, pickedDate);

      if (isScheduled == true) {
      } else {
        error('Error Scheduling Waste Pickup', _messangerKey);
      }
    }
  }

  Future<bool> schedulePickupDate(String name, double lat, double lng,
      TruckType truck, DateTime pickupDate) async {
    final User? user = auth.currentUser;
    if (user!.uid.isNotEmpty) {
      try {
        DocumentReference<Map<String, dynamic>> pickup =
            FirebaseFirestore.instance.collection('waste_pickup').doc();

        SchedulePickup schedulePickup = SchedulePickup(
            locationName: name,
            locationLat: lat,
            locationLng: lng,
            wasteTruck: truck,
            pickupDate: pickupDate,
            userId: user.uid);

        // await pickup.set(schedulePickup.createMap());
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  void error(errorMessage, _messangerKey) {
    _messangerKey.currentState!.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
        duration: const Duration(seconds: 5),
        elevation: 0,
        content: Text(
          errorMessage,
          textAlign: TextAlign.center,
        )));

    Timer(Duration(seconds: 3), () {
      _messangerKey.currentState!.hideCurrentSnackBar();
    });
  }
}
