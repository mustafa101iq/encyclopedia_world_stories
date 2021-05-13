import 'package:cached_network_image/cached_network_image.dart';
import 'package:encyclopedia_world_stories/models/Comment.dart';
import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as timeAgoProvider;

class CommentNode extends StatelessWidget {
  final Comment comment;

  CommentNode(this.comment);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(3), child: commentCard(context, comment));
  }

  commentCard(BuildContext context, Comment comment) {
    // get story Publish Time
    var commentPublishTime =
        timeAgoProvider.format(comment.timestamp.toDate(), locale: 'ar');

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FutureBuilder(
                future: Constants.usersReference.doc(comment.commentBy).get(),
                builder: (context, doc) {
                  if (!doc.hasData) {
                    return circularProgress();
                  } else {
                    return Row(
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: doc.data["photoUrl"],
                            height: 32,
                            width: 32,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          doc.data["displayName"],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  }
                }),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 30, left: 8),
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Color(0xfff9f9f9),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Text(
                      comment.commentContent,
                      style: TextStyle(color: Colors.black, fontSize: 13),
                      textAlign: TextAlign.right,
                    )),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 30, left: 8),
                child: Text(commentPublishTime,
                    style: TextStyle(color: Colors.black54, fontSize: 8),
                    textAlign: TextAlign.right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
