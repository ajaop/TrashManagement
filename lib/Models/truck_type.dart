class TruckType {
  String truckImg;
  String? truckName;
  String? truckMinSize;
  String? truckMaxSize;
  String? amount;

  TruckType(
      {required this.truckImg,
      required this.truckName,
      required this.truckMinSize,
      required this.truckMaxSize,
      required this.amount});

       Map<String, dynamic> createMap() {
    return {
      'TruckImg': truckImg,
      'TruckName': truckName,
      'TruckMinSize': truckMinSize,
      'TruckMaxSize': truckMaxSize,
      'Amount': amount
    };
  }

  TruckType.fromFirestore(Map<String, dynamic> firestoreMap)
      : truckImg = firestoreMap['TruckImg'],
        truckName = firestoreMap['TruckName'],
        truckMinSize = firestoreMap['TruckMinSize'],
        truckMaxSize = firestoreMap['TruckMaxSize'],
        amount = firestoreMap['Amount'];
}
