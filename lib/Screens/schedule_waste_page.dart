import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trash_management/Provider/location_provider.dart';
import 'package:trash_management/Provider/search_location.dart';
import 'package:provider/provider.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppServices/schedule_waste_service.dart';
import '../CustomExtras/custom_icons_icons.dart';
import '../Models/recent_location.dart';
import '../Provider/search_location.dart';
import '../Widgets/select_truck_bottomsheet.dart';
import '../loader_animation.dart';

class ScheduleWastePickup extends StatefulWidget {
  const ScheduleWastePickup({Key? key}) : super(key: key);

  @override
  State<ScheduleWastePickup> createState() => _ScheduleWastePickupState();
}

class _ScheduleWastePickupState extends State<ScheduleWastePickup> {
  late ScheduleWasteService scheduleWasteService;
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  double screenHeight = 0;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scheduleWasteService = ScheduleWasteService(context, _messangerKey);
      scheduleWasteService.getUserCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool searchLocation = Provider.of<SearchLocation>(context).search;
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;

    final List<Marker> _markers =
        Provider.of<LocationProvider>(context).markers;
    List<RecentLocation>? recentLocationsList =
        Provider.of<LocationProvider>(context).recentLocationsList;
    Map<PolylineId, Polyline> _polylines =
        Provider.of<LocationProvider>(context).polylines;

    bool isLoading = Provider.of<LocationProvider>(context).isLoading;
    String currentLocation = Provider.of<LocationProvider>(context).location;
    double currentLat = Provider.of<LocationProvider>(context).currentLat;
    double currentLng = Provider.of<LocationProvider>(context).currentLng;

    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
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
              color: Color(0xffC9E4D0),
              child: GoogleMap(
                initialCameraPosition: _kGooglePlex,
                markers: Set<Marker>.of(_markers),
                polylines: Set<Polyline>.of(_polylines.values),
                mapType: MapType.normal,
                myLocationEnabled: true,
                compassEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  Provider.of<LocationProvider>(context, listen: false)
                      .setController(controller);
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
                      color: Colors.white,
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
                            height: 30.0,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                            child: InkWell(
                              onTap: () {
                                Provider.of<SearchLocation>(context,
                                        listen: false)
                                    .updateState();
                                scheduleWasteService.handlePressSearch();
                              },
                              child: Container(
                                height: 56,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Color(0xffEEF7F0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 5.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.search_outlined),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Text(
                                            'Search Location',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 18.0, 15.0, 0),
                            child: InkWell(
                              onTap: () {
                                scheduleWasteService.getDistance(
                                    currentLat, currentLng, currentLocation);
                                scheduleWasteService.selectTruckType(
                                    Provider.of<LocationProvider>(context,
                                            listen: false)
                                        .location,
                                    Provider.of<LocationProvider>(context,
                                            listen: false)
                                        .currentLat,
                                    Provider.of<LocationProvider>(context,
                                            listen: false)
                                        .currentLng);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    CustomIcons.location_arrow,
                                    size: 16.0,
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                  ),
                                  Text('Use Current Location',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontSize: 17.0,
                                              color: Color(0xff1B3823),
                                              fontWeight: FontWeight.normal))
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey[300],
                            indent: 10.0,
                            endIndent: 10.0,
                            thickness: 1.5,
                          ),
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: recentLocationsList?.length ?? 0,
                              separatorBuilder: (context, index) => SizedBox(
                                height: 15.0,
                              ),
                              itemBuilder: (context, position) {
                                return InkWell(
                                  onTap: () {
                                    scheduleWasteService.getDistance(
                                        recentLocationsList!.reversed
                                            .toList()[position]
                                            .lat,
                                        recentLocationsList.reversed
                                            .toList()[position]
                                            .lng,
                                        recentLocationsList.reversed
                                            .toList()[position]
                                            .name);

                                    scheduleWasteService.selectTruckType(
                                        recentLocationsList.reversed
                                            .toList()[position]
                                            .name,
                                        recentLocationsList.reversed
                                            .toList()[position]
                                            .lat,
                                        recentLocationsList.reversed
                                            .toList()[position]
                                            .lng);
                                  },
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 0, 15.0, 0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 22.0,
                                          ),
                                          SizedBox(
                                            width: 40.0,
                                          ),
                                          Expanded(
                                            child: Text(
                                                recentLocationsList!.reversed
                                                    .toList()[position]
                                                    .description,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                        fontSize: 17.0,
                                                        color:
                                                            Color(0xff1B3823),
                                                        fontWeight:
                                                            FontWeight.bold)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey[300],
                                      indent: 10.0,
                                      endIndent: 10.0,
                                      thickness: 1.5,
                                    )
                                  ]),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isLoading) const Center(child: Loader())
          ],
        ),
      ),
    );
  }
}
