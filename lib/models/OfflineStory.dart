import 'package:cloud_firestore/cloud_firestore.dart';

class OfflineStory{

  final int id;
  final String title, story;


  OfflineStory(
      {this.id,
        this.title,
        this.story,});

  factory OfflineStory.fromJson(Map<dynamic,dynamic> doc) {
    return OfflineStory(
      id: doc['id'],
      title: doc['title'],
      story: doc['story'],
    );
  }
}
