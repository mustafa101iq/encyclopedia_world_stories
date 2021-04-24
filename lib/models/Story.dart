import 'package:cloud_firestore/cloud_firestore.dart';

class Story{
  final String id,
      publishedBy,
      storyType,
      storyTitle,
      storyContent,
      storyImageUrl;

  final bool isApproved;
  final Timestamp timestamp;

  final int storyLikesCount,
      storyCommentsCount,
      storyViewedCount;

  Story(
      {this.id,
        this.publishedBy,
        this.storyType,
        this.storyTitle,
        this.storyContent,
        this.storyImageUrl,
        this.isApproved,
        this.storyLikesCount,
        this.storyCommentsCount,
        this.storyViewedCount,
        this.timestamp});

  factory Story.fromDocument(DocumentSnapshot doc) {
    return Story(
      id: doc['id'],
      publishedBy: doc.data()['publishedBy'],
      storyType: doc.data()['storyType'],
      storyTitle: doc.data()['storyTitle'],
      storyContent: doc.data()['storyContent'],
      storyImageUrl: doc.data()['storyImageUrl'],
      isApproved: doc.data()['isApproved'],
      storyLikesCount: doc.data()['storyLikesCount'],
      storyCommentsCount: doc.data()['storyCommentsCount'],
      storyViewedCount: doc.data()['storyViewedCount'],
      timestamp: doc.data()['timestamp'],
    );
  }
}
