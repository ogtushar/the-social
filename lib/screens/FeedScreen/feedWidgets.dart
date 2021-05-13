import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constantColors.dart';
import 'package:the_social/screens/FeedScreen/feedUtils.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedWidgetsProvider extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController captionController = TextEditingController();

  bool isImageUploding = false;

  showUploadPostSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.blueGreyColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 150,
              child: Divider(
                thickness: 5,
                color: constantColors.whiteColor,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: constantColors.blueColor,
                  onPressed: () {
                    Provider.of<FeedUtilsProvider>(context, listen: false)
                        .selectPostImage(context, ImageSource.camera)
                        .whenComplete(() {
                      if (Provider.of<FeedUtilsProvider>(context, listen: false)
                              .getUploadPostFile !=
                          null) confirmUploadPostSheet(context);
                    });
                  },
                  child: Text(
                    'Camera',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MaterialButton(
                  color: constantColors.redColor,
                  onPressed: () {
                    Provider.of<FeedUtilsProvider>(context, listen: false)
                        .selectPostImage(context, ImageSource.gallery)
                        .whenComplete(() {
                      if (Provider.of<FeedUtilsProvider>(context, listen: false)
                              .getUploadPostFile !=
                          null) confirmUploadPostSheet(context);
                    });
                  },
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  confirmUploadPostSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.blueGreyColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 150,
              child: Divider(
                thickness: 5,
                color: constantColors.whiteColor,
              ),
            ),
            Container(
              height: 200,
              width: 100,
              child: Image.file(
                Provider.of<FeedUtilsProvider>(context).getUploadPostFile,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: captionController,
                maxLength: 50,
                style: TextStyle(
                  color: constantColors.whiteColor,
                ),
                decoration: InputDecoration(
                  counterStyle: TextStyle(color: constantColors.whiteColor),
                  hintText: 'Add caption...',
                  hintStyle: TextStyle(color: constantColors.whiteColor),
                ),
              ),
            ),
            Provider.of<FeedWidgetsProvider>(context).isImageUploding
                ? CircularProgressIndicator()
                : MaterialButton(
                    color: constantColors.redColor,
                    onPressed: () async {
                      changeUploadingStatus();
                      final res = await Provider.of<FeedUtilsProvider>(context,
                              listen: false)
                          .uploadPost(context, captionController.text.trim());
                      if (res == true) {
                        captionController.text = "";
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                      changeUploadingStatus();
                    },
                    child: Text(
                      'Post',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  changeUploadingStatus() {
    this.isImageUploding = !this.isImageUploding;
    notifyListeners();
  }

  Widget getUserPosts(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('uploadedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: SizedBox(
            height: 500,
            width: 400,
            child: Lottie.asset('assets/animations/loading.json'),
          ));
        }
        List _userPosts = snapshot.data.docs.map((doc) => doc).toList();
        return ListView.builder(
          itemCount: _userPosts.length,
          itemBuilder: (context, index) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: constantColors.transparent,
                            radius: 20.0,
                            backgroundImage: NetworkImage(
                              _userPosts[index]['profileImageURL'],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    _userPosts[index]['caption'],
                                    style: TextStyle(
                                      color: constantColors.greenColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: RichText(
                                    text: TextSpan(
                                      text: '@' +
                                          _userPosts[index]['userEmail']
                                              .toString()
                                              .split("@")[0],
                                      style: TextStyle(
                                        color: constantColors.blueColor,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' , ' +
                                              timeago.format(
                                                DateTime.parse(
                                                  _userPosts[index]
                                                      ['uploadedAt'],
                                                ),
                                              ),
                                          style: TextStyle(
                                            color: constantColors.lightColor
                                                .withOpacity(0.8),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.46,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: Image.network(
                          _userPosts[index]['postImageUrl'],
                          scale: 2,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          child: Row(
                            children: [
                              GestureDetector(
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.heart,
                                    color: constantColors.redColor,
                                  ),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('posts')
                                        .where('postId',
                                            isEqualTo: _userPosts[index]
                                                ['postId'])
                                        .limit(1)
                                        .get()
                                        .then((doc) {
                                      for (DocumentSnapshot ds in doc.docs) {
                                        ds.reference.update(
                                          {'likes': FieldValue.increment(1)},
                                        );
                                      }
                                    });
                                  },
                                ),
                              ),
                              Text(
                                _userPosts[index]['likes'].toString(),
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 80,
                          child: Row(
                            children: [
                              GestureDetector(
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.comment,
                                    color: constantColors.blueColor,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              Text(
                                _userPosts[index]['comments'].toString(),
                                style: TextStyle(
                                  color: constantColors.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 80,
                          child: GestureDetector(
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.download,
                                color: constantColors.whiteColor,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }
}
