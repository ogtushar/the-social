import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constantColors.dart';
import 'package:the_social/screens/LandingScreen/landingHelpers.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ConstantColors _constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _constantColors.whiteColor,
      body: Stack(
        children: [
          bodyColor(context),
          Provider.of<LandingHelper>(context, listen: false).bodyImage(context),
          Provider.of<LandingHelper>(context, listen: false)
              .taglineText(context),
          Provider.of<LandingHelper>(context, listen: false)
              .mainButtons(context),
          Provider.of<LandingHelper>(context, listen: false)
              .privacyText(context),
        ],
      ),
    );
  }

  bodyColor(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.5, 0.9],
          colors: [
            _constantColors.darkColor,
            _constantColors.blueGreyColor,
          ],
        ),
      ),
    );
  }
}
