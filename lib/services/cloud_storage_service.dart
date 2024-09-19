import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

const String User_Collection = "Users";

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageService() {}

  Future<String?> saveUserImageToStorage(String uid, PlatformFile? file) async {
    if (file == null) {
      print("No file provided");
      return null; // Handle the null case for the file
    }
/*
    try {
      // Define the storage reference path
      Reference ref =
          _storage.ref().child('images/users/$uid/profile.${file.extension}');

      // Upload the file
      UploadTask task = ref.putFile(File(file.path!));

      // Await and return the download URL after the upload is complete
      return await task.then((result) async {
        return await result.ref.getDownloadURL();
      });
      */
    try {
      Reference ref = _storage
          .ref()
          .child('images/users/${uid}/profile.${file!.extension}');

      UploadTask task = ref.putFile(
        File(file.path!),
      );

      return await task.then(
        (result) async {
          return await result.ref.getDownloadURL();
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<String?> saveChatImageToStorage(
      String chatID, String userID, PlatformFile? file) async {
    try {
      Reference ref = _storage.ref().child(
          'images/chats/${chatID}/${userID}_${Timestamp.now().millisecondsSinceEpoch}.${file!.extension}');

      UploadTask task = ref.putFile(
        File(file.path!),
      );

      // return await task.then((result) => result.ref.getDownloadURL(),
      /*
        (result) {
          result.ref.getDownloadURL();
        },
        */
      //);

      return await task.then(
        (result) async {
          return await result.ref.getDownloadURL();
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
