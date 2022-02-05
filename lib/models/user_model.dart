import 'package:firebase_auth/firebase_auth.dart';

class userModel {
  User? user;

  String userId;
  String? displayName;
  String? photoUrl;

  userModel({required this.userId, this.displayName, this.photoUrl, this.user});

  @override
  String toString() {
    return userId;
  }

  updatePhotoURL(String url)async{
    photoUrl=url;
    await user!.updatePhotoURL(url);
  }

}