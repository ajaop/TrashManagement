import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_management/AppServices/payment_service.dart';
import 'package:trash_management/AppServices/schedule_waste_service.dart';
import 'package:trash_management/Models/schedule_pickup.dart';
import '../Models/user_details.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../Provider/location_provider.dart';
import '../env/env.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class ConfirmPickupPage extends StatefulWidget {
  const ConfirmPickupPage({Key? key, required this.schedulePickup})
      : super(key: key);
  final SchedulePickup schedulePickup;

  @override
  State<ConfirmPickupPage> createState() => _ConfirmPickupPageState();
}

class _ConfirmPickupPageState extends State<ConfirmPickupPage> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final payStackClient = PaystackPlugin();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    payStackClient.initialize(publicKey: Env.paystackTestPublicKey);
  }

  @override
  Widget build(BuildContext context) {
    UserDetails userDetails = Provider.of<UserDetails>(context);
    ScheduleWasteService scheduleWasteService =
        ScheduleWasteService(context, _messangerKey);
    PaymentService paymentService =
        PaymentService(context, _messangerKey, payStackClient);
    String fullname = userDetails.lastname! + ' ' + userDetails.firstname!;
    String phone = userDetails.phoneNumber!;
    String email = userDetails.email!;
    String formattedDate =
        DateFormat.yMMMd().format(widget.schedulePickup.pickupDate!);
    final CameraPosition initialLoc = CameraPosition(
      target: LatLng(widget.schedulePickup.locationLat!,
          widget.schedulePickup.locationLng!),
      zoom: 14.4746,
    );
    final List<Marker> _markers =
        Provider.of<LocationProvider>(context).markers;
    Map<PolylineId, Polyline> _polylines =
        Provider.of<LocationProvider>(context).polylines;

    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xffA2D1AE),
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Stack(
              children: [
                ListView(
                  shrinkWrap: true,
                  children: [
                    // CircleAvatar(
                    //   radius: 60.0,
                    //   backgroundColor: Color(0xffEEF7F0),
                    //   child: userDetails.profileImageUrl == null
                    //       ? null
                    //       : Image.asset(
                    //           userDetails.profileImageUrl!,
                    //           fit: BoxFit.cover,
                    //           alignment: Alignment.center,
                    //         ),
                    // ),
                    // SizedBox(
                    //   height: 20.0,
                    // ),
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: Text(fullname,
                    //       style: Theme.of(context).textTheme.headline4!.copyWith(
                    //           color: Color(0xff1B3823),
                    //           fontWeight: FontWeight.bold)),
                    // ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: Text('Waste Disposal Payment',
                    //       style: Theme.of(context).textTheme.headline5!.copyWith(
                    //           color: Colors.grey[700],
                    //           fontSize: 19.0,
                    //           fontWeight: FontWeight.normal)),
                    // ),
                    // SizedBox(
                    //   height: 80.0,
                    // ),
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: Container(
                    //     decoration: const BoxDecoration(
                    //       color: Color(0xffC9E4D0),
                    //       borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    //     ),
                    //     child: Padding(
                    //       padding:
                    //           const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    //       child: Text(widget.schedulePickup.wasteTruck!.amount!,
                    //           style: Theme.of(context)
                    //               .textTheme
                    //               .headline3!
                    //               .copyWith(
                    //                   color: Color(0xff1B3823),
                    //                   fontWeight: FontWeight.w900)),
                    //     ),
                    //   ),
                    // ),
                    Text('Confirm Pickup Details',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Color(0xff1B3823),
                            fontWeight: FontWeight.w800)),
                    SizedBox(
                      height: 60.0,
                    ),
                    Text('Pickup Location',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Color(0xff1B3823),
                            fontSize: 19.0,
                            fontWeight: FontWeight.w800)),
                    SizedBox(
                      height: 15.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Hero(
                        tag: 'map',
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xff1B3823), width: 3.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 120,
                                decoration: const BoxDecoration(
                                  color: Color(0xffC9E4D0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: GoogleMap(
                                  initialCameraPosition: initialLoc,
                                  markers: Set<Marker>.of(_markers),
                                  polylines:
                                      Set<Polyline>.of(_polylines.values),
                                  mapType: MapType.normal,
                                  trafficEnabled: true,
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: false,
                                  zoomGesturesEnabled: false,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    Provider.of<LocationProvider>(context,
                                            listen: false)
                                        .setController(controller);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(widget.schedulePickup.locationAddress!,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                          color: Color(0xff08110B),
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),

                    Text('Truck Type',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Color(0xff1B3823),
                            fontSize: 19.0,
                            fontWeight: FontWeight.w800)),
                    SizedBox(
                      height: 15.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff1B3823), width: 3.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ImageIcon(
                              AssetImage(
                                  widget.schedulePickup.wasteTruck!.truckImg),
                              size: 50.0,
                              color: Color(0xff08110B),
                            ),
                            Column(
                              children: [
                                Text(
                                    widget
                                        .schedulePickup.wasteTruck!.truckName!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            fontSize: 19.0,
                                            color: Color(0xff08110B),
                                            fontWeight: FontWeight.bold)),
                                Text(
                                    widget.schedulePickup.wasteTruck!
                                            .truckMinSize! +
                                        ' - ' +
                                        widget.schedulePickup.wasteTruck!
                                            .truckMaxSize!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            fontSize: 17.0,
                                            color: Color(0xff08110B),
                                            fontWeight: FontWeight.normal))
                              ],
                            ),
                            Text(widget.schedulePickup.wasteTruck!.amount!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontSize: 19.0,
                                        color: Color(0xff08110B),
                                        fontWeight: FontWeight.w800))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),

                    Text('Pickup Date',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Color(0xff1B3823),
                            fontSize: 19.0,
                            fontWeight: FontWeight.w800)),
                    SizedBox(
                      height: 15.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff1B3823), width: 3.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Text(formattedDate,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize: 20.0,
                                    color: Color(0xff08110B),
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff19433C),
                            minimumSize: const Size.fromHeight(55),
                            textStyle: Theme.of(context)
                                .textTheme
                                .button!
                                .copyWith(fontSize: 20.0, color: Colors.white)),
                        onPressed: !_loading
                            ? () async {
                                setState(() {
                                  _loading = true;
                                });
                                paymentService.makePayment(
                                    context,
                                    widget.schedulePickup,
                                    fullname,
                                    phone,
                                    email);

                                setState(() {
                                  _loading = false;
                                });
                              }
                            : null,
                        child: const Text('Make Payment')),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
