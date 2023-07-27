import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:trash_management/AppServices/database_service.dart';
import 'package:trash_management/AppServices/schedule_waste_service.dart';
import 'package:trash_management/CustomExtras/custom_icons_icons.dart';
import 'package:trash_management/Models/truck_type.dart';

class select_truck_bottomsheet extends StatelessWidget {
  select_truck_bottomsheet(
      {Key? key,
      required this.screenHeight,
      required this.locationName,
      required this.locationLat,
      required this.locationLng,
      required this.messangerKey})
      : super(key: key);

  final double screenHeight;
  final String locationName;
  final double locationLat;
  final double locationLng;
  final messangerKey;
  final List<TruckType> wasteTrucksList = [
    TruckType(
        truckImg: 'images/garbage_truck1.png',
        truckName: 'Mini Waste Truck',
        truckMinSize: '12kg',
        truckMaxSize: '17kg',
        amount: '₦ 1500'),
    TruckType(
        truckImg: 'images/garbage_truck2.png',
        truckName: 'Maxi Waste Truck',
        truckMinSize: '12kg',
        truckMaxSize: '17kg',
        amount: '₦ 2000'),
    TruckType(
        truckImg: 'images/garbage_truck3.png',
        truckName: 'Large Waste Truck',
        truckMinSize: '12kg',
        truckMaxSize: '17kg',
        amount: '₦ 2500')
  ];
  @override
  Widget build(BuildContext context) {
    ScheduleWasteService scheduleWasteService =
        ScheduleWasteService(context, messangerKey);

    return Container(
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
                  child: Text(locationName,
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
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: wasteTrucksList.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: 15.0,
                ),
                itemBuilder: (context, position) {
                  return InkWell(
                    onTap: () {
                      scheduleWasteService.selectDate(context, locationName,
                          locationLat, locationLng, wasteTrucksList[position]);
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
                              AssetImage(wasteTrucksList[position].truckImg),
                              size: 50.0,
                              color: Color(0xff08110B),
                            ),
                            Column(
                              children: [
                                Text(wasteTrucksList[position].truckName!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            fontSize: 19.0,
                                            color: Color(0xff08110B),
                                            fontWeight: FontWeight.bold)),
                                Text(
                                    wasteTrucksList[position].truckMinSize! +
                                        ' - ' +
                                        wasteTrucksList[position].truckMaxSize!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            fontSize: 17.0,
                                            color: Color(0xff08110B),
                                            fontWeight: FontWeight.normal))
                              ],
                            ),
                            Text(wasteTrucksList[position].amount!,
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
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
