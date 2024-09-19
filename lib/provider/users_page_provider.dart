import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sukoon/models/chat.dart';
import 'package:sukoon/models/chat_user.dart';
import 'package:sukoon/pages/chat_page.dart';
import 'package:sukoon/provider/authentication_provider.dart';
import 'package:sukoon/services/database_service.dart';
import 'package:sukoon/services/navigation_service.dart';

class UsersPageProvider extends ChangeNotifier {
  late AuthenticationProvider auth;
  late DatabaseService database;
  late NavigationService navigation;
  List<ChatUser>? users;
  late List<ChatUser> selectUsers;

  List<ChatUser> get getSelectedUser {
    return selectUsers;
  }

  UsersPageProvider(this.auth) {
    selectUsers = [];
    database = GetIt.instance.get<DatabaseService>();
    navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getUsers({String? name}) {
    selectUsers = [];
    try {
      database.getUsers(name: name).then(
        (snapShot) {
          users = snapShot.docs.map(
            (doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data['uid'] = doc.id;
              return ChatUser.fromJSON(data);
            },
          ).toList();
          notifyListeners();
        },
      );
    } catch (e) {
      print("Error getting Usersss;");
      print(e);
    }
  }

  void updateSelectedUsers(ChatUser user) {
    if (selectUsers.contains(user)) {
      selectUsers.remove(user);
    } else {
      selectUsers.add(user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      // Create chat
      List<String> memberIds = selectUsers
          .map(
            (user) => user.uid,
          )
          .toList();
      memberIds.add(auth.User.uid);
      bool isGroup = selectUsers.length > 1;
      DocumentReference? doc = await database.createChat(
        {
          "is_group": isGroup,
          "is_activity": false,
          "members": memberIds,
        },
      );
      // Navigate to caht page
      List<ChatUser> members = [];
      for (var uid in memberIds) {
        DocumentSnapshot userSnapshot = await database.getUser(uid);
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        userData["uid"] = userSnapshot.id;
        members.add(
          ChatUser.fromJSON(
            userData,
          ),
        );
      }

      ChatPage chatPage = ChatPage(
        chat: Chat(
          uid: doc!.id,
          currentUserUid: auth.User.uid,
          activity: false,
          members: members,
          messages: [],
          group: isGroup,
        ),
      );
      selectUsers = [];
      notifyListeners();
      navigation.navigateToPage(chatPage);
    } catch (e) {
      print("Error creating chat");
      print(e);
    }
  }
}
