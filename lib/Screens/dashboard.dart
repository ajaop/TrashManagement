import 'package:flutter/material.dart';
import 'package:trash_management/AppServices/database_service.dart';
import 'package:trash_management/Models/user_details.dart';
import 'package:trash_management/ShimmerFeature/shimmer.dart';
import 'package:trash_management/ShimmerFeature/shimmer_loading.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

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

class _DashboardState extends State<Dashboard> {
  bool _loading = true;
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  DatabaseService databaseService = DatabaseService();
  UserDetails userDetails = UserDetails.dashboard();

  @override
  void initState() {
    super.initState();
    getDefaultValues();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xffA2D1AE),
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
      ),
      home: Stack(children: [
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
                        size: 33.0,
                        color: Color(0xff1B3823),
                      ),
                      Positioned(
                          bottom: 18,
                          right: 5,
                          child: CircleAvatar(
                            backgroundColor: Colors.red[500],
                            radius: 5,
                          )),
                    ],
                  ),
                ],
              ),
              ShimmerLoading(
                isLoading: true,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Color(0xff1B3823)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: _loading
                        ? CircleAvatar(
                            radius: 40.0,
                            backgroundColor: Color(0xffEEF7F0),
                          )
                        : CircleAvatar(
                            radius: 40.0,
                            backgroundColor: Color(0xffEEF7F0),
                            child: Image.asset(
                              'work',
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ))
      ]),
    );
  }

  Future<void> getDefaultValues() async {
    await databaseService.getUserDetails();

    setState(() {
      _loading = false;
    });
  }
}
