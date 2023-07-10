import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trash_management/AppServices/database_service.dart';
import 'package:trash_management/Models/search_location.dart';
import 'package:trash_management/Models/user_details.dart';
import 'firebase_options.dart';
import 'AppServices/auth_service.dart';
import 'AuthenticationFeature/signin.dart';
import 'AuthenticationFeature/signup.dart';
import 'Screens/homepage.dart';
import 'OnboardingFeature/onboarding.dart';
import 'package:provider/provider.dart';

final _messangerKey = GlobalKey<ScaffoldMessengerState>();
int? isviewed;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    DatabaseService databaseService = DatabaseService();
    UserDetails initial = UserDetails.dashboard();

    // authService.auth.signOut();
    return MultiProvider(
      providers: [
        StreamProvider<UserDetails>(
          create: (context) => databaseService.getUserDetails(),
          initialData: initial,
        ),
        ChangeNotifierProvider<SearchLocation>(
          create: (context) => SearchLocation(false),
        )
      ],
      child: MaterialApp(
          scaffoldMessengerKey: _messangerKey,
          initialRoute: '/',
          routes: {
            '/': (context) => isviewed == 0 || isviewed == null
                ? const OnboardingPage()
                : authService.checkIfLoggedIn(context, _messangerKey)
                    ? HomePage()
                    : SignIn(),
            '/homepage': (context) => const HomePage(),
            '/signup': (context) => const SignUp(),
            '/signin': (context) => const SignIn(),
          }),
    );
  }
}
