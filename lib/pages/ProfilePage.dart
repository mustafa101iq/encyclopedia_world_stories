import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:encyclopedia_world_stories/Nodes/StoryPostNode.dart';
import 'package:encyclopedia_world_stories/models/Story.dart';
import 'package:encyclopedia_world_stories/models/Usser.dart';
import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';

List<StoryPostNode> myStoryList = [];
bool isLoading = true;

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage(this.userId);

  @override
  _ProfilePageState createState() => _ProfilePageState(userId);
}

class _ProfilePageState extends State<ProfilePage> {
  final String userId;

  _ProfilePageState(this.userId);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "الملف الشخصي"),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          StreamBuilder(
            stream: Constants.usersReference.doc(userId).snapshots(),
            builder: (context, doc) {
              if (!doc.hasData) {
                return CircularProgressIndicator();
              } else {
                Usser user = Usser.fromDocument(doc.data);
                return Container(
                  height: MediaQuery.of(context).size.height / 3.2,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: CachedNetworkImageProvider(user.photoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                    child: new Container(
                      decoration: new BoxDecoration(
                          color: Colors.white.withOpacity(0.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                  width: 90.0,
                                  height: 90.0,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 2),
                                      shape: BoxShape.circle,),
                              child: ClipOval(
                                    child: CachedNetworkImage(
                                  imageUrl: user.photoUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.fill,
                                )),),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Color(0xfff9f9f9).withOpacity(0.5),
                                      // border: Border.all(
                                      // color: Colors.red[500],),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Text(
                                    user.displayName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        user.interactionsNumber.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                      Text(
                                        "التفاعلات",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        user.storiesNumber.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                      Text(
                                        "القصص",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 13, left: 8, top: 40),
            child: Text(
              "أخر القصص المنشورة",
              style: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:  StreamBuilder(stream: Constants.allStoryReference.orderBy("timestamp",descending: true).where("publishedBy" , isEqualTo: userId).snapshots(),builder: (context,snapshot){
                      if(!snapshot.hasData){
                        return Container(
                            height: MediaQuery.of(context).size.height / 2.3,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("لاتوجد قصص منشورة حاليا",style: TextStyle(color: Colors.white54),),
                            ));
                      }else{
                        myStoryList.clear();
                        snapshot.data.docs.forEach((element) {
                          Story userStory = Story.fromDocument(element);
                          if(userStory.isApproved){
                            StoryPostNode storyPostNode = StoryPostNode(
                              storyPost: userStory,
                              isAdView: false,
                              isProfilePage: true,
                            );
                            myStoryList.add(storyPostNode);
                          }
                        });
                        return Column(children: myStoryList,);
                      }
            })

          )
        ],
      ),
    );
  }

  getUser(String userId) {
    Constants.usersReference.doc(userId).get().then((doc) {
      if (doc.exists) {
        return Usser.fromDocument(doc);
      } else {
        return null;
      }
    });
  }


}
