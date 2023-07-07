import 'package:flutter/material.dart';
import 'package:trash_management/AppServices/database_service.dart';
import 'package:trash_management/Models/user_details.dart';
import 'package:trash_management/Screens/schedule_waste_page.dart';
import 'package:trash_management/ShimmerFeature/shimmer.dart';
import 'package:trash_management/ShimmerFeature/shimmer_loading.dart';
import 'package:provider/provider.dart';

import '../CustomExtras/custom_icons_icons.dart';

const _shimmerGradient = LinearGradient(
  colors: [Color(0xFFEBEBF4), Color(0xFFF4F4F4), Color(0xFFEBEBF4)],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserDetails userDetails = Provider.of<UserDetails>(context);
    //UserDetails userDetails = UserDetails.dashboard();

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xffA2D1AE),
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
      ),
      home: Scaffold(
        body: Stack(children: [
          SafeArea(
              child: Shimmer(
            linearGradient: _shimmerGradient,
            child: ListView(
              padding: const EdgeInsets.all(25.0),
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      children: [
                        Icon(
                          Icons.notifications_outlined,
                          size: 30.0,
                          color: Color(0xff1B3823),
                        ),
                        Visibility(
                          visible: false,
                          child: Positioned(
                              bottom: 18,
                              right: 5,
                              child: CircleAvatar(
                                backgroundColor: Colors.red[500],
                                radius: 5,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerLoading(
                      isLoading: userDetails.profileImageUrl == null,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 2, color: Color(0xff1B3823)),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: CircleAvatar(
                            radius: 40.0,
                            backgroundColor: Color(0xffEEF7F0),
                            child: userDetails.profileImageUrl == null
                                ? null
                                : Image.asset(
                                    userDetails.profileImageUrl!,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: userDetails.points == null
                          ? ShimmerLoading(
                              isLoading: true,
                              child: Container(
                                width: 200,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Color(0xffEEF7F0),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Color(0xff1B3823),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    13.0, 10.0, 13.0, 10.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Colors.yellow[300],
                                        radius: 15,
                                        child: Icon(
                                          Icons.star_border_rounded,
                                          color: Color(0xff1B3823),
                                        )),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    Text(
                                        userDetails.points.toString() +
                                            ' points',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                color: Color(0xffEEF7F0),
                                                fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: userDetails.firstname == null
                        ? ShimmerLoading(
                            isLoading: true,
                            child: Container(
                              width: 200,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Color(0xffEEF7F0),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          )
                        : Text('Hi, ' + userDetails.firstname!.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                    color: Color(0xff1B3823),
                                    fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  child: userDetails.firstname == null
                      ? ShimmerLoading(
                          isLoading: true,
                          child: Container(
                            width: double.infinity,
                            height: 240,
                            decoration: BoxDecoration(
                              color: Color(0xffEEF7F0),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        )
                      : Card(
                          color: Color(0xffC9E4D0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text('Request Waste Pick-Up',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                            color: Color(0xff1B3823),
                                            fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: SizedBox(
                                    width: 180.0,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ScheduleWastePickup()));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 5.0,
                                          primary: Color(0xff1B3823),
                                          minimumSize:
                                              const Size.fromHeight(55),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                        ),
                                        child: Text('Schedule Pick-Up',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button!
                                                .copyWith(
                                                    color: Color(0xffEEF7F0),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                  child: Text('Quick Actions',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Color(0xff1B3823),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (userDetails.points == null)
                      ShimmerLoading(
                        isLoading: true,
                        child: Container(
                          width: 170.0,
                          height: 170.0,
                          decoration: BoxDecoration(
                            color: Color(0xffEEF7F0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 170.0,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(width: 3, color: Color(0xff1B3823)),
                        ),
                        child: InkWell(
                          child: Column(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color(0xffC9E4D0),
                                radius: 40,
                                child: Icon(
                                  CustomIcons.recycle,
                                  size: 35.0,
                                  color: Color(0xff1B3823),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Text('Recycle Waste',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          color: Color(0xff1B3823),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.normal))
                            ],
                          ),
                        ),
                      ),
                    if (userDetails.points == null)
                      ShimmerLoading(
                        isLoading: true,
                        child: Container(
                          width: 170.0,
                          height: 170.0,
                          decoration: BoxDecoration(
                            color: Color(0xffEEF7F0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 170.0,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(width: 3, color: Color(0xff1B3823)),
                        ),
                        child: InkWell(
                          child: Column(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color(0xffC9E4D0),
                                radius: 40,
                                child: Icon(
                                  CustomIcons.card_giftcard,
                                  size: 35.0,
                                  color: Color(0xff1B3823),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Text('Renew points',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          color: Color(0xff1B3823),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.normal))
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ))
        ]),
      ),
    );
  }
}
