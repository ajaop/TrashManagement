import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trash_management/Models/payment.dart';
import 'package:trash_management/Models/schedule_pickup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:trash_management/Screens/payment_successful.dart';
import 'package:intl/intl.dart';

import '../env/env.dart';

class PaymentService {
  final BuildContext context;
  final _messangerKey;
  final payStackClient;
  FirebaseAuth auth = FirebaseAuth.instance;

  PaymentService(this.context, this._messangerKey, this.payStackClient);

  double calculateTotal(subTotal, transportfee) {
    double sub =
        double.parse(subTotal.replaceAll(',', '').replaceAll('₦', '').trim());

    double transport = double.parse(
        transportfee.replaceAll(',', '').replaceAll('₦', '').trim());

    double total = sub + transport;
    return total;
  }

  Future<void> makePayment(BuildContext context, SchedulePickup schedulePickup,
      String fullName, String phoneNumber, String email, double total) async {
    String amount = total.toStringAsFixed(2).replaceAll('.', '');

    int actualAmount = int.parse(amount);

    final Charge charge = Charge()
      ..email = email
      ..amount = actualAmount
      ..reference = _getReference()
      ..accessCode =
          await _createAccessCode(_getReference(), actualAmount, email);

    final CheckoutResponse response = await payStackClient.checkout(context,
        charge: charge, method: CheckoutMethod.selectable);

    if (response.status) {
      await _verifyOnServer(response.reference!, total);
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
    String accessCode = '';
    try {
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
      accessCode = data['data']['access_code'];
    } catch (e) {
      error('Error Making Payment', _messangerKey);
    }

    return accessCode;
  }

  Future<void> _verifyOnServer(String reference, double total) async {
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
        String refNumber = body['data']['id'].toString();
        String channel = body['data']['authorization']['channel'];
        String amount = formatAmount(total);
        String date = body['data']['paid_at'].toString();
        String formattedPaymentDate = formatDate(date);
        Payment payment = Payment(
            amount: amount,
            refNumber: refNumber,
            paymentDate: formattedPaymentDate,
            paymentChannel: channel);

        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => PaymentSuccessful(
                    payment: payment,
                  )),
          ModalRoute.withName('/'),
        );
      } else {
        error('Error Making Payment', _messangerKey);
      }
    } catch (e) {
      error('Error Making Payment', _messangerKey);
      print(e);
    }
  }

  String formatDate(String date) {
    String formattedDate =
        DateFormat('dd-MM-yyyy, HH:mm:ss').format(DateTime.parse(date));
    return formattedDate;
  }

  String formatAmount(double amount) {
    String amt = "₦ " +
        amount.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");

    return amt;
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
