import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../AppServices/auth_service.dart';
import 'dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final AuthService authService = AuthService();
  int _index = 0;

  @override
  void initState() {
    super.initState();
    getDefaultValues();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = Container();
    switch (_index) {
      case 0:
        widget = const Dashboard();
        break;

      case 1:
        //widget = const Favourites();
        break;

      case 2:
        // widget = const Cart();
        break;

      case 3:
        // widget = const Profile();
        break;
    }

    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xffA2D1AE),
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
      ),
      home: Scaffold(
          body: widget,
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(50),
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
              topLeft: Radius.circular(50),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              unselectedItemColor: Colors.white,
              backgroundColor: Color(0xffA2D1AE),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: '',
                ),
              ],
              currentIndex: _index,
              onTap: (int index) => setState(() => _index = index),
              selectedItemColor: Color(0xff1B3823),
            ),
          )),
    );
  }

  void getDefaultValues() async {
    bool doesExist = await authService.doesUserExist(
        authService.auth.currentUser!.uid, _messangerKey);

    if (doesExist == false) {
      authService.auth.signOut();
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }
}
