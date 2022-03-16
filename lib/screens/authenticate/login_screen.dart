import 'package:flutter/material.dart';
import 'package:yen_id/screens/authenticate/signup_screen.dart';

import '../../constants.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key,required this.toggleView}) : super(key: key);


  final Function toggleView;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool loading=false;

  TextEditingController emailController=TextEditingController();
  TextEditingController passController=TextEditingController();



  signUp()async{

    setState(() {
      loading=true;
    });

    dynamic result=await AuthService().Login(emailController.text, passController.text);

    if(result is userModel)return;

    setState(() {
      loading=false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Text(result, style: const TextStyle(color: Colors.redAccent),textAlign: TextAlign.center,),
      ));
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                const Text('Img-Uploader',style: const TextStyle(color: Colors.white,fontSize: 36,fontWeight: FontWeight.w600),),
                Card(
                  elevation: 20,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: loading?Center(child: CircularProgressIndicator(),):Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera,size: 150,color: Colors.teal,),
                        //Image.asset('assets/yenID.png',height: 150,width: 150,),
                        TextFormField(
                          controller: emailController,
                          decoration: inputdec.copyWith(
                              prefixIcon: const Icon(Icons.person),
                              hintText: 'Email'
                          ),
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          controller: passController,
                          decoration: inputdec.copyWith(
                              prefixIcon: const Icon(Icons.lock),
                              hintText: 'Password'
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: (){
                                  signUp();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 15),
                                  child: Text('Sign In',style: TextStyle(color: Colors.white,fontSize: 18),),
                                ),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                  backgroundColor: MaterialStateProperty.all(Colors.teal),
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Dont have an account?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                    TextButton(
                      child: const Text('Sign Up',style: TextStyle(fontSize: 16,color: Colors.tealAccent),),
                      onPressed: (){
                        widget.toggleView();
                      } ,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

