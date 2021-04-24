import 'package:cached_network_image/cached_network_image.dart';
import 'package:encyclopedia_world_stories/Pages/StoryDisplayPage.dart';
import 'package:encyclopedia_world_stories/models/Story.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as timeAgoProvider;

class StoryListNode extends StatelessWidget {
  final Story story;

  StoryListNode(this.story);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(3), child: storyCard(context, story));
  }

  storyCard(BuildContext context, Story story) {
    // get job Publish Time
    var storyPublishTime =
        timeAgoProvider.format(story.timestamp.toDate(), locale: 'ar');
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return StoryDisplayPage(
            story: story,
            storyPublishTime: storyPublishTime,
          );
        }));
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: [
              Expanded(
                  flex: 0,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      height: 60,
                      width: 60,
                      imageUrl: story.storyImageUrl,
                      fit: BoxFit.fill,
                    ),
                  )),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(story.storyTitle,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Text(story.storyType,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black45,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  Text(story.storyViewedCount.toString(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                      )),
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.comment,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  Text(story.storyCommentsCount.toString(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ))
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.thumbsUp,
                                    color: Theme.of(context).accentColor,
                                    size: 23,
                                  ),
                                  Text(story.storyLikesCount.toString(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ))
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    color: Theme.of(context).accentColor,
                                    size: 25,
                                  ),
                                  Text(storyPublishTime,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                      )),
                                ],
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
