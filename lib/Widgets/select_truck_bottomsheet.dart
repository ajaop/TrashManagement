import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trash_management/CustomExtras/custom_icons_icons.dart';

class select_truck_bottomsheet extends StatelessWidget {
  const select_truck_bottomsheet(
      {Key? key, required this.screenHeight, required this.location})
      : super(key: key);

  final double screenHeight;
  final String location;

  @override
  Widget build(BuildContext context) {
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
                  Icons.location_on_outlined,
                  color: Color(0xff1B3823),
                  size: 30,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Flexible(
                  child: Text(location,
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
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              color: Colors.white,
                              height: screenHeight * 0.42,
                              child: Column(
                                children: [
                                  CupertinoDatePicker(
                                    minimumDate:
                                        DateTime.now().add(Duration(days: 1)),
                                    initialDateTime:
                                        DateTime.now().add(Duration(days: 1)),
                                    onDateTimeChanged: (DateTime newdate) {
                                      print(newdate);
                                    },
                                    mode: CupertinoDatePickerMode.date,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xff19433C),
                                            maximumSize:
                                                const Size.fromHeight(55),
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .button!
                                                .copyWith(
                                                    fontSize: 20.0,
                                                    color: Colors.white)),
                                        onPressed: () {},
                                        child: Text('Save')),
                                  )
                                ],
                              ),
                            );
                          });
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
    );
  }
}
