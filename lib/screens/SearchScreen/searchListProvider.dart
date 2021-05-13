import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchListProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _usersList = [];
  List<Map<String, dynamic>> searchResultList = [];

  void fetchUsers() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((data) => data.docs.forEach((element) {
              _usersList.add(element.data());
            }));
    notifyListeners();
  }

  void searchUsers(String query) {
    query != ''
        ? searchResultList = _usersList
            .where((element) => element['userEmail']
                .toString()
                .split('@')[0]
                .contains(query.trim().toLowerCase()))
            .toList()
        : searchResultList = [];
    notifyListeners();
  }

  void reset() {
    _usersList = [];
    searchResultList = [];
    notifyListeners();
  }
}
