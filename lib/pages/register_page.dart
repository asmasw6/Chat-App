//Packages
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sukoon/services/navigation_service.dart';

//Services
import '../services/cloud_storage_service.dart';
import '../services/database_service.dart';
import '../services/media_service.dart';

//Widgets
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';
import 'package:sukoon/widgets/rounded_image.dart';

//Providers
import '../provider/authentication_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHight;
  late double _deviceWidth;

  String? email;
  String? pass;
  String? name;

  late AuthenticationProvider auth;
  late DatabaseService db;
  late CloudStorageService cloudStorage;
  late NavigationService navigation;

  PlatformFile? profileImage;
  final registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthenticationProvider>(context);
    db = GetIt.instance.get<DatabaseService>();
    cloudStorage = GetIt.instance.get<CloudStorageService>();
    navigation = GetIt.instance.get<NavigationService>();
    _deviceHight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * .03, vertical: _deviceHight * .02),
        height: _deviceHight * .98,
        width: _deviceWidth * .97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            profileImageField(),
            SizedBox(
              height: _deviceHight * .05,
            ),
            registerForm(),
            SizedBox(
              height: _deviceHight * .04,
            ),
            registerButton(),
            SizedBox(
              height: _deviceHight * .02,
            ),
          ],
        ),
      ),
    );
  }

  Widget profileImageField() {
    return GestureDetector(
      onTap: () async {
        var status = await Permission.storage.request();

        if (status.isGranted) {
          // Pick image from library
          final file =
              await GetIt.instance.get<MediaService>().pickImageFromLibrary();

          if (file != null) {
            setState(() {
              profileImage = file; // Update the state with the selected file
            });
          } else {
            print("No image selected");
          }
        } else {
          // Handle the case when permission is denied
          print("Storage permission is denied.");
        }
/*
        if (status.isGranted) {
          GetIt.instance
              .get<MediaService>()
              .pickImageFromLibrary()
              .then((file) {
            setState(() {
              profileImage = file;
            });
          });
        } else {
          // Handle the case when permission is denied
          print("Storage permission is denied.");
        }*/
      },
      child: () {
        if (profileImage != null) {
          print('--------------------------------------------${profileImage!}');
          return RoundedImageFile(
            image: profileImage!,
            size: _deviceHight * .15,
          );
        } else {
          return RoundedImage(
            imagePath: 'https://i.pravatar.cc/1000?img=65',
            size: _deviceHight * .15,
          );
        }
      }(),
    );
  }

  Widget registerForm() {
    return Container(
      height: _deviceHight * .35,
      child: Form(
        key: registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomInputFields(
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                },
                regEx: r'.{10,}',
                hintText: "Name",
                obsecureText: false),
            CustomInputFields(
                onSaved: (value) {
                  setState(() {
                    email = value;
                  });
                },
                regEx: r'[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                hintText: "Email",
                obsecureText: false),
            CustomInputFields(
                onSaved: (value) {
                  setState(() {
                    pass = value;
                  });
                },
                regEx: r'.{8,}',
                hintText: "Password",
                obsecureText: true),
          ],
        ),
      ),
    );
  }

  Widget registerButton() {
    return RoundedButton(
        height: _deviceHight * .065,
        name: "Register",
        onPressed: () async {
          if (registerFormKey.currentState!.validate() &&
              profileImage != null) {
            // continue with register the user
            registerFormKey.currentState!.save();
            String? uid =
                await auth.registerUserUsingEmailAndPass(email!, pass!);
            String? imageURL = await cloudStorage.saveUserImageToStorage(
                uid!, profileImage);
            await db.createUser(uid, email!, name!, imageURL!);
            await auth.logout();
            await auth.loginUsingEmailAndPass(email!, pass!);
            //navigation.goBack();
          }
        },
        width: _deviceWidth * .65);
  }
}
