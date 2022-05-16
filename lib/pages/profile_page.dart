import 'package:firebase_auth/firebase_auth.dart';
import 'package:pickmeup/utils/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light),
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Profile",
          ),
          elevation: 3,
        ),
        body: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                    child: Icon(Icons.account_circle,
                        size: 100, color: Colors.black)),
                FutureBuilder(
                  future: DatabaseManager().getFullName(user?.uid),
                  builder: (context, snapshot) {
                    return Text("Name: ${snapshot.data.toString()}");
                  },
                )
              ],
            )));
  }
}
