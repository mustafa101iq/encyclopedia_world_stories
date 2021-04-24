import 'package:cloud_firestore/cloud_firestore.dart';

class Notificatioon {
  final String id, title, content, linkUrl, imgUrl;

  final Timestamp timestamp;

  Notificatioon(
      {this.id,
      this.title,
      this.content,
      this.linkUrl,
      this.imgUrl,
      this.timestamp,});

  factory Notificatioon.fromDocument(DocumentSnapshot doc) {
    return Notificatioon(
        id: doc.data()['id'],
        title: doc.data()['title'],
        content: doc.data()['content'],
        linkUrl: doc.data()['linkUrl'],
        imgUrl: doc.data()['imgUrl'],
        timestamp: doc.data()['timestamp'],
    );
  }
}
