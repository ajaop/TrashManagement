import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trash_management/Models/schedule_pickup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../env/env.dart';

class PaymentService {
  final BuildContext context;
  final _messangerKey;
  final payStackClient;
  FirebaseAuth auth = FirebaseAuth.instance;

  PaymentService(this.context, this._messangerKey, this.payStackClient);

  void makePayment(BuildContext context, SchedulePickup schedulePickup,
      String fullName, String phoneNumber, String email) async {
    String amount =
        schedulePickup.wasteTruck!.amount!.replaceAll('₦', '').trim() + '00';
    int actualAmount = int.parse(amount);
    print(actualAmount);
    print(fullName);
    print(phoneNumber);
    print(email);

    final Charge charge = Charge()
      ..email = email
      ..amount = actualAmount
      ..reference = _getReference()
      ..accessCode =
          await _createAccessCode(_getReference(), actualAmount, email);

    final CheckoutResponse response = await payStackClient.checkout(context,
        charge: charge, method: CheckoutMethod.selectable);

    if (response.status) {
      _verifyOnServer(response.reference!);
    } else {
      error('Error Making Payment', _messangerKey);
    }
  }

  Future<bool> schedulePickupDate(SchedulePickup schedulePickup) async {
    final User? user = auth.currentUser;
    if (user!.uid.isNotEmpty) {
      try {
        DocumentReference<Map<String, dynamic>> pickup =
            FirebaseFirestore.instance.collection('waste_pickup').doc();
        // await pickup.set(schedulePickup.createMap());
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<String> _createAccessCode(_getReference, amount, email) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + Env.paystackSecretTestKey
    };
    Map data = {"amount": amount, "email": email, "reference": _getReference};
    String payload = json.encode(data);
    http.Response response = await http.post(
        Uri.parse('https://api.paystack.co/transaction/initialize'),
        headers: headers,
        body: payload);

    data = jsonDecode(response.body);
    String accessCode = data['data']['access_code'];
    return accessCode;
  }

  void _verifyOnServer(String reference) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + Env.paystackSecretTestKey
      };
      http.Response response = await http.get(
          Uri.parse('https://api.paystack.co/transaction/verify/' + reference),
          headers: headers);
      final Map body = json.decode(response.body);
      if (body['data']['status'] == 'success') {
        success('success', _messangerKey);
      } else {
        error('Error Making Payment', _messangerKey);
      }
    } catch (e) {
      error('Error Making Payment', _messangerKey);
      print(e);
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

    Timer(Duration(seconds: 2), () {
      _messangerKey.currentState!.hideCurrentSnackBar();
    });
  }

  void success(errorMessage, _messangerKey) {
    _messangerKey.currentState!.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 5),
        elevation: 0,
        content: Text(
          errorMessage,
          textAlign: TextAlign.center,
        )));

    Timer(Duration(seconds: 2), () {
      _messangerKey.currentState!.hideCurrentSnackBar();
    });
  }
}
