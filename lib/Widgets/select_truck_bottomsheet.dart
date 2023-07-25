import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:trash_management/AppServices/database_service.dart';
import 'package:trash_management/AppServices/schedule_waste_service.dart';
import 'package:trash_management/CustomExtras/custom_icons_icons.dart';
import 'datepicker_bottomsheet.dart';

class select_truck_bottomsheet extends StatelessWidget {
  const select_truck_bottomsheet(
      {Key? key,
      required this.screenHeight,
      required this.location,
      required this.messangerKey})
      : super(key: key);

  final double screenHeight;
  final String location;
  final messangerKey;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        height: screenHeight * 0.42,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    SolarIconsOutline.mapPointWave,
                    color: Color(0xff1B3823),
                    size: 30,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Flexible(
                    child: Text(location,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Color(0xff1B3823),
                            fontWeight: FontWeight.w500)),
                  )
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffEEF7F0),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ImageIcon(
                                AssetImage("images/garbage_truck1.png"),
                                size: 50.0,
                                color: Color(0xff08110B),
                              ),
                              Column(
                                children: [
                                  Text('Mini Waste Truck',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontSize: 19.0,
                                              color: Color(0xff08110B),
                                              fontWeight: FontWeight.bold)),
                                  Text('12kg - 17kg',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontSize: 17.0,
                                              color: Color(0xff08110B),
                                              fontWeight: FontWeight.normal))
                                ],
                              ),
                              Text('₦ 1500',
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
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffEEF7F0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ImageIcon(
                              AssetImage("images/garbage_truck2.png"),
                              size: 50.0,
                              color: Color(0xff08110B),
                            ),
                            Column(
                              children: [
                                Text('Maxi Waste Truck',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            fontSize: 19.0,
                                            color: Color(0xff08110B),
                                            fontWeight: FontWeight.bold)),
                                Text('12kg - 17kg',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            fontSize: 17.0,
                                            color: Color(0xff08110B),
                                            fontWeight: FontWeight.normal))
                              ],
                            ),
                            Text('₦ 2000',
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
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffEEF7F0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ImageIcon(
                              AssetImage("images/garbage_truck3.png"),
                              size: 50.0,
                              color: Color(0xff08110B),
                            ),
                            Column(
                              children: [
                                Text('Large Waste Truck',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            fontSize: 19.0,
                                            color: Color(0xff08110B),
                                            fontWeight: FontWeight.bold)),
                                Text('12kg - 17kg',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            fontSize: 17.0,
                                            color: Color(0xff08110B),
                                            fontWeight: FontWeight.normal))
                              ],
                            ),
                            Text('₦ 2500',
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    ScheduleWasteService scheduleWasteService =
        ScheduleWasteService(context, messangerKey);

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
          ), // This will change to light theme.
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      print(pickedDate);
    }
  }
}
