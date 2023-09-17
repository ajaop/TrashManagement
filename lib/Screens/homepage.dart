import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../AppServices/auth_service.dart';
import '../AppServices/database_service.dart';
import '../Models/user_details.dart';
import '../Provider/location_provider.dart';
import '../Provider/search_location.dart';
import 'dashboard.dart';
import 'package:solar_icons/solar_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final AuthService authService = AuthService();
  DatabaseService databaseService = DatabaseService();
  int _index = 0;

  @override
  void initState() {
    super.initState();
    getDefaultValues();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService = DatabaseService();
    UserDetails initial = UserDetails.dashboard();
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;

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

    return MultiProvider(
      providers: [
        StreamProvider<UserDetails>(
          create: (context) => databaseService.getUserDetails(),
          initialData: initial,
        ),
        ChangeNotifierProvider<SearchLocation>(
          create: (context) => SearchLocation(false),
        ),
        ChangeNotifierProvider<LocationProvider>(
          create: (context) => LocationProvider(),
        )
      ],
      child: MaterialApp(
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
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(screenWidth * 8.56),
                bottomLeft: Radius.circular(screenWidth * 8.56),
                bottomRight: Radius.circular(screenWidth * 8.56),
                topLeft: Radius.circular(screenWidth * 8.56),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: false,
                unselectedItemColor: Colors.white,
                backgroundColor: Color(0xffA2D1AE),
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(SolarIconsOutline.home), label: 'Home'),
                  BottomNavigationBarItem(
                    icon: Icon(SolarIconsOutline.wallet),
                    label: 'Wallet',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(SolarIconsOutline.user),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _index,
                onTap: (int index) => setState(() => _index = index),
                selectedItemColor: Color(0xff1B3823),
              ),
            )),
      ),
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
