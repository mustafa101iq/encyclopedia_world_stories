import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encyclopedia_world_stories/Nodes/NotificationNode.dart';
import 'package:encyclopedia_world_stories/models/Notificatioon.dart';
import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/HeaderWidget.dart';
import 'package:encyclopedia_world_stories/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';

class NotificationsListPage extends StatefulWidget {
  @override
  _NotificationsListPageState createState() => _NotificationsListPageState();
}

class _NotificationsListPageState extends State<NotificationsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "التنبيهات"),
      body: Container(
        child: StreamBuilder(
          stream: Constants.notificationReference
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> dataSnapshot) {
            if (!dataSnapshot.hasData) {
              return circularProgress();
            } else {
              List<NotificationNode> notificationNodeList = [];
              dataSnapshot.data.docs.forEach((document) {
                Notificatioon notification =
                    Notificatioon.fromDocument(document);

                NotificationNode notificationNode =
                    NotificationNode(notification);

                notificationNodeList.add(notificationNode);
              });

              return ListView(
                  physics: BouncingScrollPhysics(),
                  children: notificationNodeList);
            }
          },
        ),
      ),
    );
  }
}
