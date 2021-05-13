import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_social/constants/constantColors.dart';
import 'package:the_social/screens/HomeScreen/homeScreen.dart';
import 'package:the_social/screens/LandingScreen/landingScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ConstantColors _constantColors = ConstantColors();

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        PageTransition(
          child: FirebaseAuth.instance.currentUser != null
              ? HomeScreen()
              : LandingPage(),
          type: PageTransitionType.leftToRight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _constantColors.darkColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: RichText(
            text: TextSpan(
              text: "The",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: _constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "Social",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Poppins',
                    color: _constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
