import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constantColors.dart';
import 'package:the_social/screens/HomeScreen/homeScreen.dart';
import 'package:the_social/screens/LandingScreen/landingUtils.dart';
import 'package:the_social/services/authService.dart';
import 'package:the_social/services/firebaseOperations.dart';

class LandingService extends ChangeNotifier {
  final ConstantColors _constantColors = ConstantColors();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  emailLogInSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
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
              Text(
                "Log In",
                style: TextStyle(
                  color: _constantColors.whiteColor,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter Email...',
                        hintStyle: TextStyle(
                          color: _constantColors.whiteColor,
                        ),
                      ),
                      style: TextStyle(
                        color: _constantColors.whiteColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter Password...',
                        hintStyle: TextStyle(color: _constantColors.whiteColor),
                      ),
                      style: TextStyle(color: _constantColors.whiteColor),
                    ),
                    SizedBox(height: 30),
                    MaterialButton(
                      color: _constantColors.blueColor,
                      onPressed: () {
                        if (_emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty) {
                          Provider.of<AuthService>(context, listen: false)
                              .logIn(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          )
                              .whenComplete(() {
                            final String uid =
                                Provider.of<AuthService>(context, listen: false)
                                    .getUserId;
                            if (uid.isNotEmpty) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  PageTransition(
                                    child: HomeScreen(),
                                    type: PageTransitionType.leftToRight,
                                  ),
                                  (page) => page == null);
                            }
                            _emailController.text = '';
                            _passwordController.text = '';
                          });
                        }
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
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  emailSignInSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: BoxDecoration(
            color: _constantColors.blueGreyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
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
                  Text(
                    "Sign In",
                    style: TextStyle(
                      color: _constantColors.whiteColor,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Stack(
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          onTap: () {
                            Provider.of<LandingUtils>(context, listen: false)
                                .pickUserAvatar(context, ImageSource.gallery);
                          },
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              color: _constantColors.transparent,
                              border: Border.all(
                                  width: 1, color: _constantColors.whiteColor),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child:
                                Provider.of<LandingUtils>(context, listen: true)
                                            .getUserAvatar ==
                                        null
                                    ? Center(
                                        child: Text(
                                          'Tap to add Image...',
                                          style: TextStyle(
                                            color: _constantColors.whiteColor,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 75,
                                        backgroundImage: FileImage(
                                          Provider.of<LandingUtils>(context,
                                                  listen: false)
                                              .getUserAvatar,
                                        ),
                                      ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 50,
                          width: 50,
                          child: FloatingActionButton(
                            backgroundColor: _constantColors.blueGreyColor,
                            onPressed: () {
                              Provider.of<LandingUtils>(context, listen: false)
                                  .pickUserAvatar(context, ImageSource.gallery);
                            },
                            child: Icon(
                              FontAwesomeIcons.camera,
                              color: _constantColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter Email...',
                            hintStyle: TextStyle(
                              color: _constantColors.whiteColor,
                            ),
                          ),
                          style: TextStyle(
                            color: _constantColors.whiteColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Enter Password...',
                            hintStyle:
                                TextStyle(color: _constantColors.whiteColor),
                          ),
                          style: TextStyle(color: _constantColors.whiteColor),
                        ),
                        SizedBox(height: 30),
                        MaterialButton(
                          color: _constantColors.redColor,
                          onPressed: () {
                            if (_emailController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty) {
                              Provider.of<AuthService>(context, listen: false)
                                  .signUp(
                                context: context,
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              )
                                  .whenComplete(() {
                                Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .createUser(context, {
                                  'userId': Provider.of<AuthService>(context,
                                          listen: false)
                                      .getUserId,
                                  'userEmail': _emailController.text.trim(),
                                  'createdAt': DateTime.now().toIso8601String(),
                                  'profileImageURL': Provider.of<LandingUtils>(
                                          context,
                                          listen: false)
                                      .getUserAvatarUrl,
                                  'accountType': 0,
                                  'posts': 0,
                                  'followers': 0,
                                  'following': 0,
                                });
                              }).whenComplete(
                                () {
                                  final String uid = Provider.of<AuthService>(
                                          context,
                                          listen: false)
                                      .getUserId;
                                  if (uid.isNotEmpty) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      PageTransition(
                                        child: HomeScreen(),
                                        type: PageTransitionType.leftToRight,
                                      ),
                                      (value) => false,
                                    );
                                  }
                                  _emailController.text = '';
                                  _passwordController.text = '';
                                },
                              );
                            }
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
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
