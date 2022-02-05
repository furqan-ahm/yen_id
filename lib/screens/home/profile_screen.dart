import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yen_id/services/auth_service.dart';
import 'package:yen_id/services/storage_service.dart';

import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
  }

  bool loading=false;

  void updateProfilePic(userModel user)async{

    setState(() {
      loading=true;
    });

    String temp=await StorageService.instance.setProfilePic(user.userId);
    user.updatePhotoURL(temp);

    setState(() {
      loading=false;
    });

  }


  @override
  Widget build(BuildContext context) {
    final user=Provider.of<userModel?>(context)!;

    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                elevation: 15,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundImage: loading?null:user.photoUrl!=null?Image.network(user.photoUrl!,height: 150,width: 150,).image
                                :
                            Image.asset('assets/user.png',width: 150,height: 150,).image,
                            radius: 100,
                            child: loading?CircularProgressIndicator():null,
                          ),
                          const SizedBox(height: 20,),
                          Flexible(child: Text(user.displayName!,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black),)),
                          const SizedBox(height: 20,),
                        ],
                      ),
                      GestureDetector(
                        child: Icon(Icons.camera_alt,color: Colors.teal),
                        onTap: ()=>updateProfilePic(user),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: (){
                    AuthService().signOut();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                    child: Text('Sign Out',style: TextStyle(color: Colors.teal,fontSize: 18),),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}


