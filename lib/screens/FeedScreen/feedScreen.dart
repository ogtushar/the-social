import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constantColors.dart';
import 'package:the_social/screens/FeedScreen/feedUtils.dart';
import 'package:the_social/screens/FeedScreen/feedWidgets.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  ConstantColors constantColors = ConstantColors();

  @override
  void initState() {
    Provider.of<FeedUtilsProvider>(context, listen: false).getAllFollowing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: constantColors.blueGreyColor,
        leading: IconButton(
          icon: Icon(EvaIcons.plusCircleOutline, size: 30),
          onPressed: () {
            Provider.of<FeedWidgetsProvider>(context, listen: false)
                .showUploadPostSheet(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(EvaIcons.messageCircleOutline),
            onPressed: () {},
          ),
        ],
        title: RichText(
          text: TextSpan(
            text: 'Social',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: ' Feed',
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
      body: Provider.of<FeedWidgetsProvider>(context, listen: false)
          .getUserPosts(context),
    );
  }
}
