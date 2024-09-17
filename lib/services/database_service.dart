import 'package:cloud_firestore/cloud_firestore.dart';

const String User_Collection = "Users";

const String Chat_Collection = "Chats";
const String Messages_Collection = "messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService() {}

  Future<DocumentSnapshot> getUser(String uid) async {
    return _db.collection(User_Collection).doc(uid).get();
  }

  Stream<QuerySnapshot> getChatForUser(String uid) {
    return _db
        .collection(Chat_Collection)
        .where("members", arrayContains: uid)
        .snapshots();
  }

  // get last message sent in chat and nobody typing in chat
  Future<QuerySnapshot> getLastMessageForChat(String chatID) {
    return _db
        .collection(Chat_Collection)
        .doc(chatID)
        .collection(Messages_Collection)
        .orderBy("sent_time", descending: true) // order all doc with collection
        .limit(1) // first doc limit 1 if 2 I will get the first tows
        .get();
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
