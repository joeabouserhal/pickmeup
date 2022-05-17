import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pickmeup/pages/about_us.dart';
import 'package:pickmeup/pages/contact_us.dart';
import 'package:pickmeup/pages/deliveries_history.dart';
import 'package:pickmeup/pages/login_page.dart';
import 'package:pickmeup/pages/profile_page.dart';
import 'package:pickmeup/pages/rides_history.dart';
import 'package:pickmeup/utils/database_manager.dart';
import 'package:pickmeup/widgets/common_elevated_button.dart';

GeoPoint rideLocation = const firestore.GeoPoint(0, 0) as GeoPoint;
GeoPoint rideDestination = const firestore.GeoPoint(0, 0) as GeoPoint;
GeoPoint deliveryLocation = const firestore.GeoPoint(0, 0) as GeoPoint;

TextEditingController deliverDescriptionController = TextEditingController();

String name = "";

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
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const RidesHistory()));
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
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const DeliveriesHistory()));
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
                  future: DatabaseManager().getFullName(uid),
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
                FirebaseAuth.instance.signOut().then((value) => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      )
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

  // returns camera to original location
  void _returnToCurrentLocation() async {
    await mapController.currentLocation();
    if (await mapController.getZoom() < 15) {
      await mapController.setZoom(zoomLevel: 15);
    }
  }
}

// Ride Location and Destination Picker Sheet
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

// delivery Destination and description Picker Sheet
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
