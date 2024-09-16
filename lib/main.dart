import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sukoon/pages/home_page.dart';
import 'package:sukoon/pages/login_page.dart';
import 'package:sukoon/pages/register_page.dart';
import 'package:sukoon/pages/splash_page.dart';
import 'package:sukoon/provider/authentication_provider.dart';
import 'package:sukoon/services/navigation_service.dart';
import 'package:firebase_app_check/firebase_app_check.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(false);

  runApp(SplashPage(
    onInitializationComplete: () {
      runApp(
        MainApp(),
      );
    },
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (context) {
            return AuthenticationProvider();
          },
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Cahtify",
        theme: ThemeData(
            dialogBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
            scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Color.fromRGBO(30, 29, 37, 1.0))),
        navigatorKey: NavigationService.navigatorkey,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/register': (context) => const RegisterPage(),
        },
      ),
    );
  }
}
