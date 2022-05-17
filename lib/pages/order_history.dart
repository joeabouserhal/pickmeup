import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RideHistory extends StatelessWidget {
  const RideHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "History",
        ),
        elevation: 3,
      ),
    );
  }
}
