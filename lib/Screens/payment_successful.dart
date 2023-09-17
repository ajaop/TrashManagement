import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

import '../Models/payment_details.dart';

class PaymentSuccessful extends StatefulWidget {
  const PaymentSuccessful({Key? key, required this.paymentDetails}) : super(key: key);

  final PaymentDetails paymentDetails;

  @override
  State<PaymentSuccessful> createState() => _PaymentSuccessfulState();
}

class _PaymentSuccessfulState extends State<PaymentSuccessful> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xffA2D1AE),
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
      ),
      home: Scaffold(
          body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                margin: EdgeInsets.all(15.0),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 65,
                        backgroundColor: Color(0xffC9E4D0),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Color(0xffA2D1AE),
                          child: CircleAvatar(
                            radius: 42.0,
                            backgroundColor: Color(0xff7BBE8C),
                            child: CircleAvatar(
                              backgroundColor: Color(0xff1B3823),
                              radius: 30.0,
                              child: Icon(
                                SolarIconsOutline.unread,
                                size: 60.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text('Payment Successful',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  color: Color(0xff1B3823),
                                  fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text('Your payment has been Successful',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Color(0xff1B3823),
                                  fontSize: 17.0,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w300)),
                      SizedBox(
                        height: 15.0,
                      ),
                      Divider(
                        thickness: 1.0,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text('Total Payment',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Color(0xff1B3823),
                                  fontSize: 18.0,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(widget.paymentDetails.amount,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  color: Color(0xff1B3823),
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Divider(
                        thickness: 1.0,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Ref Number:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Color(0xff1B3823),
                                      fontSize: 0.044 * screenWidth,
                                      fontWeight: FontWeight.normal)),
                          Text(widget.paymentDetails.refNumber,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Color(0xff1B3823),
                                      fontSize: 0.044 * screenWidth,
                                      fontWeight: FontWeight.w600))
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Payment Time:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Color(0xff1B3823),
                                      fontSize: 0.044 * screenWidth,
                                      fontWeight: FontWeight.normal)),
                          Text(widget.paymentDetails.formattedPaymentDate!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Color(0xff1B3823),
                                      fontSize: 0.044 * screenWidth,
                                      fontWeight: FontWeight.w600))
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Payment Method:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Color(0xff1B3823),
                                      fontSize: 0.044 * screenWidth,
                                      fontWeight: FontWeight.normal)),
                          Text(widget.paymentDetails.paymentChannel,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Color(0xff1B3823),
                                      fontSize: 0.044 * screenWidth,
                                      fontWeight: FontWeight.w600))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 60.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xff19433C),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                minimumSize: const Size.fromHeight(60),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(
                                        fontSize: 20.0, color: Colors.white)),
                            onPressed: () {},
                            child: const Text('Track Pickup')),
                        SizedBox(
                          height: 20.0,
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              primary: Color(0xff19433C),
                              side: BorderSide(
                                  width: 1.2, color: Color(0xff19433C)),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              )),
                              minimumSize: const Size.fromHeight(60),
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(
                                      fontSize: 20.0, color: Colors.white)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Done'),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
