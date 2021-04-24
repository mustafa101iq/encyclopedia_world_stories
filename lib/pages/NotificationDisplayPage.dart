import 'package:encyclopedia_world_stories/models/Notificatioon.dart';
import 'package:encyclopedia_world_stories/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as timeAgoProvider;
import 'package:url_launcher/url_launcher.dart';

class NotificationDisplayPage extends StatefulWidget {
  final Notificatioon notification;

  NotificationDisplayPage(this.notification);

  @override
  _NotificationDisplayPageState createState() =>
      _NotificationDisplayPageState(notification);
}

class _NotificationDisplayPageState extends State<NotificationDisplayPage> {
  final Notificatioon notification;

  _NotificationDisplayPageState(this.notification);

  @override
  Widget build(BuildContext context) {
    // get notification Publish Time
    String notificationPublishTime =
        timeAgoProvider.format(notification.timestamp.toDate(), locale: 'ar');

    return Scaffold(
      appBar: header(
        context,
        strTitle: "تنبيه",
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Card(
                margin: EdgeInsets.all(5),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              notification.imgUrl != ""
                                  ? Center(
                                      child: Image.network(
                                      notification.imgUrl,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          height: 350,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                    ))
                                  : SizedBox(),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                notification.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Cairo"),
                              ),
                              Divider(),
                              Text(
                                notification.content,
                                style: TextStyle(
                                    fontFamily: "Cairo", fontSize: 14),
                              ),
                              notification.linkUrl != ""
                                  ? SizedBox(height: 8)
                                  : SizedBox(),
                              Linkify(
                                onOpen: (link) async {
                                  if (await canLaunch(link.url)) {
                                    await launch(link.url);
                                  } else {
                                    throw 'Could not launch $link';
                                  }
                                },
                                text: notification.linkUrl,
                                style: TextStyle(color: Colors.yellow),
                                linkStyle: TextStyle(color: Colors.red),
                              ),
                              notification.linkUrl != ""
                                  ? SizedBox(height: 8)
                                  : SizedBox(),
                              Text(
                                notificationPublishTime,
                                style: TextStyle(fontSize: 11),
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

  Future<void> openUrl(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}
