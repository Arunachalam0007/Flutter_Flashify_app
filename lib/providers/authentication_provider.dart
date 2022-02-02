import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

// Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

// Models
import '../models/chat_user.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;
  late ChatUser chatUser;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();

    _auth.signOut();
    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        print('User got Logged IN');
        _databaseService.updateLoggedInUserData(_user.uid);
        _databaseService.getLoggedInUserData(_user.uid).then((_snapShot) {
          Map<String, dynamic> _userData =
              _snapShot.data() as Map<String, dynamic>;
          chatUser = ChatUser.fromJSON({
            'uid': _user.uid,
            'email': _userData['email'],
            'name': _userData['name'],
            'image': _userData['image'],
            'last_active': _userData['last_active'],
          });
          print('chatUser Data: ${chatUser.getUserData()}');
          _navigationService.popAndNavigateToRoute('/home');
        });
      } else {
        print('Not Authenticated');
        _navigationService.popAndNavigateToRoute('/login');

      }
    });
  }

  Future<void> loginUsingEmailAndPassword(
    String _email,
    String _password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      print(_auth.currentUser);
    } on FirebaseAuthException {
      print('Error Logging User into Firebase');
    } catch (e) {
      print(e);
    }
  }
}
