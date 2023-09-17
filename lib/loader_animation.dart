import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoaderAnimation extends StatelessWidget {
  LoaderAnimation({Key? key, required this.controller})
      : height = TweenSequence(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: Tween(begin: 80.0, end: 120.0)
                  .chain(CurveTween(curve: Curves.ease)),
              weight: 50.0,
            ),
            TweenSequenceItem<double>(
              tween: Tween(begin: 120.0, end: 80.0)
                  .chain(CurveTween(curve: Curves.ease)),
              weight: 20.0,
            ),
          ],
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.150,
              0.950,
              curve: Curves.ease,
            ),
          ),
        ),
        height2 = TweenSequence(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: Tween(begin: 80.0, end: 30.0)
                  .chain(CurveTween(curve: Curves.easeOut)),
              weight: 50.0,
            ),
            TweenSequenceItem<double>(
              tween: Tween(begin: 30.0, end: 80.0)
                  .chain(CurveTween(curve: Curves.easeIn)),
              weight: 20.0,
            ),
          ],
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.150,
              0.950,
              curve: Curves.ease,
            ),
          ),
        ),
        spacingHeight = TweenSequence(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: Tween(begin: 15.0, end: 0.0)
                  .chain(CurveTween(curve: Curves.easeOut)),
              weight: 50.0,
            ),
            TweenSequenceItem<double>(
              tween: Tween(begin: 0.0, end: 15.0)
                  .chain(CurveTween(curve: Curves.easeIn)),
              weight: 50.0,
            ),
          ],
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.250,
              0.750,
              curve: Curves.ease,
            ),
          ),
        ),
        slide1 = TweenSequence(
          <TweenSequenceItem<Offset>>[
            TweenSequenceItem<Offset>(
              tween: Tween(begin: const Offset(0, 0), end: const Offset(0, 0.6))
                  .chain(CurveTween(curve: Curves.easeOut)),
              weight: 80.0,
            ),
            TweenSequenceItem<Offset>(
              tween: Tween(begin: const Offset(0, 0.6), end: const Offset(0, 0))
                  .chain(CurveTween(curve: Curves.easeIn)),
              weight: 20.0,
            ),
          ],
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.280,
              0.850,
              curve: Curves.ease,
            ),
          ),
        ),
        slide2 = TweenSequence(
          <TweenSequenceItem<Offset>>[
            TweenSequenceItem<Offset>(
              tween:
                  Tween(begin: const Offset(0, 0), end: const Offset(0, -0.6))
                      .chain(CurveTween(curve: Curves.easeOut)),
              weight: 80.0,
            ),
            TweenSequenceItem<Offset>(
              tween:
                  Tween(begin: const Offset(0, -0.6), end: const Offset(0, 0))
                      .chain(CurveTween(curve: Curves.easeIn)),
              weight: 20.0,
            ),
          ],
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.280,
              0.850,
              curve: Curves.ease,
            ),
          ),
        ),
        rotationAnim = CurvedAnimation(
          parent: controller,
          curve: const Interval(
            0.56,
            0.99,
            curve: Curves.ease,
          ),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> height;
  final Animation<double> height2;
  final Animation<double> spacingHeight;
  final Animation<Offset> slide1;
  final Animation<Offset> slide2;
  final Animation<double> rotationAnim;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return RotationTransition(
      turns: rotationAnim,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 65.0,
                height: height2.value,
                decoration: BoxDecoration(
                  color: Color(0xFF19433C),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              SizedBox(
                height: spacingHeight.value,
              ),
              SlideTransition(
                position: slide2,
                child: Container(
                  width: 65.0,
                  height: height.value,
                  decoration: BoxDecoration(
                    color: Color(0xFF19433C),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
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
              SlideTransition(
                position: slide1,
                child: Container(
                  width: 65.0,
                  height: height.value,
                  decoration: BoxDecoration(
                    color: Color(0xFF19433C),
                    borderRadius: BorderRadius.circular(20.0),
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
                  color: Color(0xFF19433C),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              )
            ],
          ),
        ],
      ),
    );
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
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 1300), vsync: this);

    _playAnimation();
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.forward();
      _controller.repeat(reverse: false);
    } on TickerCanceled {
      // the animation got canceled, probably because it was disposed of
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderAnimation(controller: _controller);
  }
}
