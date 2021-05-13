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
      publishedBy: doc['publishedBy'],
      storyType: doc['storyType'],
      storyTitle: doc['storyTitle'],
      storyContent: doc['storyContent'],
      storyImageUrl: doc['storyImageUrl'],
      isApproved: doc['isApproved'],
      storyLikesCount: doc['storyLikesCount'],
      storyCommentsCount: doc['storyCommentsCount'],
      storyViewedCount: doc['storyViewedCount'],
      timestamp: doc['timestamp'],
    );
  }
}
