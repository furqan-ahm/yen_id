import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yen_id/screens/home/profile_screen.dart';

import '../models/user_model.dart';
import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user=Provider.of<userModel?>(context);

    if(user==null)return Authenticate();

    return const ProfileScreen();
  }
}
