import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constantColors.dart';
import 'package:the_social/screens/FeedScreen/feedScreen.dart';
import 'package:the_social/screens/HomeScreen/homeScreenHelper.dart';
import 'package:the_social/screens/NotificationsScreen/notificationScreen.dart';
import 'package:the_social/screens/ProfileScreen/profileScreen.dart';
import 'package:the_social/screens/SearchScreen/searchScreen.dart';
import 'package:the_social/services/firebaseOperations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ConstantColors constantColors;
  PageController _pageController;
  int _currentPage;

  _initData() async {
    await Provider.of<FirebaseOperations>(context, listen: false)
        .initUserData(context);
  }

  @override
  void initState() {
    _initData();
    super.initState();
    _currentPage = 0;
    constantColors = ConstantColors();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      body: PageView(
        controller: _pageController,
        children: [
          FeedScreen(),
          NotificationScreen(),
          SearchScreen(),
          ProfileScreen(),
        ],
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<HomeScreenHelper>(context).bottomNav(
        context,
        _currentPage,
        _pageController,
      ),
    );
  }
}
