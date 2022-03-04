import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //Google Maps Data
  late GoogleMapController _googleMapController;
  final _initialCameraPosition =
      const CameraPosition(target: LatLng(33.895970, 35.846559), zoom: 8.5);

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Pick Me Up',
              style: GoogleFonts.ptSans(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0,
                  shadows: <Shadow>[
                    const Shadow(color: Colors.black26, blurRadius: 5)
                  ])),
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
        body: GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (controller) => _googleMapController = controller,
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
                onTap: () {}),
            SpeedDialChild(
                child: const Icon(Icons.local_taxi_rounded),
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                label: 'Ride',
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}
