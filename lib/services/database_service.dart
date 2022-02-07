// Packages
import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = 'Users';
const String CHAT_COLLECTION = 'Chats';
const String MESSAGES_COLLECTION = 'Messages';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  // Create UserData in Firestore

  Future<void> createUserData(
      String _uid, String _email, String _name, String _imageURL) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).set({
        'email': _email,
        'name': _name,
        'image': _imageURL,
        'last_active': DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  // Get UserData in Firestore
  Future<DocumentSnapshot> getLoggedInUserData(String _uid) {
    return _db.collection(USER_COLLECTION).doc(_uid).get();
  }

  // Update user Data in Firestore
  Future<void> updateLoggedInUserData(String _uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).update({
        'last_active': DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  // Get Chats based on User Id

  Stream<QuerySnapshot> getChatsBasedOnUserId(String _uid) {
    return _db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: _uid)
        .snapshots();
  }

  // Get Last Chat message for the user chat
  Future<QuerySnapshot> getLastChatMessage(String _chatId) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatId)
        .collection(MESSAGES_COLLECTION)
        .orderBy('sent_time', descending: true)
        .limit(1)
        .get();
  }
}
