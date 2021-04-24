import 'package:cached_network_image/cached_network_image.dart';
import 'package:encyclopedia_world_stories/Pages/StoryDisplayPage.dart';
import 'package:encyclopedia_world_stories/models/Story.dart';
import 'package:flutter/material.dart';

import 'package:time_ago_provider/time_ago_provider.dart' as timeAgoProvider;


class StoryNode extends StatelessWidget {
  final Story story;
  StoryNode(this.story);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(3),
        child: storyCard(context,story)
    );
  }

  storyCard(BuildContext context, Story story) {
    // get story Publish Time
    var storyPublishTime = timeAgoProvider.format(story.timestamp.toDate(), locale: 'ar');

    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return StoryDisplayPage(story: story,storyPublishTime: storyPublishTime,);
        }));
      },
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8,bottom: 4,left: 8,right: 8),
              child: Container(
                alignment: Alignment.center,
                width: 200.0,
                child: Text(story.storyTitle,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CachedNetworkImage(
                imageUrl: story.storyImageUrl,
                width: 200,
                height: 140,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 200.0,
              child: Text(story.storyType,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                  )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("${story.storyViewedCount} مشاهدة.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          )),
                      SizedBox(
                        width: 12,
                      ),
                      Text("${story.storyLikesCount} اعجاب.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          )),
                      SizedBox(
                        width: 12,
                      ),
                      Text(storyPublishTime,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}