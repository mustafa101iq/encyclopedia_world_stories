import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id, commentBy, commentContent;

  final Timestamp timestamp;

  Comment({this.id, this.commentBy, this.commentContent, this.timestamp});

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      id: doc['id'],
      commentBy: doc['commentBy'],
      commentContent: doc['commentContent'],
      timestamp: doc['timestamp'],
    );
  }
}
