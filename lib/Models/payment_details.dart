class PaymentDetails {
  String amount;
  String refNumber;
  String paymentDate;
  String paymentChannel;
  String? formattedPaymentDate;

  PaymentDetails({
    required this.amount,
    required this.refNumber,
    required this.paymentDate,
    required this.paymentChannel,
    required this.formattedPaymentDate
  });

   Map<String, dynamic> createMap() {
    return {
      'Amount': amount,
      'RefNumber': refNumber,
      'PaymentDate': paymentDate,
      'PaymentChannel': paymentChannel
    };
  }

  PaymentDetails.fromFirestore(Map<String, dynamic> firestoreMap)
      : amount = firestoreMap['Amount'],
        refNumber = firestoreMap['RefNumber'],
        paymentDate = firestoreMap['PaymentDate'],
        paymentChannel = firestoreMap['PaymentChannel'];

}
