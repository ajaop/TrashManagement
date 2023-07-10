import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:trash_management/Models/search_location.dart';
import 'package:provider/provider.dart';

import '../CustomExtras/custom_icons_icons.dart';

class ScheduleWastePickup extends StatefulWidget {
  const ScheduleWastePickup({Key? key}) : super(key: key);

  @override
  State<ScheduleWastePickup> createState() => _ScheduleWastePickupState();
}

class _ScheduleWastePickupState extends State<ScheduleWastePickup>
    with SingleTickerProviderStateMixin {
  double screenHeight = 0;
  Position? currentLocation;
  late AnimationController _animController;
  final Duration duration = const Duration(milliseconds: 200);
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
    _animController = AnimationController(vsync: this, duration: duration);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool searchLocation = Provider.of<SearchLocation>(context).search;
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;

    print(screenHeight);

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xff1B3823),
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff1B3823)),
      ),
      home: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: searchLocation ? double.infinity : screenHeight * 0.59,
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
            Visibility(
              visible: !searchLocation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  child: Container(
                    width: double.infinity,
                    height: screenHeight * 0.41,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text('Pick-Up Location',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      fontSize: 19.0,
                                      color: Color(0xff1B3823),
                                      fontWeight: FontWeight.w900)),
                          SizedBox(
                            height: (screenHeight * 0.41) * 0.28,
                          ),
                          Container(
                            height: 55,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                              child: Row(
                                children: [
                                  Icon(
                                    CustomIcons.location_arrow,
                                    size: 16.0,
                                  ),
                                  SizedBox(
                                    width: 70.0,
                                  ),
                                  Text('Use Current Location',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontSize: 17.0,
                                              color: Color(0xff1B3823),
                                              fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: searchLocation ? 0.47 * screenHeight : 0.64 * 379.66,
              width: searchLocation
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 1.15,
              duration: duration,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 5),
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                      color: searchLocation ? Colors.white : Color(0xffC9E4D0),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 5.0),
                      child: TextFormField(
                          cursorColor: Color(0xff1B3823),
                          inputFormatters: [],
                          onChanged: (value) => null,
                          onTap: () async {
                            Provider.of<SearchLocation>(context, listen: false)
                                .updateState();

                            _animController.forward();
                          },
                          onFieldSubmitted: (value) {
                            Provider.of<SearchLocation>(context, listen: false)
                                .updateState();

                            _animController.reverse();
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search Location',
                            border: InputBorder.none,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(right: 30),
                              child: Icon(Icons.search_outlined),
                            ),
                            enabled: true,
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
    currentLocation = await getUserCurrentLocation();
    _markers.add(Marker(
      markerId: MarkerId("1"),
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(), 'images/location_marker.png'),
      position: LatLng(currentLocation!.latitude, currentLocation!.longitude),
      infoWindow: InfoWindow(
        title: currentLocation!.longitude.toString() +
            ", " +
            currentLocation!.latitude.toString(),
      ),
    ));

    CameraPosition cameraPosition = new CameraPosition(
      target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
      zoom: 18,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }
}
