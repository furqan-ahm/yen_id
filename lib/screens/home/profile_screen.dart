import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yen_id/services/auth_service.dart';
import 'package:yen_id/services/location_service.dart';
import 'package:yen_id/services/storage_service.dart';
import '../../models/user_model.dart';
import '../../services/database_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    LocationService.instance();
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
      extendBodyBehindAppBar: true,

      backgroundColor: Colors.teal,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: ()=>AuthService().signOut(), icon: Icon(Icons.logout,color: Colors.white,))
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on,color: Colors.white,),
                    Text(LocationService.instance().currentAddress??'Unknown',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white),),
                    GestureDetector(
                      child: Icon(Icons.refresh,color: Colors.tealAccent,),
                      onTap: (){
                        LocationService.instance().getLocation().then((value){setState(() {});});
                      },
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  elevation: 15,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          child: Icon(Icons.camera_alt,color: Colors.teal),
                          onTap: ()=>updateProfilePic(user),
                        ),
                        CircleAvatar(
                          backgroundImage: loading?null:user.photoUrl!=null?Image.network(user.photoUrl!,height: 150,width: 150,).image
                              :
                          Image.asset('assets/user.png',width: 100,height: 100,).image,
                          radius: 100,
                          child: loading?CircularProgressIndicator():null,
                        ),
                        const SizedBox(height: 20,),
                        Flexible(child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person),
                            Text(user.displayName!,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black),),
                          ],
                        )),
                        const SizedBox(height: 5,),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Card(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    elevation: 15,
                    child: PhotoGrid(uid: user.userId,)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PhotoGrid extends StatefulWidget {
  const PhotoGrid({Key? key,required this.uid}) : super(key: key);

  final String uid;

  @override
  _PhotoGridState createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {


  bool loading=false;

  void uploadImage(bool fromCamera, int currentNum)async{
    setState(() {
      loading=true;
    });
    String url;
    if(fromCamera){
      url=await StorageService.instance.uploadImageFromCamera(widget.uid,currentNum);
    }
    else{
      url=await StorageService.instance.uploadImageFromGallery(widget.uid, currentNum);
    }

    if(url!='not_picked')DatabaseService.instance().addImageToDB(url, widget.uid, LocationService.instance().currentAddress!);

    setState(() {
      loading=false;
    });

  }


  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: DatabaseService.instance().uploads,
      builder: (context, snapshot) {

        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Uploads',style: TextStyle(color: Colors.teal,fontSize: 24,fontWeight: FontWeight.w600),),
              const SizedBox(height: 20,),
              snapshot.hasData?GridView.count(
                shrinkWrap: true,
                primary: false,
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.grey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Upload Image?',style: TextStyle(color: Colors.white),),
                          ElevatedButton(
                            child: Text('From Camera'),
                            onPressed: (){uploadImage(true, (snapshot.data as QuerySnapshot).docs.length);},
                          ),
                          ElevatedButton(
                            child: Text('From Gallery'),
                            onPressed: (){uploadImage(false, (snapshot.data as QuerySnapshot).docs.length);},
                          ),
                        ],
                      ),
                    ),
                  ),
                ]+(snapshot.data as QuerySnapshot).docs.map((e){
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(e.get('URL'),fit: BoxFit.cover,),
                        Container(
                            color:Colors.black26,
                            child: Container(
                              padding: EdgeInsets.all(8),
                                alignment:Alignment.bottomCenter,
                                child: Text(e.get('Location'),style: TextStyle(color: Colors.white),)
                            )
                        ),
                      ],
                    ),
                  );
                }).toList()
              )
                  :
              CircularProgressIndicator()
              ,
            ],
          ),
        );
      }
    );
  }
}




