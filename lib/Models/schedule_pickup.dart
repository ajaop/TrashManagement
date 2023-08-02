import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trash_management/Models/truck_type.dart';

class SchedulePickup {
  String? locationName;
  String? locationAddress;
  double? locationLat;
  double? locationLng;
  TruckType? wasteTruck;
  DateTime? pickupDate;
  String userId;

  SchedulePickup(
      {required this.locationName,
      required this.locationAddress,
      required this.locationLat,
      required this.locationLng,
      required this.wasteTruck,
      required this.pickupDate,
      required this.userId});

  Map<String, dynamic> createMap() {
    return {
      'LocationName': locationName,
      'LocationAddress': locationAddress,
      'LocationLat': locationLat,
      'LocationLng': locationLng,
      'WasteTruck': wasteTruck,
      'PickupDate': pickupDate,
      'UserId': userId
    };
  }

  SchedulePickup.fromFirestore(Map<String, dynamic> firestoreMap)
      : locationName = firestoreMap['LocationName'],
        locationAddress = firestoreMap['LocationAddress'],
        locationLat = firestoreMap['LocationLat'],
        locationLng = firestoreMap['LocationLng'],
        wasteTruck = firestoreMap['WasteTruck'],
        pickupDate = firestoreMap['PickupDate'].toDate(),
        userId = firestoreMap['UserId'];
}
