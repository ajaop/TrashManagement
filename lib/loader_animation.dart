import 'package:flutter/material.dart';

class LoaderAnimation extends StatelessWidget {
  LoaderAnimation({Key? key, required this.controller})
      : height = Tween<double>(begin: 80.0, end: 120.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.150,
              0.6,
              curve: Curves.ease,
            ),
          ),
        ),
        height2 = Tween<double>(begin: 80.0, end: 30.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.150,
              0.6,
              curve: Curves.ease,
            ),
          ),
        ),
        spacingHeight = Tween<double>(begin: 15.0, end: 0.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.150,
              0.6,
              curve: Curves.ease,
            ),
          ),
        ),
        anim2 =
            Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0.6))
                .animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.625,
              0.850,
              curve: Curves.ease,
            ),
          ),
        ),
        anim3 =
            Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -0.6))
                .animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.625,
              0.850,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> height;
  final Animation<double> height2;
  final Animation<double> spacingHeight;
  final Animation<Offset> anim2;
  final Animation<Offset> anim3;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    final Animation<double> anim1 =
        Tween<double>(begin: height.value, end: 70).animate(
      CurvedAnimation(
          parent: controller,
          curve: const Interval(
            0.625,
            0.850,
            curve: Curves.ease,
          )),
    );
    return Scaffold(
        body: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SlideTransition(
                position: anim2,
                child: Container(
                  height: anim1.value,
                  child: Container(
                    width: 65.0,
                    height: height.value,
                    decoration: BoxDecoration(
                      color: Color(0xFF2E5F3B),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: spacingHeight.value,
              ),
              Container(
                width: 65.0,
                height: height2.value,
                decoration: BoxDecoration(
                  color: Color(0xFF2E5F3B),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              )
            ],
          ),
          SizedBox(
            width: 15.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 65.0,
                height: height2.value,
                decoration: BoxDecoration(
                  color: Color(0xFF2E5F3B),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              SizedBox(
                height: spacingHeight.value,
              ),
              SlideTransition(
                position: anim3,
                child: Container(
                  height: anim1.value,
                  child: Container(
                    width: 65.0,
                    height: height.value,
                    decoration: BoxDecoration(
                      color: Color(0xFF2E5F3B),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
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

class Loader extends StatefulWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _playAnimation();
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
      await _controller.repeat(reverse: true).orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because it was disposed of
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: LoaderAnimation(controller: _controller)));
  }
}
