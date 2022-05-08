import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pickmeup/pages/about_us.dart';
import 'package:pickmeup/pages/contact_us.dart';
import 'package:pickmeup/pages/location_picker_page.dart';
import 'package:pickmeup/pages/login_page.dart';
import 'package:pickmeup/widgets/common_elevated_button.dart';

import '../models/customer.dart';

TextEditingController deliverDescriptionController = TextEditingController();

class MainPage extends StatefulWidget {
  final Customer account;

  const MainPage({Key? key, required this.account}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _MainPageState createState() => _MainPageState(account: account);
}

class _MainPageState extends State<MainPage> {
  late final Customer account;
  _MainPageState({required this.account});
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
                Text(
                  account.name,
                  style: const TextStyle(color: Colors.white),
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
          return Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: (option == 'Delivery')
                  //if true
                  ? _deliveryLocationPicker(context)
                  // if false
                  : _rideLocationPicker(context));
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
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LocationPickerPage(option: 'Current Location');
              }));
            },
          ),
          const Padding(padding: EdgeInsets.all(5)),
          CustomElevatedButton(
            child: const Text(
              "Pick Destination",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LocationPickerPage(option: 'Destination');
              }));
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
                onPressed: () {},
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
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LocationPickerPage(option: 'Current Location');
              }));
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
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    ),
  );
}
