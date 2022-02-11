// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashify_app/models/chat.dart';
import 'package:flashify_app/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Model
import '../models/chat_user.dart';

// Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

// Providers
import '../providers/authentication_provider.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;
  late DatabaseService _db;
  late NavigationService _navService;

  List<ChatUser>? listOfUsers;

  List<ChatUser>? users;

  late List<ChatUser> _selectedUsers;

  String selectedUserName = '';

  List<ChatUser> get selectedUsers {
    return _selectedUsers;
  }

  UsersPageProvider(this._auth) {
    _selectedUsers = [];
    _db = GetIt.instance.get<DatabaseService>();
    _navService = GetIt.instance.get<NavigationService>();
    getUsers(userName: selectedUserName);
  }

  void getUsers({String? userName}) async {
    _selectedUsers = [];
    try {
      _db.getUsers(userName).then((_snapShot) {
        users = _snapShot.docs.map((_doc) {
          Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
          _data['uid'] = _doc.id;
          return ChatUser.fromJSON(_data);
        }).toList();
        listOfUsers =
            users?.where((_data) => _auth.chatUser.uid != _data.uid).toList();
        notifyListeners();
      });
    } catch (e) {
      print('DEBUG: Error while getting List of Users: $e');
    }
  }

  void updateSelectdUsers(ChatUser _user) {
    if (_selectedUsers.contains(_user)) {
      _selectedUsers.remove(_user);
    } else {
      _selectedUsers.add(_user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      // Get members Id
      List<String> membersId = selectedUsers.map((_user) => _user.uid).toList();
      membersId.add(_auth.chatUser.uid);
      bool _isGroup = membersId.length > 2;
      // Create Chat with members
      DocumentReference? _docRef = await _db.createChat({
        'is_group': _isGroup,
        'is_activity': false,
        'members': membersId,
      });
      // Get list of chat members object in chat for use of Nav
      List<ChatUser> _chatMembers = [];
      for (var _memId in membersId) {
        DocumentSnapshot _snapshot = await _db.getLoggedInUserData(_memId);
        Map<String, dynamic> _userData =
            _snapshot.data() as Map<String, dynamic>;
        _userData['uid'] = _snapshot.id;
        _chatMembers.add(
          ChatUser.fromJSON(_userData),
        );
      }
      // create Chat page object for Nav
      ChatPage _chatPage = ChatPage(
        chat: Chat(
          uid: _docRef!.id,
          currentUserUid: _auth.chatUser.uid,
          activity: false,
          group: _isGroup,
          members: _chatMembers,
          messages: [],
        ),
      );
      // for Empty trigger for check box of Selected User
      _selectedUsers = [];
      notifyListeners(); // for Empty trigger for check box of Selected User
      // Navigate to chat page.
      _navService.navigateToPage(_chatPage);
      print('DEBUGG: SHA Navigated');
    } catch (e) {
      print('DEBUG: ERROR while Creating Chat from Users Page. $e');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
