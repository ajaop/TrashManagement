
import 'package:trash_management/Models/truck_type.dart';

class PickupDetails {
  String? locationName;
  String? locationAddress;
  double? locationLat;
  double? locationLng;
  TruckType? wasteTruck;
  DateTime? pickupDate;
  String userId;

  PickupDetails(
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
      'WasteTruck': wasteTruck!.createMap(),
      'PickupDate': pickupDate,
      'UserId': userId
    };
  }

  PickupDetails.fromFirestore(Map<String, dynamic> firestoreMap)
      : locationName = firestoreMap['LocationName'],
        locationAddress = firestoreMap['LocationAddress'],
        locationLat = firestoreMap['LocationLat'],
        locationLng = firestoreMap['LocationLng'],
        wasteTruck = firestoreMap['WasteTruck'].reference.collection("Items").get().then((value) => value
            .docs
            .map((docSnapshot) =>
                TruckType.fromFirestore(docSnapshot))
            .toList()),
        pickupDate = firestoreMap['PickupDate'].toDate(),
        userId = firestoreMap['UserId'];
        
}
