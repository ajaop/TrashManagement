import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_management/AppServices/schedule_waste_service.dart';
import 'package:trash_management/Models/schedule_pickup.dart';
import '../Models/user_details.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key, required this.schedulePickup}) : super(key: key);
  final SchedulePickup schedulePickup;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    UserDetails userDetails = Provider.of<UserDetails>(context);
    ScheduleWasteService scheduleWasteService =
        ScheduleWasteService(context, _messangerKey);
    String fullname = userDetails.lastname! + ' ' + userDetails.firstname!;
    String phone = userDetails.phoneNumber!;
    String email = userDetails.email!;

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
            child: ListView(
              shrinkWrap: true,
              children: [
                CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Color(0xffEEF7F0),
                  child: userDetails.profileImageUrl == null
                      ? null
                      : Image.asset(
                          userDetails.profileImageUrl!,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(fullname,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Color(0xff1B3823),
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text('Waste Disposal Payment',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.grey[700],
                          fontSize: 19.0,
                          fontWeight: FontWeight.normal)),
                ),
                SizedBox(
                  height: 80.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xffC9E4D0),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      child: Text(widget.schedulePickup.wasteTruck!.amount!,
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                  color: Color(0xff1B3823),
                                  fontWeight: FontWeight.w900)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 90.0,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff19433C),
                        minimumSize: const Size.fromHeight(55),
                        textStyle: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(fontSize: 20.0, color: Colors.white)),
                    onPressed: !_loading
                        ? () {
                            setState(() {
                              _loading = true;
                            });
                            scheduleWasteService.makeFlutterWavePayment(
                                widget.schedulePickup, fullname, phone, email);
                          }
                        : null,
                    child: Text('Make Payment'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
