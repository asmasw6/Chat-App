import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class AuthenticationProvider  extends ChangeNotifier{
  late final FirebaseAuth auth ;
  late final DatabaseService databaseService;
  late final NavigationService navigateServices;

  AuthenticationProvider(){
    auth =FirebaseAuth.instance;
    navigateServices = GetIt.instance.get<NavigationService>();
    databaseService = GetIt.instance.get<DatabaseService>();

    

  }
}