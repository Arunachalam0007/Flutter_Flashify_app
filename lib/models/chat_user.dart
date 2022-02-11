// Packages
import 'package:timeago/timeago.dart' as timeago;


class ChatUser {
  final String uid;
  final String email;
  final String name;
  final String imageURL;
  final DateTime lastActive;

  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageURL,
    required this.lastActive,
  });

  factory ChatUser.fromJSON(Map<String, dynamic> _json) {
    return ChatUser(
      uid: _json['uid'],
      name: _json['name'],
      email: _json['email'],
      imageURL: _json['image'],
      lastActive: _json['last_active'].toDate(),
    );
  }

  Map<String, dynamic> getUserData() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image': imageURL,
      'last_active': lastActive.toUtc(),
    };
  }

  String lastDayActive() {
    return '${timeago.format(lastActive)}';
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inHours < 2;
  }
  
}
