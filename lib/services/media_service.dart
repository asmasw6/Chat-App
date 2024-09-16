import 'dart:io';

import 'package:file_picker/file_picker.dart';

class MediaService {
  MediaService() {}


  Future<PlatformFile?> pickImageFromLibrary() async {
    FilePickerResult? _result =
        await FilePicker.platform.pickFiles(type: FileType.image);
/*
    if (_result != null) {
      // first entry
      return _result.files.single.path!;
      //_result.files[0];
    
    }
    */
    if (_result != null && _result.files.isNotEmpty) {
    // Return the PlatformFile object from the result
    return _result.files.first;
  }

    return null;
  }
}
