import 'package:flutter/material.dart';
import 'package:yen_id/screens/authenticate/login_screen.dart';
import 'package:yen_id/screens/authenticate/signup_screen.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool signUp=false;

  void toggleView(){
    setState(() {
      signUp=!signUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return signUp?SignUpScreen(toggleView: toggleView,):LoginScreen(toggleView: toggleView,);
  }
}
