import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_social/constants/constantColors.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: constantColors.blueGreyColor,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: constantColors.blueColor,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('followRequests')
            .where('followReqToId',
                isEqualTo: FirebaseAuth.instance.currentUser.uid.toString())
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return Column(
              children: [
                ...snapshot.data.docs.map(
                  (DocumentSnapshot doc) {
                    Map<String, dynamic> _noti = doc.data();
                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(_noti['followReqById'])
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                              vertical: 18,
                            ),
                            child: Text('Loading...'),
                          );
                        return ListTile(
                          onTap: () {},
                          title: Text(
                            snapshot.data['userEmail']
                                .toString()
                                .split('@')[0]
                                .toString(),
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Icon(
                                EvaIcons.emailOutline,
                                size: 20,
                                color: constantColors.yellowColor,
                              ),
                              SizedBox(width: 10),
                              Text(
                                snapshot.data['userEmail'],
                                style: TextStyle(
                                  color: constantColors.blueColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          leading: CircleAvatar(
                            backgroundColor: constantColors.transparent,
                            backgroundImage:
                                NetworkImage(snapshot.data['profileImageURL']),
                            radius: 25,
                          ),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.times,
                                    color: constantColors.redColor,
                                  ),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('followRequests')
                                        .where('followReqById',
                                            isEqualTo: snapshot.data['userId'])
                                        .where('followReqToId',
                                            isEqualTo: FirebaseAuth
                                                .instance.currentUser.uid
                                                .toString())
                                        .limit(1)
                                        .get()
                                        .then((doc) {
                                      for (DocumentSnapshot ds in doc.docs) {
                                        ds.reference.delete();
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.check,
                                    color: constantColors.greenColor,
                                  ),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('followings')
                                        .add({
                                      'followedBy': snapshot.data['userId'],
                                      'followingTo':
                                          FirebaseAuth.instance.currentUser.uid,
                                    }).whenComplete(() async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser.uid)
                                          .update({
                                        "followers": FieldValue.increment(1)
                                      }).whenComplete(() async {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(snapshot.data['userId'])
                                            .update({
                                          "following": FieldValue.increment(1)
                                        }).whenComplete(() async {
                                          await FirebaseFirestore.instance
                                              .collection('followRequests')
                                              .where('followReqById',
                                                  isEqualTo:
                                                      snapshot.data['userId'])
                                              .where('followReqToId',
                                                  isEqualTo: FirebaseAuth
                                                      .instance.currentUser.uid
                                                      .toString())
                                              .limit(1)
                                              .get()
                                              .then((doc) {
                                            for (DocumentSnapshot ds
                                                in doc.docs) {
                                              ds.reference.delete();
                                            }
                                          });
                                        });
                                      });
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          }
          return Center(
            child: Text(
              'Something went wrong...',
              style: TextStyle(
                color: constantColors.whiteColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
