import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AuthenticationFeature/signup.dart';

class OnboardingAnimation extends StatelessWidget {
  OnboardingAnimation({Key? key, required this.controller})
      : opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.0,
              0.100,
              curve: Curves.ease,
            ),
          ),
        ),
        width = Tween<double>(
          begin: 50.0,
          end: double.infinity,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.125,
              0.250,
              curve: Curves.ease,
            ),
          ),
        ),
        height = Tween<double>(begin: 50.0, end: 450.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.250,
              0.575,
              curve: Curves.ease,
            ),
          ),
        ),
        alignment = AlignmentTween(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.125,
              0.750,
              curve: Curves.ease,
            ),
          ),
        ),
        padding = EdgeInsetsTween(
          begin: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 300.0),
          end: const EdgeInsets.only(bottom: 10.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.250,
              0.375,
              curve: Curves.ease,
            ),
          ),
        ),
        borderRadius = BorderRadiusTween(
          begin: BorderRadius.circular(20.0),
          // end: BorderRadius.circular(75.0),
          end: BorderRadius.only(
              bottomLeft: Radius.circular(75.0),
              bottomRight: Radius.circular(75.0)),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.375,
              0.500,
              curve: Curves.ease,
            ),
          ),
        ),
        color = ColorTween(
          begin: Color(0xff5D5D5D),
          end: Color(0xff151515),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.500,
              0.850,
              curve: Curves.ease,
            ),
          ),
        ),
        textAnim = CurvedAnimation(
          parent: controller,
          curve: Curves.easeIn,
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<BorderRadius?> borderRadius;
  final Animation<Color?> color;
  final Animation<Alignment> alignment;
  final Animation<double> textAnim;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    _storeOnboardInfo() async {
      int isViewed = 1;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('onBoard', isViewed);
    }

    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Container(
              padding: padding.value,
              alignment: alignment.value,
              child: Opacity(
                opacity: opacity.value,
                child: Container(
                  width: width.value,
                  height: height.value,
                  decoration: BoxDecoration(
                    color: color.value,
                    borderRadius: borderRadius.value,
                    image: DecorationImage(
                      image: AssetImage('images/onboarding_img.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )),
        ),
        Expanded(
            child: FadeTransition(
          opacity: textAnim,
          child: ListView(
            children: [
              const SizedBox(
                height: 40.0,
              ),
              const Align(
                  child: Text(
                'Be a recycler, Be a saver',
                style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.w800),
              )),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: const Align(
                    child: Text(
                        'Hire us today, so you can recycle for a better tomorrow.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w300))),
              ),
              SizedBox(
                height: 80.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF2E5F3B),
                        minimumSize: const Size.fromHeight(65),
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      _storeOnboardInfo();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const SignUp())));
                    },
                    child: const Text('Get Started')),
              )
            ],
          ),
        ))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
