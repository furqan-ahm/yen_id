import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService{

  static StorageService instance=StorageService._();

  final FirebaseStorage _storage=FirebaseStorage.instance;

  StorageService._();

  static getInstance(){
    return instance;
  }



  Future<String> setProfilePic(String uid)async{

    var pickedImage=await ImagePicker.platform.getImage(source: ImageSource.gallery);


    await _storage.ref('ProfilePics').child(uid).putFile(File(pickedImage!.path));

    return _storage.ref('ProfilePics').child(uid).getDownloadURL();
  }


}