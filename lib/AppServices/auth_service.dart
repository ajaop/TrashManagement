import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../AuthenticationFeature/signup.dart';
import '../Models/user_details.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  bool doesExist = true;

  AuthService() {
    user = auth.currentUser;
  }

  Future<void> register(firstName, lastName, emailText, phoneNumber, pass,
      gender, profileUrl, context, _messangerKey) async {
    try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: emailText,
    password: pass,
  );
      bool addData = await sendToDB(
          firstName, lastName, emailText, phoneNumber, gender, profileUrl);

      if (addData == true) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/homepage', (Route<dynamic> route) => false);
      } else {
        auth.signOut();
        error('Error signing up user.', _messangerKey);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error('The password provided is too weak.', _messangerKey);
      } else if (e.code == 'email-already-in-use') {
        final User? user = auth.currentUser;
        if (user!.uid.isNotEmpty) {
          bool userExist = await doesUserExist(user.uid, _messangerKey);
          if (userExist == true) {
            error('The account already exists for that email.', _messangerKey);
          } else {
            bool addData = await sendToDB(firstName, lastName, emailText,
                phoneNumber, gender, profileUrl);
            print('add data ${addData.toString()}');
            if (addData == true) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/homepage', (Route<dynamic> route) => false);
            } else {
              auth.signOut();
              error('Error signing up user.', _messangerKey);
            }
          }
        } else {
          error('The account already exists for that email.', _messangerKey);
        }
      } else if (e.code == 'invalid-email') {
        error('Invalid Email', _messangerKey);
      } else if (e.code == 'network-request-failed') {
        error('Network Error', _messangerKey);
      } else {
        error(e.message, _messangerKey);
        print(e);
      }
    } catch (e) {
      error(e, _messangerKey);
    }
  }

  Future<void> login(username, pass, context, _messangerKey) async {
    final userDet = UserDetails.signin(email: username, password: pass);
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth
          .signInWithEmailAndPassword(email: username, password: pass)
          .then((value) async {
        user = auth.currentUser;
        bool userExist = await doesUserExist(user!.uid, _messangerKey);
        if (userExist == true) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/homepage', (Route<dynamic> route) => false);
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SignUp(),
                  settings: RouteSettings(arguments: userDet)));
        }
      });

      dynamic id = user!.uid;
      print("User with $id is logged in");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-email') {
        print('No user found');
        error('Wrong email or password.', _messangerKey);
      } else if (e.code == 'too-many-requests') {
        error(
            'Account has been temporarily disabled due to too many failed attempts.',
            _messangerKey);
      } else if (e.code == 'network-request-failed') {
        error('Network Error', _messangerKey);
      } else {
        print(e.code);
        error(e.message, _messangerKey);
      }
    }
  }

  Future<bool> sendToDB(
      firstname, lastname, email, phoneNumber, gender, profileUrl) async {
    final User? user = auth.currentUser;
    if (user!.uid.isNotEmpty) {
      try {
        DocumentReference<Map<String, dynamic>> users =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        UserDetails userDetails = UserDetails(
            firstname: firstname,
            lastname: lastname,
            email: email,
            phoneNumber: phoneNumber,
            gender: gender,
            profileImageUrl: profileUrl,
            points: 0,
            userId: user.uid,
            accountCreationDate: DateTime.now());

        await users.set(userDetails.createMap());
        return true;
      } catch (e) {
        return false;
      }
    }

    return false;
  }

  Future<bool> doesUserExist(String uid, messengerKey) async {
    try {
      final dynamic values = await FirebaseFirestore.instance
          .collection("users")
          .where('userId', isEqualTo: uid)
          .limit(1)
          .get();

      if (values.size >= 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      error(e.toString(), messengerKey);
      return false;
    }
  }

  bool checkIfLoggedIn(context, messengerKey) {
    final User? user = auth.currentUser;

    if (user?.uid.isEmpty == null) {
      return false;
    } else {
      return true;
    }
  }

  void error(errorMessage, _messangerKey) {
    _messangerKey.currentState!.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
        duration: const Duration(seconds: 5),
        elevation: 0,
        content: Text(
          errorMessage,
          textAlign: TextAlign.center,
        )));

    Timer(Duration(seconds: 5), () {
      _messangerKey.currentState!.hideCurrentSnackBar();
    });
  }
}
