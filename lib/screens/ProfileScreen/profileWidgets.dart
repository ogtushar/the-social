import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_social/constants/constantColors.dart';

class ProfileWidgetsProvider extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget getProfileHeader(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    Map<String, dynamic> data = snapshot.data.data();
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        color: constantColors.whiteColor.withOpacity(0.1),
                        height: 120,
                        width: 120,
                        child: Image.network(
                          data['profileImageURL'].toString(),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 60,
                          width: 70,
                          decoration: BoxDecoration(
                            color: constantColors.whiteColor.withOpacity(0.1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data['followers'].toString(),
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Followers',
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 70,
                          decoration: BoxDecoration(
                            color: constantColors.whiteColor.withOpacity(0.1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data['following'].toString(),
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Following',
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 60,
                      width: 70,
                      decoration: BoxDecoration(
                        color: constantColors.whiteColor.withOpacity(0.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data['posts'].toString(),
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'posts',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            child: Text(
              '@' + data['userEmail'].toString().split('@')[0],
              style: TextStyle(
                color: constantColors.whiteColor,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getRecent(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.userAstronaut,
                color: constantColors.yellowColor,
                size: 16,
              ),
              SizedBox(width: 10),
              Text(
                'Recently Added',
                style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.whiteColor.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget getAllPosts(BuildContext context) {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    return StreamBuilder<QuerySnapshot>(
      stream: posts
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .orderBy('uploadedAt')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Image.asset('assets/images/empty.png'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        List _userPosts = snapshot.data.docs.map((doc) => doc).toList();
        if (_userPosts.length == 0) {
          return Container(
            child: Image.asset('assets/images/empty.png'),
          );
        }
        _userPosts = _userPosts.reversed.toList();
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: GridView.builder(
              clipBehavior: Clip.none,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: _userPosts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.6,
                crossAxisCount: 3,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 6.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GridTile(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: InkWell(
                      onTap: () => {},
                      child: Hero(
                        tag: _userPosts[index]['caption'],
                        child: Image.network(
                          _userPosts[index]['postImageUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
