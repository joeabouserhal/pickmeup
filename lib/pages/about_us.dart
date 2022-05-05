import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

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
          "About Us",
        ),
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Center(
                child: Icon(
                  Icons.perm_device_information_rounded,
                  size: 100,
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Text(
                "Devs:",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                " - Joe Abou Serhal",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "Project Members:",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                " - Mohamad Yassine\n - Hadi El-Hajj",
                style: TextStyle(fontSize: 16),
              )
            ]),
      ),
    );
  }
}
