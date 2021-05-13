import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/LandingScreen/landingUtils.dart';
import 'package:path/path.dart';
import 'package:the_social/services/authService.dart';

class FirebaseOperations extends ChangeNotifier {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  dynamic userData;

  UploadTask imageUploadTask;

  dynamic get getUserData => this.userData;

  Future uploadAvatarImage(BuildContext context) async {
    Reference imageRefrence = firebaseStorage.ref().child(
        "profileImages/${DateTime.now()}-${basename(Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path.toString())}");

    imageUploadTask = imageRefrence.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserAvatar);

    await imageUploadTask.whenComplete(
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Image Uploded..."),
          ),
        );
      },
    );

    imageRefrence.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).setUserAvatarUrl =
          url.toString();

      print(
          'Image Url => ${Provider.of<LandingUtils>(context, listen: false).getUserAvatarUrl}');
      notifyListeners();
    });
  }

  Future createUser(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<AuthService>(context, listen: false).getUserId)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    print('Fetching Data...');
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid.toString())
        .get()
        .then((doc) {
      userData = doc.data();
      notifyListeners();
    });
  }
}
