import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sukoon/models/chat.dart';
import 'package:sukoon/models/chat_message.dart';
import 'package:sukoon/models/chat_user.dart';
import 'package:sukoon/pages/chat_page.dart';
import 'package:sukoon/provider/authentication_provider.dart';
import 'package:sukoon/provider/chats_page_provider.dart';
import 'package:sukoon/services/navigation_service.dart';
import 'package:sukoon/widgets/custom_list_view_tiles.dart';
import 'package:sukoon/widgets/top_bar.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double _deviceHight;
  late double _deviceWidth;
  late AuthenticationProvider auth;
  late ChatsPageProvider pageProvider;
  late NavigationService navigation;

  @override
  Widget build(BuildContext context) {
    _deviceHight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    navigation = GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (context) => ChatsPageProvider(
            auth,
          ),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (context) {
        // provider watch
        pageProvider = context.watch<ChatsPageProvider>();
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
              // Generate chat Tile
              chatList(),
            ],
          ),
        );
      },
    );
  }

  Widget chatList() {
    List<Chat>? chats = pageProvider.chats;
    print(">>>> Chats ${chats}");

    return Expanded(
      child: (() {
        //this define function
        if (chats != null) {
          if (chats.length != 0) {
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return chatTile(
                  chats[index],
                );
              },
            );
          } else {
            return const Center(
                child: Text(
              "No Chats Found. ",
              style: TextStyle(color: Colors.white),
            ));
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      })(),
    );
  }

  Widget chatTile(Chat chatItem) {
    List<ChatUser> recepients = chatItem.getRecepients();
    bool isActive = recepients.any(
      (element) => element.wasRecentelyActive(),
    );
    String subTitleText = "";
    if (chatItem.messages.isNotEmpty) {
      subTitleText = chatItem.messages.first.type != MessageType.TEXT
          ? "Media Attachement"
          : chatItem.messages.first.content;
    }
    return CustomListViewTilesWithActivity(
      height: _deviceHight * .1,
      title: chatItem.title(),
      subTitle: subTitleText,
      imagePath: chatItem.imageURL(),
      //"https://i.pravatar.cc/300"
      isActive: isActive,
      isActivity: chatItem.activity,
      onTap: () {
        navigation.navigateToPage(ChatPage(
          chat: chatItem,
        ));
      },
    );
  }
}
