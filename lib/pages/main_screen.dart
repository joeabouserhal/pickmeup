import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _textFieldController1 = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();

  // OSM Map controller
  MapController mapController = MapController(
    initMapWithUserPosition: true,
    // center to lebanon by default
    initPosition: GeoPoint(latitude: 33.8547, longitude: 35.8623),
  );

  void dispose() {
    mapController.dispose();
  }

  //input info data
  late String _rideLocation = '';
  late String _rideDestination = '';

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
          elevation: 0,
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
          trackMyPosition: false,
          // for testing purpose
          androidHotReloadSupport: true,
          initZoom: 15,
          stepZoom: 1.0,
          userLocationMarker: UserLocationMaker(
            personMarker: const MarkerIcon(
              icon: Icon(Icons.location_history_rounded,
                  color: Colors.red, size: 48),
            ),
            directionArrowMarker: const MarkerIcon(
              icon: Icon(Icons.double_arrow_rounded),
            ),
          ),
        ),
        floatingActionButton: SpeedDial(
          label: const Text("Order"),
          spacing: 6,
          spaceBetweenChildren: 6,
          overlayColor: Colors.black,
          overlayOpacity: 0,
          foregroundColor: Colors.white,
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
                child: const Icon(Icons.delivery_dining_rounded),
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                label: 'Delivery',
                onTap: () {
                  //route to page
                }),
            SpeedDialChild(
                child: const Icon(Icons.local_taxi_rounded),
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                label: 'Ride',
                onTap: () {
                  // route to page
                }),
          ],
        ),
      ),
    );
  }
}
