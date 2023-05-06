import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'AppServices/auth_service.dart';
import 'AuthenticationFeature/signin.dart';
import 'AuthenticationFeature/signup.dart';
import 'homepage.dart';
import 'onboarding.dart';

int? isviewed;
Future<void> main() async {
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

    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => isviewed == 0 || isviewed == null
          ? const OnBoardingPage()
          : authService.checkIfLoggedIn2(context)
              ? HomePage()
              : SignIn(),
      '/homepage': (context) => const HomePage(),
      '/signup': (context) => const SignUp(),
    });
  }
}
