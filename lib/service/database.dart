import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Future addUsers(Map<String, dynamic> user, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(user);
  }
}
