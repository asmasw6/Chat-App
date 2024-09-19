import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:sukoon/models/chat_user.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth auth;
  late final DatabaseService databaseService;
  late final NavigationService navigateServices;
  late ChatUser User;

  AuthenticationProvider() {
    auth = FirebaseAuth.instance;
    navigateServices = GetIt.instance.get<NavigationService>();
    databaseService = GetIt.instance.get<DatabaseService>();

    //auth.signOut();
    auth.authStateChanges().listen(
      (user) async {
        if (user != null) {
          print("Logged in >>>>>");
          await databaseService.upDateUserLastSeenTime(user.uid);
          await databaseService.getUser(user.uid).then((snapshot) {
            if (snapshot.exists) {
              Map<String, dynamic> userData =
                  snapshot.data()! as Map<String, dynamic>;

              // Assign data to the current user object
               User = ChatUser.fromJSON({
                'uid': user.uid,
                'name': userData['name'],
                'email': userData['email'],
                'last_active': userData['last_active'],
                'image': userData['image'],
              });

              print("User>>> ${User}");
              // Navigate to home page after setting the user
              navigateServices.removeAndNavigateToRoute('/home');
            } else {
              print("No user data found for UID: ${user.uid}");
            }
          }).catchError((error) {
            print("Error fetching user data: $error");
          });

          /*
          await databaseService.getUser(user.uid).then((snapshot) {
            Map<String, dynamic> userData =
                snapshot.data() as Map<String, dynamic>;
            User = ChatUser.fromJSON({
              'uid': user.uid,
              "name": userData['name'],
              "email": userData['email'],
              "last_active": userData['last_active'],
              "image": userData['image'],
            });
            print("User>>> ${User}");
            ////print("User>>> ${User.toMap()}");
            navigateServices.removeAndNavigateToRoute('/home');
          });
          */
        } else {
          print("NOT Logged in");
          navigateServices.removeAndNavigateToRoute('/login');
        }
      },
    );
  }

  Future<void> loginUsingEmailAndPass(String email, String pass) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: pass);
      //print(auth.currentUser);
    } on FirebaseAuthException {
      print("Error loggin user into Firebase");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserUsingEmailAndPass(
      String email, String pass) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      return credential.user!.uid;
    } on FirebaseAuthException {
      print("Error register user into Firebase");
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
