import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  TEXT,
  IMAGE,
  UNKNOWN,
}

class ChatMessage {
  final String senderID;
  final MessageType type;
  final String content;
  final DateTime sentTime;

  ChatMessage({
    required this.content,
    required this.senderID,
    required this.sentTime,
    required this.type,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    MessageType messageType;
    switch (json['type']) {
      case "text":
        messageType = MessageType.TEXT;
        break;
      case "image":
        messageType = MessageType.IMAGE;
        break;
      default:
        messageType = MessageType.UNKNOWN;
    }

    return ChatMessage(
      content: json['content'],
      senderID: json['sender_id'],
      sentTime: json['sent_time'].toDate(),
      type: messageType,
    );
  }

  Map<String, dynamic> toJson() {
    String messageType;
    switch (type) {
      case MessageType.TEXT:
        messageType = "text";
        break;
      case MessageType.IMAGE:
        messageType = "image";
        break;
      default:
        messageType = "";
    }

    return {
      "contecnt": content,
      "type": type,
      "sent_time": Timestamp.fromDate(sentTime),
      "sender_id": senderID,
    };
  }
}
