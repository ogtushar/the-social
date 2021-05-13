import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constantColors.dart';
import 'package:the_social/screens/LandingScreen/landingScreen.dart';
import 'package:the_social/screens/ProfileScreen/profileWidgets.dart';
import 'package:the_social/services/authService.dart';
import 'package:the_social/services/firebaseOperations.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: constantColors.blueGreyColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(EvaIcons.settings, color: constantColors.blueColor),
          onPressed: () {},
        ),
        title: RichText(
          text: TextSpan(
            text: 'My',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: constantColors.whiteColor,
              fontSize: 20.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: constantColors.blueColor,
                  fontSize: 20.0,
                ),
              )
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              EvaIcons.logOut,
              color: constantColors.greenColor,
            ),
            onPressed: () {
              Provider.of<FirebaseOperations>(context, listen: false)
                          .userData['accountType'] ==
                      0
                  ? Provider.of<AuthService>(context, listen: false)
                      .signOutWithEmailAndPassword()
                  : Provider.of<AuthService>(context, listen: false)
                      .signOutWithGoogle();
              Navigator.of(context).pushAndRemoveUntil(
                  PageTransition(
                      child: LandingPage(),
                      type: PageTransitionType.rightToLeft),
                  (route) => false);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: constantColors.blueGreyColor,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    Provider.of<ProfileWidgetsProvider>(context, listen: false)
                        .getProfileHeader(context, snapshot),
                    Divider(
                      indent: 10,
                      endIndent: 10,
                      color: constantColors.whiteColor,
                    ),
                    Provider.of<ProfileWidgetsProvider>(context, listen: false)
                        .getRecent(context),
                    Provider.of<ProfileWidgetsProvider>(context, listen: false)
                        .getAllPosts(context),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
