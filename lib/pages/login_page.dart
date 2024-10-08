import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sukoon/provider/authentication_provider.dart';
import 'package:sukoon/services/navigation_service.dart';
import 'package:sukoon/widgets/custom_input_fields.dart';
import 'package:sukoon/widgets/rounded_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceHight;
  late double _deviceWidth;

  final _loginFormKey = GlobalKey<FormState>();

  String? email;
  String? pass;
  late AuthenticationProvider auth;
  late NavigationService navigation;

  @override
  Widget build(BuildContext context) {
    _deviceHight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    navigation = GetIt.instance.get<NavigationService>();

    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * .03,
          vertical: _deviceHight * .02,
        ),
        //------- for container -------
        height: _deviceHight * .98,
        width: _deviceWidth * .97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pageTitle(),
            SizedBox(
              height: _deviceHight * 0.04,
            ),
            _loginForm(),
            SizedBox(
              height: _deviceHight * 0.05,
            ),
            _loginButton(),
            SizedBox(
              height: _deviceHight * 0.02,
            ),
            _registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return Container(
      height: _deviceHight * .10,
      child: const Text(
        "Chatify",
        style: TextStyle(
            color: Colors.white, fontSize: 40, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: _deviceHight * .18,
      child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomInputFields(
                  onSaved: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  regEx: r'[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                  hintText: 'Email',
                  obsecureText: false),
              CustomInputFields(
                  onSaved: (value) {
                    setState(() {
                      pass = value;
                    });
                  },
                  regEx: r'.{8,}',
                  hintText: 'Password',
                  obsecureText: true),
            ],
          )),
    );
  }

  Widget _loginButton() {
    return RoundedButton(
      height: _deviceHight * 0.065,
      width: _deviceWidth * 0.65,
      name: "Login",
      onPressed: () {
        if (_loginFormKey.currentState!.validate()) {
          _loginFormKey.currentState!.save();
          auth.loginUsingEmailAndPass(email!, pass!);
        }
      },
    );
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () {
        navigation.navigateToRoute("/register");
      },
      child: Container(
        child: const Text(
          "Don\'t have an account?",
          style: TextStyle(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
