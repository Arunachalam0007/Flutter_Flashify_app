// Packages
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

// Services
import '../services/cloud_storage_service.dart';
import '../services/database_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';

// Providers

import '../providers/authentication_provider.dart';

// Models

import '../models/chat_message.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudStorageService _cloudStorageService;
  late MediaService _mediaService;
  late NavigationService _navigationService;

  late StreamSubscription _messageStream;

  // Keyboard activity
  late KeyboardVisibilityController _keyboardVisibilityController;
  late StreamSubscription _keyboardVisibilityStream;


  AuthenticationProvider _auth;
  ScrollController _messageScrollListViewController;

  String _chatId;
  List<ChatMessage>? messages;

  String? _message;

  String get message {
    return _message!;
  }

  set message(String _val){
    _message = _val;
  }

  ChatPageProvider(
    this._chatId,
    this._auth,
    this._messageScrollListViewController,
  ) {
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _mediaService = GetIt.instance.get<MediaService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
    _listenToKeyboardChanges();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _messageStream.cancel();
    super.dispose();
  }

  void goBack() {
    _navigationService.goBack();
  }

  void _listenToKeyboardChanges(){
    // Subscribe
    _keyboardVisibilityStream = _keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      _db.updateChatData(_chatId, {'is_activity':visible});
    });
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage _sendMessage = ChatMessage(
        content: _message!,
        senderId: _auth.chatUser.uid,
        sentTime: DateTime.now(),
        type: MessageType.TEXT,
      );
      _db.addMessagesToChat(_chatId, _sendMessage);
    }
  }

  void sendImageFile() async {
    try {
      PlatformFile? _file = await _mediaService.pickImageFromLibrary();
      if (_file != null) {
        String? _downloadURL =
            await _cloudStorageService.saveChatImageToStorage(
          _chatId,
          _auth.chatUser.uid,
          _file,
        );
        ChatMessage _sendMessage = ChatMessage(
          content: _downloadURL!,
          senderId: _auth.chatUser.uid,
          sentTime: DateTime.now(),
          type: MessageType.IMAGE,
        );
        _db.addMessagesToChat(_chatId, _sendMessage);
      }
    } catch (e) {
      print('Error Seding Image message.');
      print(e);
    }
  }

  void listenToMessages() {
    try {
      _messageStream = _db.streamMessagesForChat(_chatId).listen((_snapShot) {
        //Getting all the Messages for the Chat
        List<ChatMessage> _chatMessages = _snapShot.docs.map((_m) {
          Map<String, dynamic> _messageData = _m.data() as Map<String, dynamic>;
          return ChatMessage.fromJSON(_messageData);
        }).toList();
        messages = _chatMessages;
        notifyListeners();
        // WidgetBinding add Post Frame call
        // This is used to call after the frameworkloaded
        // execute this messagescrollList view controller
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          _messageScrollListViewController.jumpTo(_messageScrollListViewController.position.maxScrollExtent);
        });
      });

    } catch (e) {
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChats(_chatId);
  }
}
