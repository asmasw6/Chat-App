import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sukoon/provider/authentication_provider.dart';
import 'package:sukoon/widgets/top_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHight;
  late double _deviceWidth;
  late AuthenticationProvider auth;

  @override
  Widget build(BuildContext context) {
    _deviceHight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);

    return buildUI();
  }

  Widget buildUI() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth * .03,
        vertical: _deviceHight * .02,
      ),
      height: _deviceHight * .98,
      width: _deviceWidth * .97,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TopBar(
            "Chats",
            primaryAction: IconButton(
                onPressed: () {
                  auth.logout();
                },
                icon: const Icon(
                  Icons.logout,
                  color: Color.fromRGBO(13, 65, 154, 1),
                )),
          ),
        ],
      ),
    );
  }
}
