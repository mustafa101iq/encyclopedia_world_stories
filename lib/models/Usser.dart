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
      id: doc['id'],
      displayName: doc['displayName'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
      isUserVerification: doc['isUserVerification'],
      interactionsNumber: doc['interactionsNumber'],
      storiesNumber: doc['storiesNumber'],
      timestamp: doc['timestamp'],
    );
  }
}
