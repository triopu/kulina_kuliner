import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kulinakuliner/modules/home/views/home.dart';

class AnimateSplash extends StatefulWidget {
  @override
  _AnimateSplashState createState() => _AnimateSplashState();
}

class _AnimateSplashState extends State<AnimateSplash> {
  Tween<double> tween = Tween(begin: 0.0, end: 1.0);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Center(
        child: TweenAnimationBuilder(
          duration: const Duration(seconds: 3),
          tween: tween,
          builder: (BuildContext context, double opacity, Widget child) {
            return Opacity(
              opacity: opacity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: size.width * 0.26,
                  ),
                ],
              ),
            );
          },
          onEnd: () {
            Get.off(HomeScreen());
          },
        ),
      ),
    );
  }
}
