import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  Future<String> getFullName(uid) async {
    var a = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return a['first_name'] + " " + a['last_name'];
  }

  Future<String> getFullNameDriver(uid) async {
    var a =
        await FirebaseFirestore.instance.collection("drivers").doc(uid).get();
    return a['first_name'] + " " + a['last_name'];
  }

  Future<String> getPhoneNumber(uid) async {
    var a = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return a['phone_number'];
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllRides() =>
      FirebaseFirestore.instance.collection('rides').snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllDeliveries() =>
      FirebaseFirestore.instance.collection('deliveries').snapshots();
}
