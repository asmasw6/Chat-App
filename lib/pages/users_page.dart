import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sukoon/models/chat_user.dart';
import 'package:sukoon/provider/authentication_provider.dart';
import 'package:sukoon/provider/users_page_provider.dart';
import 'package:sukoon/widgets/custom_input_fields.dart';
import 'package:sukoon/widgets/custom_list_view_tiles.dart';
import 'package:sukoon/widgets/rounded_button.dart';
import 'package:sukoon/widgets/top_bar.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double deviceHight;
  late double deviceWidth;
  late AuthenticationProvider auth;
  late UsersPageProvider pageProvider;
  final TextEditingController searchFieldEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    deviceHight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    auth = Provider.of<AuthenticationProvider>(context);
    //navigation = GetIt.instance.get<NavigationService>();
    return MultiProvider(providers: [
      ChangeNotifierProvider<UsersPageProvider>(
        create: (_) => UsersPageProvider(auth),
      ),
    ], child: buildUI());
  }

  Widget buildUI() {
    return Builder(
      builder: (context) {
        pageProvider = context.watch<UsersPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.03,
            vertical: deviceHight * 0.02,
          ),
          height: deviceHight * .98,
          width: deviceWidth * 0.97,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                "Users",
                primaryAction: IconButton(
                  onPressed: () {
                    auth.logout();
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Color.fromRGBO(13, 65, 154, 1),
                  ),
                ),
              ),
              CustomTextField(
                controller: searchFieldEditingController,
                hintText: "Search ...",
                obSecureText: false,
                icon: Icons.search,
                onEditingComplete: (p0) {
                  pageProvider.getUsers(name: p0);
                  FocusScope.of(context).unfocus();
                },
              ),
              userList(),
              craeteChatButton(),
            ],
          ),
        );
      },
    );
  }

  Widget userList() {
    List<ChatUser>? users = pageProvider.users;

    return Expanded(
      child: () {
        if (users != null) {
          if (users.length != 0) {
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return CustomListViewTiles(
                    height: deviceHight * 0.10,
                    title: users[index].name,
                    subTitle: "Last Active: ${users[index].lastDayActive()}",
                    imagePath: users[index].imageURL,
                    isActive: users[index].wasRecentelyActive(),
                    isSlected: pageProvider.selectUsers.contains(
                      users[index],
                    ),
                    onTap: () {
                      pageProvider.updateSelectedUsers(users[index]);
                    });
              },
            );
          } else {
            return const Center(
              child: Text(
                "No Users Found",
                style: TextStyle(color: Colors.white30),
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
      }(),
    );
  }

  Widget craeteChatButton() {
    return Visibility(
      visible: pageProvider.selectUsers.isNotEmpty,
        child: RoundedButton(
      height: deviceHight * .08,
      name: pageProvider.selectUsers.length == 1
          ? "Chat with ${pageProvider.selectUsers.first.name}"
          : "craete Group Chat",
      onPressed: () {
        pageProvider.createChat();
      },
      width: deviceWidth * .8,
    ));
  }
}

// problem in send image 
// problem when select user
