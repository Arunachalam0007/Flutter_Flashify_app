import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { TEXT, IMAGE, UNKNOWN }

class ChatMessage {
  String content;
  String senderId;
  DateTime sentTime;
  MessageType type;

  ChatMessage({
    required this.content,
    required this.senderId,
    required this.sentTime,
    required this.type,
  });

  factory ChatMessage.fromJSON(Map<String, dynamic> _json) {
    MessageType _messageType;
    switch (_json['type']) {
      case 'text':
        _messageType = MessageType.TEXT;
        break;
      case 'image':
        _messageType = MessageType.IMAGE;
        break;
      default:
        _messageType = MessageType.UNKNOWN;
    }
    return ChatMessage(
      content: _json['content'],
      senderId: _json['sender_id'],
      sentTime: _json['sent_time'].toDate(),
      type: _messageType,
    );
  }

  Map<String, dynamic> toJson() {
    String _messageStringType;
    switch (type) {
      case MessageType.TEXT:
        _messageStringType = 'text';
        break;
      case MessageType.IMAGE:
        _messageStringType = 'image';
        break;
      default:
        _messageStringType = '';
    }
    return {
      'content': content,
      'sender_id': senderId,
      'sent_time': Timestamp.fromDate(sentTime),
      'type': _messageStringType,
    };
  }
}
