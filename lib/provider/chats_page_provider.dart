import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sukoon/models/chat_message.dart';
import 'package:sukoon/models/chat_user.dart';
import 'package:sukoon/provider/authentication_provider.dart';
import 'package:sukoon/services/database_service.dart';
import 'package:sukoon/models/chat.dart';

class ChatsPageProvider extends ChangeNotifier {
  AuthenticationProvider auth;
  late DatabaseService db;
  List<Chat>? chats;

  late StreamSubscription chatStream;
  ChatsPageProvider(this.auth) {
    db = GetIt.instance.get<DatabaseService>();
    getChats();
  }


  @override
  void dispose() {
    // TODO: implement
    chatStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      chatStream = db.getChatForUser(auth.User.uid).listen((event) async {
        chats = await Future.wait(
          event.docs.map(
            (doc) async {
              Map<String, dynamic> chatData =
                  doc.data() as Map<String, dynamic>;
              //Get Users In Chat
              List<ChatUser> _members = [];
              for (var uid in chatData["members"]) {
                DocumentSnapshot userSnapshot = await db.getUser(uid);
                Map<String, dynamic> userData =
                    userSnapshot.data() as Map<String, dynamic>;
                userData['uid'] = userSnapshot.id;
                _members.add(
                  ChatUser.fromJSON(userData),
                );
              }
              //Get Last Message For Chat
              List<ChatMessage> _messages = [];
              QuerySnapshot chatMessage =
                  await db.getLastMessageForChat(doc.id);
              if (chatMessage.docs.isNotEmpty) {
                Map<String, dynamic> messageData =
                    chatMessage.docs.first.data()! as Map<String, dynamic>;

                ChatMessage _message = ChatMessage.fromJson(messageData);
                _messages.add(_message);
              }

              //Return Chat Instance
              return Chat(
                uid: doc.id,
                currentUserUid: auth.User.uid,
                activity: chatData['is_activity'],
                members: _members,
                messages: _messages,
                group: chatData['is_group'],
              );
            },
          ).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print(" >>> Error getting Chats..");
      print(e);
    }
  }
}
