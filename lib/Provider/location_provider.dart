import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trash_management/Models/recent_location.dart';

class LocationProvider extends ChangeNotifier {
  final List<Marker> markers = <Marker>[];
  List<RecentLocation>? recentLocationsList = <RecentLocation>[];
  GoogleMapController? controller;
  bool isLoading = false;
  String location = '';
  Map<PolylineId, Polyline> polylines = {};

  void updateLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void updateMarkers(Marker markerItem) {
    markers.add(markerItem);
    notifyListeners();
  }

  void initializeLocations(List<RecentLocation>? previousLocations) {
    recentLocationsList = previousLocations;
    notifyListeners();
  }

  void updateRecentLocation(RecentLocation recentLocationItem) {
    recentLocationsList?.add(recentLocationItem);
    notifyListeners();
  }

  void removeRecentLocation(int position) {
    recentLocationsList?.removeAt(position);
    notifyListeners();
  }

  void controllerAnimateCamera(double lat, double lng) {
    controller?.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(lat, lng),
      18,
    ));
    notifyListeners();
  }

  void controllerAnimateCamera2(
      double northEastLat, double northEastLng, southWestLat, southWestLng) {
    controller?.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        northeast: LatLng(northEastLat, northEastLng),
        southwest: LatLng(southWestLat, southWestLng),
      ),
      85.0,
    ));
    notifyListeners();
  }

  void setController(GoogleMapController _controller) {
    controller = _controller;
    notifyListeners();
  }

  void updateLocation(String name) {
    location = name;
    notifyListeners();
  }

  void updatePolyLine(Polyline polyline, PolylineId id) {
    polylines[id] = polyline;
  }
}
