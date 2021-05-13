import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constantColors.dart';
import 'package:the_social/screens/SearchScreen/searchListProvider.dart';
import 'package:the_social/services/firebaseOperations.dart';

class HomeScreenHelper extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bottomNav(
      BuildContext context, int index, PageController pageController) {
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: constantColors.blueColor,
      unSelectedColor: constantColors.whiteColor,
      strokeColor: constantColors.blueColor,
      scaleFactor: 0.5,
      iconSize: 30.0,
      onTap: (val) {
        Provider.of<SearchListProvider>(context, listen: false)
            .searchResultList = [];
        index = val;
        pageController.jumpToPage(val);
        notifyListeners();
      },
      backgroundColor: Color(0xFF040307),
      items: [
        CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
        CustomNavigationBarItem(icon: Icon(EvaIcons.bell)),
        CustomNavigationBarItem(icon: Icon(EvaIcons.search)),
        CustomNavigationBarItem(
          icon: Provider.of<FirebaseOperations>(context).userData != null
              ? CircleAvatar(
                  backgroundColor: constantColors.transparent,
                  backgroundImage: NetworkImage(
                    Provider.of<FirebaseOperations>(context)
                        .userData['profileImageURL'],
                  ),
                )
              : Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                ),
        ),
      ],
    );
  }
}
