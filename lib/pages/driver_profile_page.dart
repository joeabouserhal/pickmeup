import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pickmeup/pages/login_page.dart';
import 'package:pickmeup/utils/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DriverProfilePage extends StatelessWidget {
  DriverProfilePage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                  future: DatabaseManager().getDriverFullName(user?.uid),
                  builder: (context, snapshot) {
                    return GFListTile(
                      titleText: "Name",
                      description: Text(snapshot.data.toString()),
                      icon: const Icon(Icons.person),
                    );
                  },
                ),
                Center(
                  child: GFButton(
                    shape: GFButtonShape.pills,
                    text: "Change Name",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            title: const Text("Please enter the new values"),
                            children: [
                              Form(
                                key: _key,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                          controller: firstNameController,
                                          decoration: const InputDecoration(
                                              hintText: "First Name"),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Field is required';
                                            }
                                            return null;
                                          }),
                                      TextFormField(
                                        controller: lastNameController,
                                        decoration: const InputDecoration(
                                            hintText: "Last Name"),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Field is required';
                                          }
                                          return null;
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GFButton(
                                      text: "Cancel",
                                      color: Colors.white,
                                      textColor: Colors.black,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    GFButton(
                                      text: "Submit",
                                      color: Colors.cyan,
                                      onPressed: () {
                                        if (_key.currentState!.validate()) {
                                          _key.currentState!.save();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                GFListTile(
                  titleText: "Email",
                  description: Text("${user?.email}"),
                  icon: const Icon(Icons.mail),
                ),
                FutureBuilder(
                  future: DatabaseManager().getDriverPhoneNumber(user?.uid),
                  builder: (context, snapshot) {
                    return GFListTile(
                      titleText: "Phone Number",
                      description: Text(snapshot.data.toString()),
                      icon: const Icon(Icons.phone),
                    );
                  },
                ),
                FutureBuilder(
                  future: DatabaseManager().getDriverLicenseNumber(user?.uid),
                  builder: (context, snapshot) {
                    return GFListTile(
                      titleText: "License Number",
                      description: Text(snapshot.data.toString()),
                      icon: const Icon(Icons.drive_eta_rounded),
                    );
                  },
                ),
                const SizedBox(height: 40),
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
