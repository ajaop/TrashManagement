import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';

class ScheduleWastePickup extends StatefulWidget {
  const ScheduleWastePickup({Key? key}) : super(key: key);

  @override
  State<ScheduleWastePickup> createState() => _ScheduleWastePickupState();
}

class _ScheduleWastePickupState extends State<ScheduleWastePickup> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final List<Marker> _markers = <Marker>[];

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEF7F0),
      body: Column(
        children: [
          SizedBox(
            height: 520,
            child: GoogleMap(
              initialCameraPosition: _kGooglePlex,
              markers: Set<Marker>.of(_markers),
              mapType: MapType.normal,
              myLocationEnabled: true,
              compassEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 320,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            ),
          ),
          SizedBox(
            height: 70,
          )
        ],
      ),
    );
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getDetails() async {
    Position currentLocation = await getUserCurrentLocation();
    _markers.add(Marker(
      markerId: MarkerId("1"),
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(), 'images/location_marker.png'),
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
      infoWindow: InfoWindow(
        title: currentLocation.longitude.toString() +
            ", " +
            currentLocation.latitude.toString(),
      ),
    ));

    CameraPosition cameraPosition = new CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 18,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }
}
