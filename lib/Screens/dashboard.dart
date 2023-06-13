import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

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
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundColor: Color(0xffEEF7F0),
                  child: Image.asset(
                    'images/man1.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ],
        ))
      ]),
    );
  }
}
