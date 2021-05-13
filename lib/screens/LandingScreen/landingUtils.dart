import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_social/services/firebaseOperations.dart';

class LandingUtils extends ChangeNotifier {
  ImagePicker _imagePicker = ImagePicker();
  File _userAvatar;
  String _userAvatarUrl = "";

  File get getUserAvatar => this._userAvatar;
  String get getUserAvatarUrl => this._userAvatarUrl;
  set setUserAvatarUrl(String url) => this._userAvatarUrl = url;

  Future pickUserAvatar(BuildContext context, ImageSource source) async {
    final pickedUserAvatar = await this._imagePicker.getImage(source: source);
    pickedUserAvatar == null
        ? ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please Select an Image..."),
            ),
          )
        : this._userAvatar = File(pickedUserAvatar.path);
    this._userAvatar != null
        ? Provider.of<FirebaseOperations>(context, listen: false)
            .uploadAvatarImage(context)
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please Select an Image..."),
            ),
          );
    notifyListeners();
  }
}
