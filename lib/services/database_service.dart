import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yen_id/services/auth_service.dart';

class DatabaseService{

  static final DatabaseService _databaseService=DatabaseService._();
  DatabaseService._();
  static DatabaseService instance()=>_databaseService;

  final FirebaseFirestore _dbstore=FirebaseFirestore.instance;


  Stream get uploads{
    return _dbstore.collection('Users').doc(AuthService().getUserID()).collection('uploads').orderBy('DateTime').snapshots();
  }


  bool addImageToDB(String url, String uid, String location){
    try {
      _dbstore.collection('Users').doc(uid).collection('uploads').add(
          {
            'URL': url,
            'Location': location,
            'DateTime': DateTime.now(),
          }
      );
    }
    catch(e){
      return false;
    }
    return true;
  }


}