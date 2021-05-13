import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constantColors.dart';
import 'package:the_social/screens/ProfileDetailsScreen/ProfileDetailsScreen.dart';
import 'package:the_social/screens/SearchScreen/searchListProvider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ConstantColors _constantColors = ConstantColors();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<SearchListProvider>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: _constantColors.blueGreyColor,
          title: TextField(
            autofocus: true,
            onTap: () {
              Provider.of<SearchListProvider>(context, listen: false)
                  .searchUsers(_searchController.text);
            },
            controller: _searchController,
            onChanged: (_) {
              Provider.of<SearchListProvider>(context, listen: false)
                  .searchUsers(_searchController.text);
            },
            style: TextStyle(
              color: _constantColors.whiteColor,
            ),
            decoration: InputDecoration(
              hintText: 'search...',
              hintStyle: TextStyle(
                color: _constantColors.whiteColor,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: _constantColors.whiteColor),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _constantColors.blueColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _constantColors.whiteColor),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ListView.builder(
            itemCount: Provider.of<SearchListProvider>(context)
                .searchResultList
                .length,
            itemBuilder: (context, index) {
              Map<String, dynamic> _data =
                  Provider.of<SearchListProvider>(context)
                      .searchResultList[index];
              return ListTile(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ProfileDetailScreen(userProfileData: _data),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                title: Text(
                  _data['userEmail'].toString().split('@')[0].toString(),
                  style: TextStyle(
                    color: _constantColors.whiteColor,
                    fontSize: 14,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Icon(
                      EvaIcons.emailOutline,
                      size: 20,
                      color: _constantColors.yellowColor,
                    ),
                    SizedBox(width: 10),
                    Text(
                      _data['userEmail'],
                      style: TextStyle(
                        color: _constantColors.blueColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                leading: CircleAvatar(
                  backgroundColor: _constantColors.transparent,
                  backgroundImage: NetworkImage(_data['profileImageURL']),
                  radius: 25,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Provider.of<SearchListProvider>(context).reset();
    super.dispose();
  }
}
