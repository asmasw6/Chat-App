import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';
import 'package:sukoon/models/chat_message.dart';
import 'package:sukoon/provider/authentication_provider.dart';
import 'package:sukoon/services/cloud_storage_service.dart';
import 'package:sukoon/services/database_service.dart';
import 'package:sukoon/services/media_service.dart';
import 'package:sukoon/services/navigation_service.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService db;
  late CloudStorageService storage;
  late MediaService media;

  late NavigationService navigation;
  AuthenticationProvider auth;
  ScrollController messagesListViewController;

  String chatId;
  List<ChatMessage>? messages;
  late StreamSubscription messagesStream;
  late StreamSubscription keyboardVisibilityStream;
  late KeyboardVisibilityController keyboardVisibilityController;

  String? message;

  String get getMessage {
    return message!;
  }

  void set setMessage(String value) {
    message = value;
  }

  ChatPageProvider(this.chatId, this.auth, this.messagesListViewController) {
    db = GetIt.instance.get<DatabaseService>();
    storage = GetIt.instance.get<CloudStorageService>();
    navigation = GetIt.instance.get<NavigationService>();
    media = GetIt.instance.get<MediaService>();
    keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
    listenToKeyboardChanges();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    messagesStream.cancel();

    super.dispose();
  }

  void listenToMessages() {
    try {
      messagesStream = db.stramMessagesForChat(chatId).listen(
        (event) {
          List<ChatMessage> messagesToList = event.docs.map(
            (M) {
              Map<String, dynamic> messageData =
                  M.data() as Map<String, dynamic>;
              return ChatMessage.fromJson(messageData);
            },
          ).toList();
          messages = messagesToList;
          notifyListeners();
          //Add Scroll To Bottom Call //'
          WidgetsBinding.instance!.addPostFrameCallback(
            (_) {
              if (messagesListViewController.hasClients) {
                messagesListViewController.jumpTo(
                    messagesListViewController.position.maxScrollExtent);
              }
            },
          );
        },
      );
    } catch (e) {
      print('Error getting messages');
      print(e);
    }
  }

  void listenToKeyboardChanges() {
    keyboardVisibilityStream = keyboardVisibilityController.onChange.listen(
      (event) {
        db.updateChatData(chatId, {"is_activity": event});
      },
    );
  }

  void deleteChat() {
    goBack(); // to prevent any chashes that happen aftter delete chat
    db.deleteChat(chatId);
  }

  void sendTextMessage() {
    if (message != null) {
      ChatMessage messageToSend = ChatMessage(
        content: message!,
        senderID: auth.User.uid,
        sentTime: DateTime.now(),
        type: MessageType.TEXT,
      );
      db.addMessageToChat(chatId, messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? file = await media.pickImageFromLibrary();
      print(">>>>>>>>>>. file is >>>${file}");
      if (file != null) {
        String? downloadURL =
            await storage.saveChatImageToStorage(chatId, auth.User.uid, file);
        print(" -----downloadURL-----> ${downloadURL}");
        ChatMessage imageToSend = ChatMessage(
          content: downloadURL!,
          senderID: auth.User.uid,
          sentTime: DateTime.now(),
          type: MessageType.IMAGE,
        );
        db.addMessageToChat(chatId, imageToSend);
      }
    } catch (e) {
      print("Error Sending image message.");
      print(e);
    }
  }

  void goBack() {
    navigation.goBack();
  }
}
