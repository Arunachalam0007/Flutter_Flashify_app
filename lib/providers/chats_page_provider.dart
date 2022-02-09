// Packages

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// Services

import '../services/database_service.dart';

// Models

import '../models/chat_user.dart';
import '../models/chat_message.dart';
import '../models/chat.dart';

// Providers

import '../providers/authentication_provider.dart';

class ChatsPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;
  late DatabaseService _db;
  List<Chat>? chats;
  late StreamSubscription _chatStream;

  ChatsPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    getChatData();
  }

  @override
  void dispose() {
    //It will call when theres no reading it's automatically calling this func
    // TODO: implement dispose
    _chatStream.cancel();
    super.dispose();
  }

  void getChatData() async {
    try{
      _chatStream =
          _db.getChatsBasedOnUserId(_auth.chatUser.uid).listen((_snapShot) async {

            // Future.Wait is used to return List of Chat instead of Iterable<>
            chats = await Future.wait(
              _snapShot.docs.map(
                    (_d) async {
                  // Getting Chat Data
                  Map<String, dynamic> _chatData = _d.data() as Map<String, dynamic>;
                  // Getting Chat Members
                  List<ChatUser> _chatMembers = [];

                  for(var _memberId in _chatData['members']){
                    DocumentSnapshot _userSnapshot =
                    await _db.getLoggedInUserData(_memberId);
                    Map<String, dynamic> _user =
                    _userSnapshot.data() as Map<String, dynamic>;
                    _user['uid'] = _userSnapshot.id;
                    _chatMembers.add(ChatUser.fromJSON(_user),);
                  }

                  // _chatData['members'].map((_memberId) async {
                  //   print('DEBUG: _CHAT Mem ID: $_memberId');
                  //   DocumentSnapshot _userSnapshot =
                  //   await _db.getLoggedInUserData(_memberId);
                  //   Map<String, dynamic> _user =
                  //   _userSnapshot.data() as Map<String, dynamic>;
                  //   _user['uid'] = _userSnapshot.id;
                  //   print('DEBUG: UserData: $_user');
                  //   _chatMembers.add(ChatUser.fromJSON(_user));
                  // });

                  // Getting Chat Messages

                  List<ChatMessage> _chatMessages = [];

                  QuerySnapshot _chatMessage = await _db.getLastChatMessage(_d.id);
                  if(_chatMessage.docs.isNotEmpty){
                    Map<String,dynamic> _messageData = _chatMessage.docs.first.data()! as  Map<String,dynamic>;
                    _chatMessages.add(
                        ChatMessage.fromJSON(_messageData)
                    );
                  }

                  // Returning Single Chat of Map Document
                  return Chat(
                    uid: _d.id,
                    currentUserUid: _auth.chatUser.uid,
                    members: _chatMembers,
                    messages: _chatMessages,
                    activity: _chatData['is_activity'],
                    group: _chatData['is_group'],
                  );
                },
              ).toList(),
            );
            // Notify to Providers to update and re-render the UI
            notifyListeners();
          });
    } catch (e){
      print('Error Getting in Chats...');
      print(e);
    }
  }
}
