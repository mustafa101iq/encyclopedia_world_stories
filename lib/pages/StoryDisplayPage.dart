import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:encyclopedia_world_stories/Pages/LoginPage.dart';
import 'package:encyclopedia_world_stories/Pages/SettingsPage.dart';
import 'package:encyclopedia_world_stories/admob/BannerAdWidget.dart';
import 'package:encyclopedia_world_stories/models/Story.dart';
import 'package:encyclopedia_world_stories/providers/SettingsProvider.dart';
import 'package:encyclopedia_world_stories/utils/CommentBottomSheet.dart';
import 'package:encyclopedia_world_stories/utils/LocalData.dart';
import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/CustomAlertDialog.dart';
import 'package:encyclopedia_world_stories/widgets/HeaderWidget.dart';
import 'package:encyclopedia_world_stories/widgets/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

bool isUserLikedStory = false;
bool isUserStory = false;

bool isOfflineStory = false;

class StoryDisplayPage extends StatefulWidget {
  final Story story;
  final String storyPublishTime;

  StoryDisplayPage({this.story, this.storyPublishTime});

  @override
  _StoryDisplayPageState createState() =>
      _StoryDisplayPageState(story: story, storyPublishTime: storyPublishTime);
}

class _StoryDisplayPageState extends State<StoryDisplayPage> {
  final Story story;
  final String storyPublishTime;

  _StoryDisplayPageState({this.story, this.storyPublishTime});

  TextEditingController commentController = TextEditingController();
  bool isBannerAdLoad = true;

  void initState() {
    super.initState();

    isUserStory = story.publishedBy != "" ? true : false;
    isOfflineStory = story.storyImageUrl == "" ? true : false;
    if (!isOfflineStory) {
      increaseStoryView(story);
      getStoryLikeStatus();
    }
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    settingsProvider.loadStoryBGColor();
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: header(context, strTitle: story.storyTitle),
      body: Container(
        color: Color(int.parse(settingsProvider.storyBGColor, radix: 16)),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            isOfflineStory
                ? SizedBox()
                : Stack(
                    overflow: Overflow.visible,
                    children: [
                      Center(
                          child: CachedNetworkImage(
                              imageUrl: story.storyImageUrl,
                              height: MediaQuery.of(context).size.height / 3.2,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill)),
                      Positioned(
                        right: 0,
                        left: 0,
                        bottom: isUserStory ? -57 : -40,
                        child: isUserStory
                            ? Column(
                                children: [
                                  ClipOval(
                                    child: StreamBuilder(
                                      stream: Constants.usersReference
                                          .doc(story.publishedBy)
                                          .snapshots(),
                                      builder: (context, doc) {
                                        if (doc.hasData) {
                                          var photoUrl = doc.data["photoUrl"];
                                          return Container(
                                            width: 40.0,
                                            height: 40.0,
                                            child: ClipOval(
                                                child: CachedNetworkImage(
                                              imageUrl: photoUrl,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.fill,
                                            )),
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      StreamBuilder(
                                        stream: Constants.usersReference
                                            .doc(story.publishedBy)
                                            .snapshots(),
                                        builder: (context, doc) {
                                          if (doc.hasData) {
                                            var displayName =
                                                doc.data["displayName"];
                                            return Column(
                                              children: [
                                                Text(
                                                  displayName,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.yellow,
                                                  ),
                                                ),
                                                Text(
                                                  "( " + story.storyType + " )",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.yellow
                                                        .withAlpha(190),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      StreamBuilder(
                                        stream: Constants.usersReference
                                            .doc(story.publishedBy)
                                            .snapshots(),
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
                                ],
                              )
                            : Column(
                                children: [
                                  Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Theme.of(context).backgroundColor,
                                          width: 1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 25,
                                        child: Image.asset(
                                            getStoryTypeAssetsImagePath(
                                                story.storyType)),
                                      ),
                                    ),
                                  ),
                                  Text(story.storyType,
                                      softWrap: true,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.yellow,
                                      )),
                                ],
                              ),
                      )
                    ],
                  ),
            isOfflineStory
                ? SizedBox()
                : SizedBox(
                    height: 50,
                  ),
            isOfflineStory
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 8, right: 8, left: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          color: Colors.yellow,
                          size: 15,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          story.storyViewedCount.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.yellow,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        FaIcon(
                          FontAwesomeIcons.thumbsUp,
                          color: Colors.yellow,
                          size: 15,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          story.storyLikesCount.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.yellow,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        FaIcon(
                          FontAwesomeIcons.comment,
                          color: Colors.yellow,
                          size: 15,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          story.storyCommentsCount.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.yellow,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        FaIcon(
                          Icons.date_range,
                          color: Colors.yellow,
                          size: 15,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          storyPublishTime,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.yellow,
                          ),
                        ),
                      ],
                    ),
                  ),
            BannerAdWidget(
                AdSize.smartBanner, MediaQuery.of(context).size.width, 80.0),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
              child: Text(story.storyContent,
                  softWrap: true,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: settingsProvider.storyFontSize.toDouble(),
                    color: Color(
                        int.parse(settingsProvider.storyFontColor, radix: 16)),
                  )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isOfflineStory
          ? ConvexAppBar(
              height: 60,
              activeColor: Colors.grey,
              backgroundColor: Theme.of(context).primaryColor,
              // controller: tabController,
              style: TabStyle.fixedCircle,
              items: [
                TabItem(icon: Icons.copy, title: 'نسخ'),
                TabItem(icon: Icons.settings, title: 'الاغدادات'),
                TabItem(icon: Icons.share, title: 'مشاركة'),
              ],
              initialActiveIndex: 2,
              //optional, default as 0
              onTap: (int i) async {
                switch (i) {
                  case 0:
                    String copyText = story.storyTitle +
                        "\n" +
                        story.storyContent +
                        "\n" +
                        "المصدر: تطبيق موسوعة القصص العالمية";
                    FlutterClipboard.copy(copyText).whenComplete(() {
                      showToast("تم نسخ القصة بنجاح");
                    });
                    break;
                  case 1:
                    {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SettingsPage();
                      }));
                    }
                    break;
                  case 2:
                    {
                      String shareText = story.storyTitle +
                          "\n" +
                          story.storyContent +
                          "\n" +
                          "المصدر: تطبيق موسوعة القصص العالمية";
                      await Share.share(shareText, subject: 'مشاركة القصة');
                    }
                }
              },
            )
          : ConvexAppBar(
              height: 70,
              activeColor: Colors.grey,
              backgroundColor: Theme.of(context).primaryColor,
              // controller: tabController,
              style: TabStyle.fixedCircle,
              items: [
                TabItem(icon: Icons.comment, title: 'تعليق'),
                TabItem(
                    icon: isUserLikedStory
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    title: 'اعجاب'),
                TabItem(icon: Icons.settings, title: 'الاغدادات'),
                TabItem(icon: Icons.copy, title: 'نسخ'),
                TabItem(icon: Icons.share, title: 'مشاركة'),
              ],
              initialActiveIndex: 2,
              //optional, default as 0
              onTap: (int i) async {
                switch (i) {
                  case 0:
                    showCommentBottomSheet(context, story.id, story.storyTitle);
                    break;
                  case 1:
                    {
                      if (FirebaseAuth.instance.currentUser != null) {
                        sendLike(story.id);
                        //getStoryLikeStatus();

                      } else {
                        CustomAlertDialog dialog = CustomAlertDialog(
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
                    }
                    break;
                  case 2:
                    {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SettingsPage();
                      }));
                    }
                    break;
                  case 3:
                    {
                      String copyText = story.storyTitle +
                          "\n" +
                          story.storyContent +
                          "\n" +
                          "المصدر: تطبيق موسوعة القصص العالمية";
                      FlutterClipboard.copy(copyText).whenComplete(() {
                        showToast("تم نسخ القصة بنجاح");
                      });
                    }
                    break;
                  case 4:
                    {
                      String shareText = story.storyTitle +
                          "\n" +
                          story.storyContent +
                          "\n" +
                          "المصدر: تطبيق موسوعة القصص العالمية";
                      await Share.share(shareText, subject: 'مشاركة القصة');
                    }
                    break;
                }
              },
            ),
    );
  }

  void increaseStoryView(Story story) {
    Constants.allStoryReference
        .doc(story.id)
        .get()
        .then((DocumentSnapshot document) {
      int storyView = document["storyViewedCount"];
      Constants.allStoryReference
          .doc(story.id)
          .update({"storyViewedCount": ++storyView});
    });
  }

  void sendLike(String storyId) {
    String currentUserId = FirebaseAuth.instance.currentUser.uid;
    Constants.allStoryReference
        .doc(storyId)
        .collection("likes")
        .doc(currentUserId)
        .get()
        .then((DocumentSnapshot doc) async {
      if (doc.exists) {
        Constants.allStoryReference
            .doc(storyId)
            .collection("likes")
            .doc(currentUserId)
            .delete();
        changeStoryLikeCount(storyId, "-");
        changeUserInteractionsNumber(currentUserId, "-");
        setState(() {
          isUserLikedStory = false;
        });
        showToast("تم الغاء الاعجاب بالقصة");
      } else {
        Constants.allStoryReference
            .doc(storyId)
            .collection("likes")
            .doc(currentUserId)
            .set({"likeStory": true});
        changeStoryLikeCount(storyId, "+");
        changeUserInteractionsNumber(currentUserId, "+");
        setState(() {
          isUserLikedStory = true;
        });
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

  void getStoryLikeStatus() {
    if (FirebaseAuth.instance.currentUser != null) {
      Constants.allStoryReference
          .doc(story.id)
          .collection("likes")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          isUserLikedStory = true;
        } else {
          isUserLikedStory = false;
        }
        setState(() {
          isUserLikedStory = isUserLikedStory;
        });
      });
    } else {
      isUserLikedStory = false;
    }
  }

  getStoryTypeAssetsImagePath(storyType) {
    switch (storyType) {
      case horrorStoriesStr:
        return "assets/images/gen.png";
        break;
      case expressiveStoriesStr:
        return "assets/images/expressive.png";
        break;
      case loveStoriesStr:
        return "assets/images/love.png";
        break;
      case warStoriesStr:
        return "assets/images/war.png";
        break;
      case funnyStoriesStr:
        return "assets/images/funny.png";
        break;
      case girlsStoriesStr:
        return "assets/images/girls.png";
        break;
      case sadStoriesStr:
        return "assets/images/sad.png";
        break;
      case realStoriesStr:
        return "assets/images/real.png";
        break;
      case shortStoriesStr:
        return "assets/images/short.png";
        break;
      case juhaStoriesStr:
        return "assets/images/juha.png";
        break;
      case islamicStoriesStr:
        return "assets/images/islamic.png";
        break;
      case internationalStoriesStr:
        return "assets/images/international.png";
        break;
      case childrenStoriesStr:
        return "assets/images/children.png";
        break;
      case historicalStoriesStr:
        return "assets/images/historical.png";
        break;
      case socialStoriesStr:
        return "assets/images/social.png";
        break;
      case successStories:
        return "assets/images/success.png";
        break;
      case moviesStoriesStr:
        return "assets/images/movies.png";
        break;
      case policeStoriesStr:
        return "assets/images/police.png";
        break;
      case mixStoriesStr:
        return "assets/images/mix.png";
        break;
      case amthalStoriesStr:
        return "assets/images/amthal.png";
        break;
    }
  }
}
