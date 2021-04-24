import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encyclopedia_world_stories/Pages/LoginPage.dart';
import 'package:encyclopedia_world_stories/Pages/ProfilePage.dart';
import 'package:encyclopedia_world_stories/Pages/StoryDisplayPage.dart';
import 'package:encyclopedia_world_stories/admob/BannerAdWidget.dart';
import 'package:encyclopedia_world_stories/models/Story.dart';
import 'package:encyclopedia_world_stories/utils/CommentBottomSheet.dart';
import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/CustomAlertDialog.dart';
import 'package:encyclopedia_world_stories/widgets/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as timeAgoProvider;

enum viewTypes { post, ad }

class StoryPostNode extends StatelessWidget {
  final Story storyPost;
  final bool isAdView, isProfilePage;

  StoryPostNode({this.storyPost, this.isAdView, this.isProfilePage});

  @override
  Widget build(BuildContext context) {
    return !isAdView
        ? postStoryCard(
            context: context, story: storyPost, isProfilePage: isProfilePage)
        : BannerAdWidget(
            AdSize.smartBanner, MediaQuery.of(context).size.width - 20, 80);
  }

  postStoryCard({BuildContext context, Story story, bool isProfilePage}) {
    // get story Publish Time
    var storyPublishTime =
        timeAgoProvider.format(story.timestamp.toDate(), locale: 'ar');
    // story publisher Reference
    Stream<DocumentSnapshot> storyPublisherStream =
        Constants.usersReference.doc(storyPost.publishedBy).snapshots();

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                if (!isProfilePage) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfilePage(story.publishedBy);
                  }));
                }
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
                    child: ClipOval(
                      child: StreamBuilder(
                        stream: storyPublisherStream,
                        builder: (context, doc) {
                          if (doc.hasData) {
                            var photoUrl = doc.data["photoUrl"];
                            return CachedNetworkImage(
                              imageUrl: photoUrl,
                              height: 40,
                              width: 40,
                              fit: BoxFit.contain,
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          StreamBuilder(
                            stream: storyPublisherStream,
                            builder: (context, doc) {
                              if (doc.hasData) {
                                var displayName = doc.data["displayName"];
                                return Text(
                                  displayName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          StreamBuilder(
                            stream: storyPublisherStream,
                            builder: (context, doc) {
                              if (doc.hasData) {
                                var isUserVerification =
                                    doc.data["isUserVerification"];
                                return isUserVerification
                                    ? Image.asset(
                                        "assets/images/verification.png",
                                        width: 16,
                                      )
                                    : SizedBox();
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                        ],
                      ),
                      Container(
                        child: Text(
                          storyPublishTime,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 15, bottom: 8),
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                    text: story.storyTitle,
                    style: TextStyle(
                        fontSize: 15, color: Colors.black, fontFamily: "Cairo"),
                    children: <TextSpan>[
                      TextSpan(
                        text: "  ( " + story.storyType + " )",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                            fontFamily: "Cairo"
                            // fontWeight: FontWeight.bold
                            ),
                      ),
                    ]),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 15, bottom: 8),
              alignment: Alignment.centerRight,
              child: Text(
                story.storyContent,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xff333333),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            story.storyContent.length > 150
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return StoryDisplayPage(
                            story: storyPost,
                            storyPublishTime: storyPublishTime,
                          );
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 15, bottom: 8),
                        alignment: Alignment.centerRight,
                        child: Text(
                          "قراءة المزيد ...",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return StoryDisplayPage(
                    story: story,
                    storyPublishTime: storyPublishTime,
                  );
                }));
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CachedNetworkImage(
                  imageUrl: story.storyImageUrl,
                  height: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
              child: Row(
                children: [
                  Text("${story.storyViewedCount} مشاهدة.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      )),
                  SizedBox(
                    width: 12,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: Constants.allStoryReference
                        .doc(story.id)
                        .collection("likes")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> doc) {
                      if (doc.hasData) {
                        var commentsCount = doc.data.size;
                        return Text(
                          "$commentsCount اعجاب",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff333333),
                          ),
                        );
                      } else {
                        return Text(
                          "0 اعجاب",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff333333),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: Constants.allStoryReference
                        .doc(story.id)
                        .collection("comments")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> doc) {
                      if (doc.hasData) {
                        var commentsCount = doc.data.size;
                        return Text(
                          "$commentsCount تعليق",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff333333),
                          ),
                        );
                      } else {
                        return Text(
                          "0 تعليق",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff333333),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 2, bottom: 2, right: 5, left: 5),
              child: SizedBox(
                child: Container(
                  color: Color(0xfff9f9f9),
                ),
                height: 2,
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: InkWell(
                      onTap: () {
                        showCommentBottomSheet(
                            context, story.id, story.storyTitle);
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 10, top: 3, bottom: 3),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "تعليق",
                          style: TextStyle(color: Color(0xff9d9d9d)),
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xfff9f9f9),
                          // border: Border.all(
                          //   color: Colors.grey[600],
                          //   width: 1.0 ,
                          // ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        if (FirebaseAuth.instance.currentUser != null) {
                          sendLike(story.id);
                        } else {
                          var dialog = CustomAlertDialog(
                            title: "تنبيه",
                            message: "للاعجاب بالقصة يجب تسجيل الدخول اولا",
                            positiveBtnText: "تسجيل الدخول",
                            negativeBtnText: "الغاء",
                            bgColor: Color(0xff111111),
                            circularBorderRadius: 15,
                            onNegativePressed: () {},
                            onPostivePressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoginPage();
                              }));
                            },
                          );

                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) => dialog);
                        }
                      },
                      icon: FirebaseAuth.instance.currentUser != null
                          ? StreamBuilder(
                              stream: Constants.allStoryReference
                                  .doc(story.id)
                                  .collection("likes")
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> doc) {
                                if (doc.hasData) {
                                  if (doc.data.exists) {
                                    // var commentsCount = doc.data.;
                                    return Icon(
                                      Icons.favorite,
                                      size: 30,
                                    );
                                  } else {
                                    return Icon(
                                      Icons.favorite_border_outlined,
                                      size: 30,
                                    );
                                  }
                                } else {
                                  return Icon(
                                    Icons.favorite_border_outlined,
                                    size: 30,
                                  );
                                }
                              },
                            )
                          : Icon(
                              Icons.favorite_border_outlined,
                              size: 30,
                            ),
                      color: Colors.amber,
                    ),
                  ),
                  flex: 0,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void sendLike(String storyId) {
    String currentUserId = FirebaseAuth.instance.currentUser.uid;
    Constants.allStoryReference
        .doc(storyId)
        .collection("likes")
        .doc(currentUserId)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        Constants.allStoryReference
            .doc(storyId)
            .collection("likes")
            .doc(currentUserId)
            .delete();
        changeStoryLikeCount(storyId, "-");
        changeUserInteractionsNumber(currentUserId, "-");
        showToast("تم الغاء الاعجاب بالقصة");
      } else {
        Constants.allStoryReference
            .doc(storyId)
            .collection("likes")
            .doc(currentUserId)
            .set({"likeStory": true});
        changeStoryLikeCount(storyId, "+");
        changeUserInteractionsNumber(currentUserId, "+");
        showToast("تم تسجيل الاعجاب بالقصة");
      }
    });
  }

  void changeStoryLikeCount(String storyId, String sign) {
    Constants.allStoryReference
        .doc(storyId)
        .get()
        .then((DocumentSnapshot document) {
      int storyLikes = document["storyLikesCount"];
      Constants.allStoryReference.doc(storyId).update(
          {"storyLikesCount": sign == "+" ? ++storyLikes : --storyLikes});
    });
  }

  void changeUserInteractionsNumber(String userId, String sign) {
    Constants.usersReference
        .doc(userId)
        .get()
        .then((DocumentSnapshot document) {
      int userInteractionsNumber = document["interactionsNumber"];
      Constants.usersReference.doc(userId).update({
        "interactionsNumber":
            sign == "+" ? ++userInteractionsNumber : --userInteractionsNumber
      });
    });
  }
}
