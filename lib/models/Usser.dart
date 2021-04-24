import 'package:cloud_firestore/cloud_firestore.dart';

class Usser{
  final String id,
      displayName,
      email,
      photoUrl;

  final bool isUserVerification;
  final Timestamp timestamp;
  final int interactionsNumber,storiesNumber;

  Usser(
      {this.id,
        this.displayName,
        this.email,
        this.photoUrl,
        this.isUserVerification,
        this.interactionsNumber,
        this.storiesNumber,
        this.timestamp});

  factory Usser.fromDocument(DocumentSnapshot doc) {
    return Usser(
      id: doc.data()['id'],
      displayName: doc.data()['displayName'],
      email: doc.data()['email'],
      photoUrl: doc.data()['photoUrl'],
      isUserVerification: doc.data()['isUserVerification'],
      interactionsNumber: doc.data()['interactionsNumber'],
      storiesNumber: doc.data()['storiesNumber'],
      timestamp: doc.data()['timestamp'],
    );
  }
}
