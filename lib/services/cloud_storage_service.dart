import 'dart:io';

// packages

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

const String USER_COLLECTION = 'Users';

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Save User Image to FireStorage
  Future<String?> saveUserImageToStorage(String _uid, PlatformFile _file) async {
    try {
      Reference _ref =
          _storage.ref().child('images/users/${_uid}/profile.${_file.extension}');
      UploadTask _task = _ref.putFile(File(_file.path!));
      return await _task.then(
        (_result) => _result.ref.getDownloadURL(),
      );
    } catch (e) {
      print(e);
    }
  }
  // Save User Chat Image to FireStorage
  Future<String?> saveChatImageToStorage(String _chatID,String uid, PlatformFile _file) async {
    try {
      Reference _ref =
      _storage.ref().child('images/chats/$_chatID/${uid}_${Timestamp.now().millisecondsSinceEpoch}.${_file.extension}');
      UploadTask _task = _ref.putFile(File(_file.path!));
      return await _task.then(
            (_result) => _result.ref.getDownloadURL(),
      );
    } catch (e) {
      print(e);
    }
  }
}
