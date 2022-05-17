import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pickmeup/pages/login_page.dart';
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
                const SizedBox(height: 100),
                FutureBuilder(
                  future: DatabaseManager().getFullName(user?.uid),
                  builder: (context, snapshot) {
                    return GFListTile(
                      titleText: "Name",
                      description: Text(snapshot.data.toString()),
                      icon: const Icon(Icons.person),
                    );
                    ;
                  },
                ),
                GFListTile(
                  titleText: "Email",
                  description: Text("${user?.email}"),
                  icon: const Icon(Icons.mail),
                ),
                FutureBuilder(
                  future: DatabaseManager().getPhoneNumber(user?.uid),
                  builder: (context, snapshot) {
                    return GFListTile(
                      titleText: "Phone Number",
                      description: Text(snapshot.data.toString()),
                      icon: const Icon(Icons.phone),
                    );
                  },
                ),
                const SizedBox(height: 80),
                Center(
                  child: GFButton(
                      shape: GFButtonShape.pills,
                      text: 'Deactivate Account',
                      color: GFColors.DANGER,
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                title: const Text("Are you sure?"),
                                content: const Text(
                                    "This will deactivate your account"),
                                actions: [
                                  GFButton(
                                    text: "Cancel",
                                    color: GFColors.WHITE,
                                    textColor: GFColors.DARK,
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  GFButton(
                                    text: "Deactivate",
                                    color: GFColors.DANGER,
                                    onPressed: () async {
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(user?.uid)
                                          .delete();
                                      await FirebaseAuth.instance.currentUser
                                          ?.delete()
                                          .then((value) =>
                                              Fluttertoast.showToast(
                                                  msg: 'Account Deactivated'));
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
                                    },
                                  ),
                                ],
                              );
                            });
                      }),
                )
              ],
            )));
  }
}
