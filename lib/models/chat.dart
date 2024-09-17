import 'package:sukoon/models/chat_message.dart';
import 'package:sukoon/models/chat_user.dart';

class Chat {
  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  List<ChatMessage> messages;

  late final List<ChatUser> recepients;

  Chat({
    required this.uid,
    required this.currentUserUid,
    required this.activity,
    required this.members,
    required this.messages,
    required this.group,
  }){

 recepients = members.where((element) => element.uid != currentUserUid,).toList();
  }

  List<ChatUser> getRecepients(){
    return  recepients;

  }

  String title(){
    return !group? recepients.first.name: recepients.map((e) => e.name,).join(", ");
  }

  String imageURL(){
    return !group? recepients.first.imageURL :"https://i.pravatar.cc/1000?img=65";
  }
}
