import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constantColors.dart';
import 'package:the_social/screens/ProfileDetailsScreen/profileDetailsProvider.dart';

import 'profileDetailsWidgetsProvider.dart';

class ProfileDetailScreen extends StatefulWidget {
  final Map<String, dynamic> userProfileData;

  const ProfileDetailScreen({Key key, @required this.userProfileData})
      : super(key: key);
  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  ConstantColors _constantColors = ConstantColors();

  @override
  void initState() {
    Provider.of<ProfileDetailsProvider>(context, listen: false)
        .getFollowDetails(widget.userProfileData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _constantColors.blueGreyColor,
      appBar: AppBar(
        backgroundColor: _constantColors.blueGreyColor,
        iconTheme: IconThemeData(
          color: _constantColors.whiteColor,
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: _constantColors.blueGreyColor,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Provider.of<ProfileDetailsWidgetsProvider>(context,
                        listen: false)
                    .getProfileHeader(context, widget.userProfileData),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  color: _constantColors.whiteColor,
                ),
                Provider.of<ProfileDetailsProvider>(context)
                        .isFollowing
                        .docs
                        .isEmpty
                    ? Container()
                    : Provider.of<ProfileDetailsWidgetsProvider>(context,
                            listen: false)
                        .getAllPosts(context, widget.userProfileData['userId']),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
