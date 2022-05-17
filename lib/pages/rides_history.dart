import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';

class RidesHistory extends StatelessWidget {
  const RidesHistory({Key? key}) : super(key: key);

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
          "Rides History",
        ),
        elevation: 3,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('rides')
                .where('ordered_by', isEqualTo: user?.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(50),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return SingleChildScrollView(
                child: Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          return GFListTile(
                            color: Colors.grey[200],
                            icon: const Icon(Icons.local_taxi_rounded),
                            description: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Location:",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                    "${snapshot.data?.docs[index]['location'].latitude.toString()}\n${snapshot.data?.docs[index]['location'].longitude.toString()}"),
                                const Text(
                                  "Destination:",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                    "${snapshot.data?.docs[index]['destination'].latitude.toString()}\n${snapshot.data?.docs[index]['destination'].longitude.toString()}"),
                                Row(
                                  children: [
                                    const Text(
                                      "Is Completed: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                        "${snapshot.data?.docs[index]['is_completed'].toString()}")
                                  ],
                                )
                              ],
                            ),
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      title: const Text(
                                          "Do you want to cancel and delete this ride?"),
                                      actions: [
                                        GFButton(
                                          text: "Cancel",
                                          color: GFColors.WHITE,
                                          textColor: GFColors.DARK,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        GFButton(
                                          text: "Delete",
                                          color: GFColors.DANGER,
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('rides')
                                                .doc(snapshot
                                                    .data?.docs[index].id)
                                                .delete();
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                          );
                        }),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
