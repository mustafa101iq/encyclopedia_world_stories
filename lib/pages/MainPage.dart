import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encyclopedia_world_stories/Nodes/StoryNode.dart';
import 'package:encyclopedia_world_stories/Nodes/StoryPostNode.dart';
import 'package:encyclopedia_world_stories/Pages/StoriesListPage.dart';
import 'package:encyclopedia_world_stories/models/Story.dart';
import 'package:encyclopedia_world_stories/utils/LocalData.dart';
import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

bool isLikeStory = false;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Stream<QuerySnapshot> lastStoriesQuery,
      mostLikedStoriesQuery,
      mostViewedStoriesQuery,
      storiesPostsQuery;

  @override
  void initState() {
    super.initState();
    //get last story documents
    lastStoriesQuery = Constants.allStoryReference
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
    //get most Liked Stories documents
    mostLikedStoriesQuery = Constants.allStoryReference
        .orderBy('storyLikesCount', descending: true)
        .limit(10)
        .snapshots();
    //get most Viewed Stories documents
    mostViewedStoriesQuery = Constants.allStoryReference
        .orderBy('storyViewedCount', descending: true)
        .limit(10)
        .snapshots();
    //get most Viewed Stories documents
    storiesPostsQuery = Constants.allStoryReference
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          lastStories(),
          mostViewedStories(),
          mostLikedStories(),
          userStories(),
        ],
      ),
    ));
  }

  lastStories() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lastStoriesStr,
                style: TextStyle(fontSize: 15),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return StoriesListPage(category: "اخر القصص");
                  }));
                },
                child: Text("عرض المزيد",
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).accentColor)),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          height: 270.0,
          child: StreamBuilder(
            stream: lastStoriesQuery,
            builder: (context, dataSnapshot) {
              if (!dataSnapshot.hasData) {
                return circularProgress();
              } else {
                List<StoryNode> storyList = [];
                dataSnapshot.data.docs.forEach((document) {
                  Story story = Story.fromDocument(document);

                  if (story.isApproved) {
                    StoryNode storyNode = StoryNode(story);
                    storyList.add(storyNode);
                  }
                });

                return ListView(
                  children: storyList,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  mostViewedStories() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mostViewedStoriesStr,
                style: TextStyle(fontSize: 15),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return StoriesListPage(
                      category: mostViewedStoriesStr,
                    );
                  }));
                },
                child: Text("عرض المزيد",
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).accentColor)),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          height: 270.0,
          child: StreamBuilder(
            stream: mostViewedStoriesQuery,
            builder: (context, dataSnapshot) {
              if (!dataSnapshot.hasData) {
                return circularProgress();
              } else {
                List<StoryNode> storyList = [];
                dataSnapshot.data.docs.forEach((document) {
                  Story story = Story.fromDocument(document);

                  if (story.isApproved) {
                    StoryNode storyNode = StoryNode(story);
                    storyList.add(storyNode);
                  }
                });

                return ListView(
                  children: storyList,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  mostLikedStories() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mostLikedStoriesStr,
                style: TextStyle(fontSize: 15),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return StoriesListPage(
                      category: mostLikedStoriesStr,
                    );
                  }));
                },
                child: Text("عرض المزيد",
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).accentColor)),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          height: 270.0,
          child: StreamBuilder(
            stream: mostLikedStoriesQuery,
            builder: (context, dataSnapshot) {
              if (!dataSnapshot.hasData) {
                return circularProgress();
              } else {
                List<StoryNode> storyList = [];
                dataSnapshot.data.docs.forEach((document) {
                  Story story = Story.fromDocument(document);

                  if (story.isApproved) {
                    StoryNode storyNode = StoryNode(story);
                    storyList.add(storyNode);
                  }
                });

                return ListView(
                  children: storyList,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  userStories() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          child: StreamBuilder(
            stream: storiesPostsQuery,
            builder: (context, dataSnapshot) {
              if (!dataSnapshot.hasData) {
                return circularProgress();
              } else {
                int i = 0;
                List<StoryPostNode> storyList = [];
                dataSnapshot.data.docs.forEach((document) {
                  Story userStory = Story.fromDocument(document);
                  if (userStory.publishedBy != "" && userStory.isApproved) {
                    i++;
                    if (i % 8 == 0) {
                      StoryPostNode storyPostNode = StoryPostNode(
                        storyPost: userStory,
                        isAdView: false,
                        isProfilePage: false,
                      );
                      storyList.add(storyPostNode);
                      storyPostNode = StoryPostNode(
                        storyPost: userStory,
                        isAdView: true,
                        isProfilePage: false,
                      );
                      storyList.add(storyPostNode);
                    } else {
                      StoryPostNode storyPostNode = StoryPostNode(
                        storyPost: userStory,
                        isAdView: false,
                        isProfilePage: false,
                      );
                      storyList.add(storyPostNode);
                    }
                  }
                });

                return Column(
                  children: storyList,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
