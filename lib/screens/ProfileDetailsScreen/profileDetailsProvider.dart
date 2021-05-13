import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ProfileDetailsProvider extends ChangeNotifier {
  QuerySnapshot<Map<String, dynamic>> isFollowReqSent;
  QuerySnapshot<Map<String, dynamic>> isFollowing;

  Future getFollowDetails(data) async {
    isFollowReqSent = await FirebaseFirestore.instance
        .collection('followRequests')
        .where('followReqById',
            isEqualTo: FirebaseAuth.instance.currentUser.uid.toString())
        .where('followReqToId', isEqualTo: data['userId'])
        .limit(1)
        .get();

    isFollowing = await FirebaseFirestore.instance
        .collection('followings')
        .where('followedBy',
            isEqualTo: FirebaseAuth.instance.currentUser.uid.toString())
        .where('followingTo', isEqualTo: data['userId'])
        .limit(1)
        .get();
    notifyListeners();
  }

  Future addFollowRequest(
      BuildContext context, String followReqById, String followReqToId) async {
    return FirebaseFirestore.instance.collection('followRequests').add({
      'followReqById': followReqById,
      'followReqToId': followReqToId,
      'seen': false,
    });
  }

  Future removeFollowRequest(
      BuildContext context, String followReqById, String followReqToId) async {
    return FirebaseFirestore.instance
        .collection('followRequests')
        .where('followReqById',
            isEqualTo: FirebaseAuth.instance.currentUser.uid.toString())
        .where(
          'followReqToId',
          isEqualTo: followReqToId,
        )
        .limit(1)
        .get()
        .then((doc) {
      for (DocumentSnapshot ds in doc.docs) {
        ds.reference.delete();
      }
    });
  }
}
