import 'package:cloud_firestore/cloud_firestore.dart';

const String User_Collection = "Users";

const String Chat_Collection = "Chats";
const String Message_Collection = "Messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService() {}

  Future<DocumentSnapshot> getUser(String uid) async {
    return _db.collection(User_Collection).doc(uid).get();
  }

  Future<void> upDateUserLastSeenTime(String uid) async {
    try {
      await _db
          .collection(User_Collection)
          .doc(uid)
          .update({'last_active': DateTime.now().toUtc()});
    } catch (e) {
      print(e);
    }
  }

  Future<void> createUser(
      String uid, String email, String name, String imageURL) async {
    try {
      await _db.collection(User_Collection).doc(uid).set({
        "name": name,
        "email": email,
        "last_active": DateTime.now().toUtc(),
        "image": imageURL,
      });
    } catch (e) {
      print(e);
    }
  }
}
