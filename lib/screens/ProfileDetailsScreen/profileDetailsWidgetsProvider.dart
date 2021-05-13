import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constantColors.dart';
import 'package:the_social/screens/ProfileDetailsScreen/profileDetailsProvider.dart';

class ProfileDetailsWidgetsProvider extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget getProfileHeader(BuildContext context, Map<String, dynamic> data) {
    return Container(
      height: data['userId'] != FirebaseAuth.instance.currentUser.uid
          ? MediaQuery.of(context).size.height * 0.32
          : MediaQuery.of(context).size.height * 0.25,
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
                    SizedBox(height: 10),
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
          SizedBox(height: 10),
          data['userId'] != FirebaseAuth.instance.currentUser.uid
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Provider.of<ProfileDetailsProvider>(context)
                            .isFollowReqSent
                            .docs
                            .isEmpty
                        ? Provider.of<ProfileDetailsProvider>(context)
                                .isFollowing
                                .docs
                                .isEmpty
                            ? MaterialButton(
                                onPressed: () {
                                  Provider.of<ProfileDetailsProvider>(context,
                                          listen: false)
                                      .addFollowRequest(
                                    context,
                                    FirebaseAuth.instance.currentUser.uid
                                        .toString(),
                                    data['userId'],
                                  )
                                      .whenComplete(() {
                                    Provider.of<ProfileDetailsProvider>(context,
                                            listen: false)
                                        .getFollowDetails(data);
                                  });
                                },
                                child: Text(
                                  'Follow',
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                color: constantColors.greenColor,
                              )
                            : MaterialButton(
                                onPressed: () {},
                                child: Text(
                                  'Unfollow',
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                color: constantColors.redColor,
                              )
                        : MaterialButton(
                            onPressed: () {
                              Provider.of<ProfileDetailsProvider>(context,
                                      listen: false)
                                  .removeFollowRequest(
                                context,
                                FirebaseAuth.instance.currentUser.uid
                                    .toString(),
                                data['userId'],
                              )
                                  .whenComplete(() {
                                Provider.of<ProfileDetailsProvider>(context,
                                        listen: false)
                                    .getFollowDetails(data);
                              });
                            },
                            child: Text(
                              'Cancel follow request',
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            color: constantColors.redColor,
                          ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

    Widget getAllPosts(BuildContext context, String uid) {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    return StreamBuilder<QuerySnapshot>(
      stream: posts
          .where('userId', isEqualTo: uid)
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
