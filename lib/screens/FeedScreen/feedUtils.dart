import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:the_social/services/firebaseOperations.dart';

class FeedUtilsProvider extends ChangeNotifier {
  ImagePicker imagePicker = ImagePicker();
  File postImage;
  String postImageUrl;

  List followings = [];

  File get getUploadPostFile => this.postImage;

  Future selectPostImage(BuildContext context, ImageSource source) async {
    final PickedFile imagePicked = await imagePicker.getImage(source: source);
    this.postImage = File(imagePicked.path);
    notifyListeners();
  }

  Future uploadPost(BuildContext context, String caption) async {
    final userData =
        Provider.of<FirebaseOperations>(context, listen: false).getUserData;
    UploadTask uploadTask;
    String _imageName = basename(
        Provider.of<FeedUtilsProvider>(context, listen: false).postImage.path);
    Reference imageRef = FirebaseStorage.instance
        .ref()
        .child("userPosts/${userData['userId']}/$_imageName");

    try {
      uploadTask = imageRef.putFile(File(postImage.path));
      await uploadTask.whenComplete(
        () => imageRef
            .getDownloadURL()
            .then((url) => this.postImageUrl = url.toString()),
      );
      print('Post Uploaded | URL: ${this.postImageUrl}');
    } on FirebaseException catch (_) {
      return false;
    }

    final uploadedAt = DateTime.now().toIso8601String();
    final String postId = "${userData['userId']}-$uploadedAt";
    final Map<String, dynamic> data = {
      'userId': userData['userId'],
      'postId': postId,
      'profileImageURL': userData['profileImageURL'],
      'userEmail': userData['userEmail'],
      'postImageName': _imageName,
      'postImageUrl': this.postImageUrl,
      'caption': caption,
      'uploadedAt': uploadedAt,
      'likes': 0,
      'comments': 0,
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData['userId'])
        .update({"posts": FieldValue.increment(1)});
    await FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
    return true;
  }

  getAllFollowing() async {
    this.followings = await FirebaseFirestore.instance
        .collection('followings')
        .where(
          'followedBy',
          isEqualTo: FirebaseAuth.instance.currentUser.uid.toString(),
        )
        .get()
        .then(
          (snapshot) => snapshot.docs.map((doc) {
            Map<String, dynamic> _data = doc.data();
            return _data['followingTo'];
          }).toList(),
        );
    notifyListeners();
  }
}
