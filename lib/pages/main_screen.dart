import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pickmeup/pages/location_picker_screen.dart';
import 'package:pickmeup/widgets/common_elevated_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
            'Pick Me Up',
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
              child: const Center(child: Text('Account Name')),
            ),
          ]),
        ),
        //* The Map
        body: OSMFlutter(
          controller: mapController,
          trackMyPosition: true,
          // for testing purpose
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
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
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
    await mapController.setZoom(zoomLevel: 15);
  }
}

_rideLocationPicker(context) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomElevatedButton(
          child: const Text("Pick Current Location"),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LocationPickerScreen(option: 'Current Location');
            }));
          },
        ),
        const Padding(padding: EdgeInsets.all(5)),
        CustomElevatedButton(
          child: const Text("Pick Destination"),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LocationPickerScreen(option: 'Destination');
            }));
          },
        )
      ],
    ),
  );
}

_deliveryLocationPicker(context) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomElevatedButton(
          child: const Text("Pick Current Location"),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LocationPickerScreen(option: 'Current Location');
            }));
          },
        )
      ],
    ),
  );
}
