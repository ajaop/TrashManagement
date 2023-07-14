import 'dart:async';
import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:trash_management/Models/search_location.dart';
import 'package:provider/provider.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CustomExtras/custom_icons_icons.dart';

class ScheduleWastePickup extends StatefulWidget {
  const ScheduleWastePickup({Key? key}) : super(key: key);

  @override
  State<ScheduleWastePickup> createState() => _ScheduleWastePickupState();
}

const kGoogleApiKey = "AIzaSyBT7MkcYyKTDpYkvjPcT89-wfueYXDS-Qk";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
final List<Marker> _markers = <Marker>[];
List<RecentLocation>? recentLocationsList = <RecentLocation>[];

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
    double searchBoxPosition;
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;

    if (screenHeight < 700) {
      searchBoxPosition = (screenHeight * 0.59) / 2.4;
    } else {
      searchBoxPosition = (screenHeight * 0.59) / 2.2;
    }

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
                                _handlePressSearch();
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
                              itemBuilder: (context, position) {
                                return InkWell(
                                  onTap: () {
                                    setCamera(
                                        recentLocationsList![position].lat,
                                        recentLocationsList![position].lng,
                                        recentLocationsList![position].name);
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
                              separatorBuilder: (context, index) => SizedBox(
                                height: 15.0,
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

    await getRecentLocations();
    setState(() {});
  }

  Future<void> _handlePressSearch() async {
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

    storeRecentLocation(p, lat, lng, detail.result.name);

    setCamera(lat, lng, detail.result.name);
  }

  Future<void> setCamera(double lat, double lng, String name) async {
    _markers.add(Marker(
        markerId: const MarkerId("2"),
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'images/location_marker.png'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: name)));
    final GoogleMapController controller = await _controller.future;

    setState(() {
      controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(lat, lng),
        18,
      ));
    });
  }

  Future<void> getRecentLocations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? recentLocationString = prefs.getString('recent-locations');

    if (recentLocationString != null) {
      recentLocationsList = RecentLocation.decode(recentLocationString);
    }
  }

  Future<void> storeRecentLocation(Prediction p, lat, lng, name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? recentLocationString = prefs.getString('recent-locations');
    String encodedData = '';

    if (recentLocationString == null) {
      recentLocationsList?.add(RecentLocation(
          lat: lat,
          lng: lng,
          description: p.description ?? 'No Description',
          name: name));
      encodedData = RecentLocation.encode(recentLocationsList!);
      await prefs.setString('recent-locations', encodedData);
    } else {
      if (recentLocationsList!.length >= 3) {
        recentLocationsList!.removeAt(0);
        recentLocationsList!.add(RecentLocation(
            lat: lat,
            lng: lng,
            description: p.description ?? 'No Description',
            name: name));

        encodedData = RecentLocation.encode(recentLocationsList!);

        await prefs.setString('recent-locations', encodedData);
      } else {
        for (int i = 0; i < recentLocationsList!.length; i++) {
          if (recentLocationsList![i].description == p.description) {
            recentLocationsList!.removeAt(i);
          }
        }

        recentLocationsList!.add(
          RecentLocation(
              lat: lat,
              lng: lng,
              description: p.description ?? 'No Description',
              name: name ?? 'No Name'),
        );

        encodedData = RecentLocation.encode(recentLocationsList!);
      }

      await prefs.setString('recent-locations', encodedData);
    }

    setState(() {});
  }
}

class RecentLocation {
  final double lat, lng;
  final String description, name;

  RecentLocation(
      {required this.lat,
      required this.lng,
      required this.description,
      required this.name});

  factory RecentLocation.fromJson(Map<String, dynamic> jsonData) {
    return RecentLocation(
        lat: jsonData['lat'],
        lng: jsonData['lng'],
        description: jsonData['description'],
        name: jsonData['name']);
  }

  static Map<String, dynamic> toMap(RecentLocation recentLocation) => {
        'lat': recentLocation.lat,
        'lng': recentLocation.lng,
        'description': recentLocation.description,
        'name': recentLocation.name
      };

  static String encode(List<RecentLocation> recentLocations) => json.encode(
        recentLocations
            .map<Map<String, dynamic>>(
                (recentLocations) => RecentLocation.toMap(recentLocations))
            .toList(),
      );

  static List<RecentLocation> decode(String recentLocations) =>
      (json.decode(recentLocations) as List<dynamic>)
          .map<RecentLocation>((item) => RecentLocation.fromJson(item))
          .toList();
}
