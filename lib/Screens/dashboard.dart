import 'package:flutter/material.dart';
import 'package:trash_management/ShimmerFeature/shimmer.dart';
import 'package:trash_management/ShimmerFeature/shimmer_loading.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

const _shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Color(0xff1B3823)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ShimmerLoading(
                    isLoading: true,
                    child: CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Color(0xffEEF7F0),
                      child: Image.asset(
                        'images/man2.png',
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
}
