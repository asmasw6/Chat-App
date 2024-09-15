class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String imageURL;
  final DateTime lastActive;

  ChatUser(
      {required this.uid,
      required this.name,
      required this.email,
      required this.imageURL,
      required this.lastActive});

  factory ChatUser.fromJSON(Map<String, dynamic> json) {
    return ChatUser(
        uid: json['uid'],
        name: json["name"],
        email: json["email"],
        imageURL: json['image'],
        lastActive: json["last_active"].toDate());
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      "last_active": lastActive,
      "Image": imageURL,
    };
  }

  String lastDayActive() {
    return '${lastActive.month}/${lastActive.day}/${lastActive.year}';
  }

  bool wasRecentelyActive() {
    return DateTime.now().difference(lastActive).inMinutes < 1;
  }
}
