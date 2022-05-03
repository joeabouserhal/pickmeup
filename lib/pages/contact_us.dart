import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

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
          "Contact Us",
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
                  Icons.mail_rounded,
                  size: 100,
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Text(
                " - Joe Abou Serhal",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "joeabouserhal77777@gmail.com",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              Text(
                " - Mohamad Yassine\n - Hadi El-Hajj",
                style: TextStyle(fontSize: 16),
              )
            ]),
      ),
    );
  }
}
