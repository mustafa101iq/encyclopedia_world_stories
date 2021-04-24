import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encyclopedia_world_stories/Nodes/StoryListNode.dart';
import 'package:encyclopedia_world_stories/admob/BannerAdWidget.dart';
import 'package:encyclopedia_world_stories/models/Story.dart';
import 'package:encyclopedia_world_stories/utils/LocalData.dart';
import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/HeaderWidget.dart';
import 'package:encyclopedia_world_stories/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Stream<QuerySnapshot> storiesQuery;

class StoriesListPage extends StatefulWidget {
  final String category;

  StoriesListPage({this.category});

  @override
  _StoriesListPageState createState() =>
      _StoriesListPageState(category: category);
}

class _StoriesListPageState extends State<StoriesListPage> {
  final String category;

  _StoriesListPageState({this.category});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //get last story documents
    getStoriesQuery(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: category),
      body: StreamBuilder(
        stream: storiesQuery,
        builder: (context, dataSnapshot) {
          if (!dataSnapshot.hasData) {
            return circularProgress();
          } else {
            List<StoryListNode> storyList = [];
            dataSnapshot.data.docs.forEach((document) {
              Story story = Story.fromDocument(document);

              if (story.isApproved) {
                StoryListNode storyNode = StoryListNode(story);
                storyList.add(storyNode);
              }
            });

            if (storyList.isEmpty) {
              return Center(
                child: Text(
                  "لم يتم نشر اي قصة في هذا القسم بعد",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Cairo",
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              );
            } else {
              return Column(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                      child: ListView(
                        children: storyList,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                      ),
                    ),
                  ),
                  BannerAdWidget(AdSize.smartBanner,
                      MediaQuery.of(context).size.width, 80.0)
                ],
              );
            }
          }
        },
      ),
    );
  }
}

void getStoriesQuery(String category) {
  switch (category) {
    case lastStoriesStr:
      storiesQuery = Constants.allStoryReference
          .orderBy('timestamp', descending: true)
          .snapshots();
      break;
    case mostLikedStoriesStr:
      storiesQuery = Constants.allStoryReference
          .orderBy('storyLikesCount', descending: true)
          .snapshots();
      break;
    case mostViewedStoriesStr:
      storiesQuery = Constants.allStoryReference
          .orderBy('storyViewedCount', descending: true)
          .snapshots();
      break;
    default:
      storiesQuery = Constants.allStoryReference
          .orderBy('timestamp', descending: true)
          .where("storyType", isEqualTo: category)
          .snapshots();
      break;
  }
}
