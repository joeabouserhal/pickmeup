import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:pickmeup/pages/about_us.dart';
import 'package:pickmeup/pages/contact_us.dart';
import 'package:pickmeup/pages/login_page.dart';
import 'package:pickmeup/utils/database_manager.dart';
import 'package:pickmeup/widgets/common_elevated_button.dart';

class DriverMainPage extends StatefulWidget {
  const DriverMainPage({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _DriverMainPageState createState() => _DriverMainPageState();
}

var user = FirebaseAuth.instance.currentUser;

class _DriverMainPageState extends State<DriverMainPage> {
  // OSM Map controller
  MapController mapController = MapController(
    initMapWithUserPosition: true,
    // center to lebanon by default
    initPosition: GeoPoint(latitude: 33.8547, longitude: 35.8623),
  );

  @override
  Widget build(BuildContext context) {
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
          title: Column(children: const [
            Text(
              "Pick Me Up",
            ),
            Text(
              "Driver",
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ]),
          elevation: 3,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
        ),
        drawer: Drawer(
          child: ListView(padding: const EdgeInsets.all(0), children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Center(
                  child: Row(children: [
                const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(
                  width: 10,
                ),
                FutureBuilder(
                  future: DatabaseManager().getFullNameDriver(user?.uid),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data.toString(),
                      style: const TextStyle(color: Colors.white),
                    );
                  },
                )
              ])),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
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
            label: const Text("Orders"),
            spacing: 6,
            spaceBetweenChildren: 6,
            overlayColor: Colors.black,
            overlayOpacity: 0,
            foregroundColor: Colors.white,
            animatedIcon: AnimatedIcons.menu_close,
            onPress: () {
              _openOrdersPickerSheet();
            },
          ),
        ]),
      ),
    );
  }

  void _openOrdersPickerSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                CustomElevatedButton(
                    child: const Text("Rides"), onPressed: () {}),
                const Padding(padding: EdgeInsets.all(5)),
                CustomElevatedButton(
                    child: const Text("Deliveries"), onPressed: () {})
              ],
            ),
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

  void _openRidesSheet(option) {
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
                child: SingleChildScrollView(
                  child: StreamBuilder(
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
                                      icon:
                                          const Icon(Icons.local_taxi_rounded),
                                      description: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8))),
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
                                                      firestore
                                                          .FirebaseFirestore
                                                          .instance
                                                          .collection('rides')
                                                          .doc(snapshot.data
                                                              ?.docs[index].id)
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
              ));
        });
  }
}
