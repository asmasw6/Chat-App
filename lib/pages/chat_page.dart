import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sukoon/models/chat.dart';
import 'package:sukoon/provider/authentication_provider.dart';
import 'package:sukoon/provider/chat_page_provider.dart';
import 'package:sukoon/services/navigation_service.dart';
import 'package:sukoon/widgets/top_bar.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({required this.chat, super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHight;
  late double _deviceWidth;

  late AuthenticationProvider auth;
  late ChatPageProvider pageProvider;
  late GlobalKey<FormState> messgaFormState;
  late ScrollController messagesListViewController;

  @override
  void initState() {
    super.initState();
    messgaFormState = GlobalKey<FormState>();
    messagesListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    //navigation = GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (context) => ChatPageProvider(
            this.widget.chat.uid,
            auth,
            messagesListViewController,
          ),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (context) {
        pageProvider = context.watch<ChatPageProvider>();
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: _deviceHight * .02,
                horizontal: _deviceWidth * .03,
              ),
              height: _deviceHight,
              width: _deviceWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopBar(
                    this.widget.chat.title(),
                    fontSize: 13,
                    primaryAction: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.delete),
                      color: Color.fromRGBO(13, 65, 154, 1),
                    ),
                    secondaryAction: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_back),
                      color: Color.fromRGBO(13, 65, 154, 1),
                    ),
                  ),
                  // list of messages 
                  messagesListView(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget messagesListView() {
    if (pageProvider.messages != null) {
      if (pageProvider.messages!.length != 0) {
        return Container(
          height: _deviceHight * .74,
          child: ListView.builder(
            itemCount: pageProvider.messages!.length,
            itemBuilder: (context, index) {
              return Container(
                child: Text(
                  pageProvider.messages![index].content,
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            "Be first to say Hi!",
            style: TextStyle(color: Colors.white10),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }
}
