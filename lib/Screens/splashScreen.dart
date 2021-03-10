import 'package:flutter/material.dart';
import 'package:flutter_app/backEnd/sizeConfig.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  DateTime currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Hero(
            tag: 'logo',
            child: Container(
              width: screenSize.screenWidth * 50,
              height: screenSize.screenHeight * 50,
              child: Image.asset(
                "images/media/logo.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ));
  }
}
