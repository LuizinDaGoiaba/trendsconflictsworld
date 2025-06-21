import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String text;
  final DateTime timestamp;

  Comment({required this.text, required this.timestamp});

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'timestamp': timestamp,
    };
  }
}