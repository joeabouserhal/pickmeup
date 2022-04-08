import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _textFieldController1 = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();

  //input info data
  String _rideLocation = '';
  String _rideDestination = '';

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
          title: Text(
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
        body: SizedBox(),
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
                  _displayDeliveryOrder(context);
                }),
            SpeedDialChild(
                child: const Icon(Icons.local_taxi_rounded),
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                label: 'Ride',
                onTap: () {
                  _displayRideOrder(context);
                }),
          ],
        ),
      ),
    );
  }

  // Ride Order Screen Pop Up Screen
  Future<void> _displayRideOrder(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14.0))),
              title: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(14.0)),
                  ),
                  child: const Text(
                    'Order a Ride',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                  onChanged: (value) {
                    _rideLocation = value;
                  },
                  controller: _textFieldController1,
                  decoration: const InputDecoration(hintText: "Your Location"),
                ),
                TextField(
                  onChanged: (value) {
                    _rideDestination = value;
                  },
                  controller: _textFieldController2,
                  decoration:
                      const InputDecoration(hintText: "Your Destination"),
                ),
              ]),
              actions: <Widget>[
                // Cancel Button
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _textFieldController1.clear();
                        _textFieldController2.clear();
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Add')),
              ],
            ),
          );
        });
  }

  //Delivery Order Screen Pop Up Screen
  Future<void> _displayDeliveryOrder(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14.0))),
              title: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(14.0)),
                      color: Theme.of(context).primaryColor),
                  child: const Text(
                    'Order a Delivery',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                // Missing Location Text Field
                TextField(
                  minLines: 4,
                  maxLines: 6,
                  onChanged: (value) {
                    _rideDestination = value;
                  },
                  controller: _textFieldController2,
                  decoration:
                      const InputDecoration(hintText: "Your Description"),
                ),
              ]),
              actions: <Widget>[
                // Cancel Button
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    )),
                // Submit button
                TextButton(
                    onPressed: () {
                      setState(() {
                        _textFieldController1.clear();
                        _textFieldController2.clear();
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Add')),
              ],
            ),
          );
        });
  }
}
