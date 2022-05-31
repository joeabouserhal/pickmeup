import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:pickmeup/pages/about_us.dart';
import 'package:pickmeup/pages/contact_us.dart';
import 'package:pickmeup/pages/login_page.dart';
import 'package:pickmeup/pages/profile_page.dart';
import 'package:pickmeup/utils/database_manager.dart';
import 'package:pickmeup/widgets/common_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

GeoPoint rideLocation = const firestore.GeoPoint(0, 0) as GeoPoint;
GeoPoint rideDestination = const firestore.GeoPoint(0, 0) as GeoPoint;
GeoPoint deliveryLocation = const firestore.GeoPoint(0, 0) as GeoPoint;

TextEditingController deliverDescriptionController = TextEditingController();

final user = FirebaseAuth.instance.currentUser;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // OSM Map controller
  MapController mapController = MapController(
    initMapWithUserPosition: true,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light),
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            "Pick Me Up",
          ),
          elevation: 3,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: GestureDetector(
                  child: const Icon(Icons.history_rounded),
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  child: Flexible(
                                      child: Padding(
                                          padding: const EdgeInsets.all(25.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomElevatedButton(
                                                child: const Text(
                                                  "Rides History",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  _ridesModalSheet();
                                                },
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.all(5)),
                                              CustomElevatedButton(
                                                child: const Text(
                                                  "Deliveries History",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  _deliveriesModalSheet();
                                                },
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.all(5)),
                                              CustomElevatedButton(
                                                child: const Text(
                                                  "Completed Rides",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  _completedRidesScreen();
                                                },
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.all(5)),
                                              CustomElevatedButton(
                                                child: const Text(
                                                  "Completed Deliveries",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  _completedDeliveriesScreen();
                                                },
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.all(5)),
                                              CustomElevatedButton(
                                                color: Colors.white,
                                                child: const Text(
                                                  "Close",
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          )))));
                        });
                  }),
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(padding: const EdgeInsets.all(0), children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Center(
                  child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 80,
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: DatabaseManager().getFullName(user?.uid),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    );
                  },
                )
              ])),
            ),
            ListTile(
              title: const Text("Profile"),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              title: const Text("Contact Us"),
              leading: const Icon(Icons.call),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactUsPage()),
                );
              },
            ),
            ListTile(
              title: const Text("About Us"),
              leading: const Icon(Icons.info_outline_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
              },
            ),
            ListTile(
              title: const Text("Log Out"),
              leading: const Icon(Icons.logout_rounded),
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('email');
                  await prefs.remove('password');
                  await prefs.remove('isCustomer');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                });
              },
            ),
          ]),
        ),
        //* The Map
        body: OSMFlutter(
          controller: mapController,
          trackMyPosition: true,
          androidHotReloadSupport: true,
          initZoom: 15,
          stepZoom: 1.0,
          userLocationMarker: UserLocationMaker(
            personMarker: const MarkerIcon(
              icon: Icon(Icons.location_history_rounded,
                  color: Colors.blue, size: 60),
            ),
            directionArrowMarker: const MarkerIcon(
              icon: Icon(Icons.double_arrow_rounded),
            ),
          ),
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 3,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15), // <-- Splash color
            ),
            child: const Icon(Icons.location_searching, color: Colors.white),
            onPressed: _returnToCurrentLocation,
          ),
          const SizedBox(width: 10),
          SpeedDial(
            elevation: 3,
            label: const Text("Order"),
            spacing: 6,
            spaceBetweenChildren: 6,
            overlayColor: Colors.black,
            overlayOpacity: 0,
            foregroundColor: Colors.white,
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                  elevation: 3,
                  child: const Icon(Icons.delivery_dining_rounded),
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  label: 'Delivery',
                  onTap: () {
                    _openLocationPickerSheet('Delivery');
                  }),
              SpeedDialChild(
                  elevation: 3,
                  child: const Icon(Icons.local_taxi_rounded),
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  label: 'Ride',
                  onTap: () {
                    _openLocationPickerSheet('Ride');
                  }),
            ],
          ),
        ]),
      ),
    );
  }

  void _openLocationPickerSheet(option) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: (option == 'Delivery')
                    //if true
                    ? _deliveryLocationPicker(context)
                    // if false
                    : _rideLocationPicker(context)),
          );
        });
  }

  void _ridesModalSheet() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Rides"),
            children: [
              StreamBuilder(
                  stream: firestore.FirebaseFirestore.instance
                      .collection('rides')
                      .where('ordered_by', isEqualTo: user?.uid)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<firestore.QuerySnapshot> snapshot) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Location:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                          "${snapshot.data?.docs[index]['location'].latitude.toString()}\n${snapshot.data?.docs[index]['location'].longitude.toString()}"),
                                      const Text(
                                        "Destination:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
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
                                      ),
                                      const Text(
                                        "Date Ordered:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                          "${snapshot.data?.docs[index]['date_ordered'].toDate().toString()}"),
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
                                                  firestore.FirebaseFirestore
                                                      .instance
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
                  })
            ],
          );
        });
  }

  void _deliveriesModalSheet() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Deliveries"),
            children: [
              StreamBuilder(
                  stream: firestore.FirebaseFirestore.instance
                      .collection('deliveries')
                      .where('ordered_by', isEqualTo: user?.uid)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<firestore.QuerySnapshot> snapshot) {
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
                                  icon:
                                      const Icon(Icons.delivery_dining_rounded),
                                  description: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Location:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                          "${snapshot.data?.docs[index]['location'].latitude.toString()}\n${snapshot.data?.docs[index]['location'].longitude.toString()}"),
                                      const Text(
                                        "Description:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                          "${snapshot.data?.docs[index]['description'].toString()}"),
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
                                      ),
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
                                                "Do you want to cancel and delete this delivery?"),
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
                                                  firestore.FirebaseFirestore
                                                      .instance
                                                      .collection('deliveries')
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
                  })
            ],
          );
        });
  }

  void _completedRidesScreen() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Completed Rides"),
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context)),
              ],
            ),
            children: [
              StreamBuilder(
                  stream: firestore.FirebaseFirestore.instance
                      .collection('rides')
                      .where('ordered_by', isEqualTo: user?.uid)
                      .where('is_completed', isEqualTo: true)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<firestore.QuerySnapshot> snapshot) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Location:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                          "${snapshot.data?.docs[index]['location'].latitude.toString()}\n${snapshot.data?.docs[index]['location'].longitude.toString()}"),
                                      const Text(
                                        "Destination:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                          "${snapshot.data?.docs[index]['destination'].latitude.toString()}\n${snapshot.data?.docs[index]['destination'].longitude.toString()}"),
                                      const Text(
                                        "Completed By: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      FutureBuilder(
                                          future: DatabaseManager()
                                              .getFullNameDriver(snapshot
                                                  .data?.docs[index]['taken_by']
                                                  .toString()),
                                          builder: (context, snapshot) {
                                            return Text(
                                                snapshot.data.toString());
                                          }),
                                      Row(
                                        children: [
                                          const Text(
                                            "Rating: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                              "${snapshot.data?.docs[index]['rating'].toString()} stars"),
                                        ],
                                      ),
                                      RatingBar.builder(
                                        ignoreGestures: true,
                                        itemSize: 20,
                                        allowHalfRating: true,
                                        initialRating: snapshot
                                            .data?.docs[index]['rating'],
                                        onRatingUpdate: (rating) {},
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    double currentOrderRating = 1;
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SimpleDialog(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            title: const Text(
                                                "Would you like to rate this ride?"),
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: RatingBar.builder(
                                                  initialRating:
                                                      currentOrderRating,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemPadding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 4.0),
                                                  itemBuilder: (context, _) =>
                                                      const Icon(
                                                    Icons.star_rounded,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    currentOrderRating = rating;
                                                  },
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  GFButton(
                                                    text: "Cancel",
                                                    color: GFColors.WHITE,
                                                    textColor: GFColors.DARK,
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                  GFButton(
                                                    text: "Rate",
                                                    color: Colors.amber,
                                                    textColor: GFColors.WHITE,
                                                    onPressed: () {
                                                      firestore
                                                          .FirebaseFirestore
                                                          .instance
                                                          .collection('rides')
                                                          .doc(snapshot.data
                                                              ?.docs[index].id)
                                                          .update({
                                                        'rating':
                                                            currentOrderRating
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
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
                  })
            ],
          );
        });
  }

  void _completedDeliveriesScreen() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Completed\nDeliveries",
                ),
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context)),
              ],
            ),
            children: [
              StreamBuilder(
                  stream: firestore.FirebaseFirestore.instance
                      .collection('deliveries')
                      .where('ordered_by', isEqualTo: user?.uid)
                      .where('is_completed', isEqualTo: true)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<firestore.QuerySnapshot> snapshot) {
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
                                  icon:
                                      const Icon(Icons.delivery_dining_rounded),
                                  description: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Location:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                          "${snapshot.data?.docs[index]['location'].latitude.toString()}\n${snapshot.data?.docs[index]['location'].longitude.toString()}"),
                                      const Text(
                                        "Description:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                          "${snapshot.data?.docs[index]['description'].toString()}"),
                                      const Text(
                                        "Completed By: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      FutureBuilder(
                                          future: DatabaseManager()
                                              .getFullNameDriver(snapshot
                                                  .data?.docs[index]['taken_by']
                                                  .toString()),
                                          builder: (context, snapshot) {
                                            return Text(
                                                snapshot.data.toString());
                                          }),
                                      Row(
                                        children: [
                                          const Text(
                                            "Rating: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                              "${snapshot.data?.docs[index]['rating'].toString()} stars")
                                        ],
                                      ),
                                      RatingBar.builder(
                                        ignoreGestures: true,
                                        itemSize: 20,
                                        allowHalfRating: true,
                                        initialRating: double.parse(snapshot
                                            .data?.docs[index]['rating']
                                            .toString() as String),
                                        onRatingUpdate: (rating) {},
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    double currentOrderRating = 1;
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SimpleDialog(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            title: const Text(
                                                "Would you like to rate this delivery?"),
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: RatingBar.builder(
                                                  initialRating:
                                                      currentOrderRating,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemPadding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 4.0),
                                                  itemBuilder: (context, _) =>
                                                      const Icon(
                                                    Icons.star_rounded,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    currentOrderRating = rating;
                                                  },
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  GFButton(
                                                    text: "Cancel",
                                                    color: GFColors.WHITE,
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                  GFButton(
                                                    text: "Rate",
                                                    textColor: GFColors.WHITE,
                                                    color: Colors.amber,
                                                    onPressed: () {
                                                      firestore
                                                          .FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'deliveries')
                                                          .doc(snapshot.data
                                                              ?.docs[index].id)
                                                          .update({
                                                        'rating':
                                                            currentOrderRating
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
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
                  })
            ],
          );
        });
  }

  // returns camera to original location
  void _returnToCurrentLocation() async {
    await mapController.currentLocation();
    if (await mapController.getZoom() < 15) {
      await mapController.setZoom(zoomLevel: 15);
    }
  }
}

//* Ride Location and Destination Picker Sheet
_rideLocationPicker(context) {
  return Flexible(
    child: Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              "Ride:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          CustomElevatedButton(
              child: const Text(
                "Pick Current Location",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                rideLocation = (await showSimplePickerLocation(
                  context: context,
                  isDismissible: true,
                  title: "Ride Location Picker",
                  textConfirmPicker: "Pick",
                  initCurrentUserPosition: true,
                  initZoom: 15,
                  radius: 8.0,
                ))!;
              }),
          const Padding(padding: EdgeInsets.all(5)),
          CustomElevatedButton(
            child: const Text(
              "Pick Destination",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              rideDestination = (await showSimplePickerLocation(
                context: context,
                isDismissible: true,
                title: "Ride Destination Picker",
                textConfirmPicker: "Pick",
                initCurrentUserPosition: true,
                initZoom: 15,
                radius: 8.0,
              ))!;
            },
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomElevatedButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.cyan),
                ),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CustomElevatedButton(
                child: const Text(
                  "Order",
                  style: TextStyle(color: Colors.cyan),
                ),
                color: Colors.white,
                onPressed: () {
                  firestore.FirebaseFirestore.instance
                      .collection('rides')
                      .doc()
                      .set({
                    'ordered_by': FirebaseAuth.instance.currentUser?.uid,
                    'is_completed': false,
                    'location': firestore.GeoPoint(
                        rideLocation.latitude, rideLocation.longitude),
                    'destination': firestore.GeoPoint(
                        rideDestination.latitude, rideDestination.longitude),
                    'rating': 0,
                    'date_ordered': firestore.Timestamp.now(),
                  }).then((value) {
                    Fluttertoast.showToast(msg: 'Ride Ordered');
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          )
        ],
      ),
    ),
  );
}

//* delivery Destination and description Picker Sheet
_deliveryLocationPicker(context) {
  return Flexible(
    child: Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text("Delivery:",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
          ),
          CustomElevatedButton(
            child: const Text(
              "Pick Current Location",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              deliveryLocation = (await showSimplePickerLocation(
                context: context,
                isDismissible: true,
                title: "Delivery Location Picker",
                textConfirmPicker: "Pick",
                initCurrentUserPosition: true,
                initZoom: 15,
                radius: 8.0,
              ))!;
            },
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextField(
                      controller: deliverDescriptionController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: "Enter Description",
                        border: InputBorder.none,
                      )),
                )),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomElevatedButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.cyan),
                ),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CustomElevatedButton(
                child: const Text(
                  "Order",
                  style: TextStyle(color: Colors.cyan),
                ),
                color: Colors.white,
                onPressed: () {
                  firestore.FirebaseFirestore.instance
                      .collection('deliveries')
                      .doc()
                      .set({
                    'ordered_by': FirebaseAuth.instance.currentUser?.uid,
                    'is_completed': false,
                    'location': firestore.GeoPoint(
                        deliveryLocation.latitude, deliveryLocation.longitude),
                    'description': deliverDescriptionController.text,
                    'date_ordered': firestore.Timestamp.now(),
                    'in_progress': false,
                    'rating': 0,
                    'taken_by': "",
                  }).then((value) {
                    Fluttertoast.showToast(msg: 'Delivery Ordered');
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          )
        ],
      ),
    ),
  );
}
