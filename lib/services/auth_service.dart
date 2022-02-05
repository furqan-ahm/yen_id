import 'package:firebase_auth/firebase_auth.dart';
import 'package:yen_id/models/user_model.dart';

class AuthService{

  final FirebaseAuth _auth=FirebaseAuth.instance;

  static String _temp='';



  userModel? _getUser(User? user){
    return user!=null?userModel(user: user,userId: user.uid,displayName: user.displayName??_temp,photoUrl: user.photoURL):null;
  }


  Stream<userModel?> get user{
    return _auth.userChanges().map(_getUser);
  }


  Future Login(String email,String pass)async{
    try{
      UserCredential cred=await _auth.signInWithEmailAndPassword(email: email, password: pass);
      return _getUser(cred.user);
    }
    catch(e){
      if(e is FirebaseAuthException) {
        return e.code;
      } else {
        return 'Unknown Error';
      }
    }
  }

  Future SignUp(String name,String email,String pass)async{
    try{
      _temp=name;
      UserCredential cred=await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      await cred.user!.updateDisplayName(name);
      return _getUser(cred.user);
    }
    catch(e){
      if(e is FirebaseAuthException) {
        return e.code;
      } else {
        return 'Unknown Error';
      }
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return e.toString();
    }
  }



}