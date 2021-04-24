import 'package:cached_network_image/cached_network_image.dart';
import 'package:encyclopedia_world_stories/Pages/NotificationDisplayPage.dart';
import 'package:encyclopedia_world_stories/models/Notificatioon.dart';
import 'package:flutter/material.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as timeAgoProvider;

class NotificationNode extends StatelessWidget {
  final Notificatioon notification;

  NotificationNode(this.notification);

  @override
  Widget build(BuildContext context) {
    // get notification Publish Time
    var notificationPublishTime =
        timeAgoProvider.format(notification.timestamp.toDate(), locale: 'ar');

    return Padding(
      padding: EdgeInsets.only(right: 3, left: 3),
      child: Container(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        NotificationDisplayPage(notification)))
              },
              child: Card(
                color: Colors.black38,
                margin: EdgeInsets.all(5),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        notification.imgUrl == ""
                            ? CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(
                                    "assets/images/notification_.png"),
                                backgroundColor: Colors.transparent,
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.black,
                                backgroundImage: CachedNetworkImageProvider(
                                    notification.imgUrl),
                                radius: 30,
                              ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Cairo",
                                    fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                notification.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13, fontFamily: "Cairo"),
                              ),
                              Text(
                                notificationPublishTime,
                                style:
                                    TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
