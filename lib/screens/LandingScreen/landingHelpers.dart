import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constantColors.dart';
import 'package:the_social/screens/HomeScreen/homeScreen.dart';
import 'package:the_social/screens/LandingScreen/landingService.dart';
import 'package:the_social/services/authService.dart';

class LandingHelper extends ChangeNotifier {
  final ConstantColors _constantColors = ConstantColors();

  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login.png"),
        ),
      ),
    );
  }

  Widget taglineText(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.65,
      left: 10.0,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 170.0,
        ),
        child: RichText(
          text: TextSpan(
            text: "Are ",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: _constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "You ",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Poppins',
                  color: _constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "Social ",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Poppins',
                  color: _constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "?",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Poppins',
                  color: _constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainButtons(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.85,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Material(
              borderRadius: BorderRadius.circular(10.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () => emailAndPasswordLogin(context),
                child: Container(
                  height: 40.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: _constantColors.yellowColor),
                    color: _constantColors.transparent,
                  ),
                  child: Center(
                      child: Icon(
                    EvaIcons.emailOutline,
                    color: _constantColors.yellowColor,
                  )),
                ),
              ),
            ),
            Material(
              borderRadius: BorderRadius.circular(10.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () async {
                  final res =
                      await Provider.of<AuthService>(context, listen: false)
                          .signInWithGoogle(context);
                  if (res != false) {
                    Navigator.of(context).pushAndRemoveUntil(
                      PageTransition(
                        child: HomeScreen(),
                        type: PageTransitionType.leftToRight,
                      ),
                      (page) => page == null
                    );
                  }
                },
                child: Container(
                  height: 40.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: _constantColors.redColor),
                    color: _constantColors.transparent,
                  ),
                  child: Center(
                    child: Icon(
                      EvaIcons.google,
                      color: _constantColors.redColor,
                    ),
                  ),
                ),
              ),
            ),
            Material(
              borderRadius: BorderRadius.circular(10.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () => null,
                child: Container(
                  height: 40.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: _constantColors.blueColor),
                    color: _constantColors.transparent,
                  ),
                  child: Center(
                      child: Icon(
                    EvaIcons.facebook,
                    color: _constantColors.blueColor,
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
      bottom: 10,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          "By continuing you agree theSocial's Terms \nof Services & Privacy Policy",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  emailAndPasswordLogin(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.12,
          decoration: BoxDecoration(
            color: _constantColors.blueGreyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  color: _constantColors.whiteColor,
                  thickness: 4.0,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: _constantColors.blueColor,
                    onPressed: () {
                      Provider.of<LandingService>(context, listen: false)
                          .emailLogInSheet(context);
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        color: _constantColors.whiteColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: _constantColors.redColor,
                    onPressed: () {
                      Provider.of<LandingService>(context, listen: false)
                          .emailSignInSheet(context);
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: _constantColors.whiteColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
