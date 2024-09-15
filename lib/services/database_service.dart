import 'package:cloud_firestore/cloud_firestore.dart';

const String User_Collection = "Users";

const String Chat_Collection = "Chats";
const String Message_Collection = "Messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DatabaseService() {}
}
