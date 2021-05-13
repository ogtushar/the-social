import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:the_social/services/firebaseOperations.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String _userID;
  String get getUserId => this._userID;

  Future signUp({BuildContext context, String email, String password}) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    User _user = userCredential.user;
    this._userID = _user.uid;

    debugPrint("User ID: ${this._userID}");
    notifyListeners();
  }

  Future logIn({String email, String password}) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    User _user = userCredential.user;
    this._userID = _user.uid;

    debugPrint("User ID: ${this._userID}");
    notifyListeners();
  }

  Future signOutWithEmailAndPassword() async {
    return firebaseAuth.signOut();
  }

  Future signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount == null) return false;

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(authCredential);

    final User user = userCredential.user;

    this._userID = user.uid;
    assert(this._userID != null);
    debugPrint("User ID: ${this._userID}");

    Provider.of<FirebaseOperations>(context, listen: false)
        .createUser(context, {
      'userId': this._userID,
      'userEmail': user.email,
      'createdAt': DateTime.now().toIso8601String(),
      'profileImageURL': user.photoURL.toString(),
      'accountType': 1,
      'posts': 0,
      'followers': 0,
      'following': 0,
    });
    notifyListeners();
    return true;
  }

  Future signOutWithGoogle() async {
    FirebaseAuth.instance.signOut();
    return googleSignIn.signOut();
  }
}
