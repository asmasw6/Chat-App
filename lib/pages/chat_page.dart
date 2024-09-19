import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sukoon/models/chat.dart';
import 'package:sukoon/models/chat_message.dart';
import 'package:sukoon/provider/authentication_provider.dart';
import 'package:sukoon/provider/chat_page_provider.dart';
import 'package:sukoon/services/media_service.dart';
import 'package:sukoon/widgets/custom_input_fields.dart';
import 'package:sukoon/widgets/custom_list_view_tiles.dart';
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
  late GlobalKey<FormState> messageFormState;
  late ScrollController messagesListViewController;

  // ??
  PlatformFile? profileImage;


  @override
  void initState() {
    super.initState();
    messageFormState = GlobalKey<FormState>();
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
                      onPressed: () {
                        pageProvider.deleteChat();
                      },
                      icon: Icon(Icons.delete),
                      color: Color.fromRGBO(13, 65, 154, 1),
                    ),
                    secondaryAction: IconButton(
                      onPressed: () {
                        pageProvider.goBack();
                      },
                      icon: Icon(Icons.arrow_back),
                      color: Color.fromRGBO(13, 65, 154, 1),
                    ),
                  ),
                  // list of messages
                  messagesListView(),
                  sendMessageForm(),
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
            controller: messagesListViewController,
            itemCount: pageProvider.messages!.length,
            itemBuilder: (context, index) {
              ChatMessage messageData = pageProvider.messages![index];
              bool isOwnMessage = messageData.senderID == auth.User.uid;
              return Container(
                  child: CustomeChatListViewTile(
                height: _deviceHight,
                width: _deviceWidth * .80,
                isOwnMessage: isOwnMessage,
                message: messageData,
                sender: this
                    .widget
                    .chat
                    .members
                    .where((element) => element.uid == messageData.senderID)
                    .first,
              ));
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

  Widget sendMessageForm() {
    return Container(
      height: _deviceHight * 0.06,
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.02, vertical: _deviceHight * 0.01),
      child: Form(
        key: messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageMessageButton(),
            messageTextField(),
            sendMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget messageTextField() {
    return SizedBox(
      width: _deviceWidth * .65,
      child: CustomInputFields(
          onSaved: (p0) {
            pageProvider.setMessage = p0;
          },
          regEx: r"^(?!\s*$).+",
          hintText: "type a message",
          obsecureText: false),
    );
  }

  Widget sendMessageButton() {
    double size = _deviceHight * .04;
    return Container(
      height: size * 1.2,
      width: size,
      child: IconButton(
        onPressed: () {
          if (messageFormState.currentState!.validate()) {
            messageFormState.currentState!.save();
            pageProvider.sendTextMessage();
            messageFormState.currentState!.reset();
          }
        },
        icon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget imageMessageButton() {
    double size = _deviceHight * .04;
    return Container(
        height: size,
        width: size,
        child: FloatingActionButton(
          child: Icon(
            Icons.camera_enhance,
            color: Colors.white,
          ),
          onPressed: () async {
            //----------------------------------------------
            var status = await Permission.storage.request();

            if (status.isGranted) {
              // Pick image from library
              
              pageProvider.sendImageMessage();
            }
          },
          backgroundColor: Color.fromRGBO(0, 82, 218, 1),
        ));
  }
}
