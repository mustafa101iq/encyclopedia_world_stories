import 'package:encyclopedia_world_stories/Pages/StoryDisplayPage.dart';
import 'package:encyclopedia_world_stories/admob/BannerAdWidget.dart';
import 'package:encyclopedia_world_stories/models/OfflineStory.dart';
import 'package:encyclopedia_world_stories/models/Story.dart';
import 'package:encyclopedia_world_stories/utils/LocalData.dart';
import 'package:encyclopedia_world_stories/utils/SQLiteDBHelper.dart';
import 'package:encyclopedia_world_stories/utils/SharedPreferencesManager.dart';
import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/HeaderWidget.dart';
import 'package:encyclopedia_world_stories/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class StoriesOfflineListPage extends StatefulWidget {
  final String category, imagePath;

  StoriesOfflineListPage(this.category, this.imagePath);

  @override
  _StoriesOfflineListPageState createState() =>
      _StoriesOfflineListPageState(category, imagePath);
}

class _StoriesOfflineListPageState extends State<StoriesOfflineListPage> {
  final String category, imagePath;

  _StoriesOfflineListPageState(this.category, this.imagePath);

  List<OfflineStory> storyList;
  InterstitialAd _interstitialAd;
  bool _interstitialReady = false;

  // AdListener interstitialAdListener =
  int itemClickCountOffline = 0;
  Story story;

  @override
  void initState() {
    super.initState();

    MobileAds.instance
        .updateRequestConfiguration(RequestConfiguration(
            tagForChildDirectedTreatment:
                TagForChildDirectedTreatment.unspecified))
        .then((value) {
      createInterstitialAd(isInit: true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: category),
      body: Column(
        children: [
          Flexible(
            child: FutureBuilder(
              future: SQLiteDBHelper().getAllStory(tableName: getTableName()),
              builder: (context, data) {
                if (!data.hasData) {
                  return circularProgress();
                } else {
                  storyList = data.data;
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, i) {
                      return storyCard(context, storyList[i], (++i).toString());
                    },
                    itemCount: storyList.length,
                  );
                }
              },
            ),
          ),
          BannerAdWidget(
              AdSize.smartBanner, MediaQuery.of(context).size.width, 80.0)
        ],
      ),
    );
  }

  storyCard(
      BuildContext context, OfflineStory storyOffline, String storyNumber) {
    return InkWell(
      onTap: () async {
        itemClickCountOffline = await SharedPreferencesManager.instance
            .getIntValue("itemClickCountOffline", 1);

        story = Story(
          storyType: category,
          storyTitle: storyOffline.title,
          storyContent: storyOffline.story,
          publishedBy: "",
          storyLikesCount: 0,
          storyCommentsCount: 0,
          storyImageUrl: "",
        );

        if (_interstitialReady && itemClickCountOffline % 3 == 0) {
          itemClickCountOffline = await SharedPreferencesManager.instance
              .setIntValue("itemClickCountOffline", 1);
          _interstitialAd.show();
          _interstitialReady = false;
          _interstitialAd = null;
        } else {
          goToStoryDisplayPage();
        }
        itemClickCountOffline = await SharedPreferencesManager.instance
            .setIntValue("itemClickCountOffline", ++itemClickCountOffline);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4, right: 8, left: 8),
        child: Card(
          color: Colors.white,
          child: Row(
            children: [
              Container(
                  height: 80,
                  color: Colors.blueGrey[800],
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Text(
                      storyNumber,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ))),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  flex: 0,
                  child: Image.asset(
                    imagePath,
                    height: 50,
                    width: 50,
                    fit: BoxFit.fill,
                  )),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                                Text(storyOffline.title,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text(category,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getTableName() {
    String tableName = "";

    switch (category) {
      case islamicStoriesStr:
        tableName = "stores_islamia";
        break;
      case internationalStoriesStr:
        tableName = "stores_almia";
        break;
      case childrenStoriesStr:
        tableName = "stores_atfal";
        break;
      case historicalStoriesStr:
        tableName = "stores_tarik";
        break;
      case socialStoriesStr:
        tableName = "stores_ajtmaia";
        break;
      case successStories:
        tableName = "stores_njah";
        break;
      case moviesStoriesStr:
        tableName = "stores_aflam";
        break;
      case policeStoriesStr:
        tableName = "stores_bulisia";
        break;
      case mixStoriesStr:
        tableName = "stores_mnouaa";
        break;
      case amthalStoriesStr:
        tableName = "stores_amthal";
        break;
      case horrorStoriesStr:
        tableName = "stores_raeb";
        break;
      case warStoriesStr:
        tableName = "stores_hroub";
        break;
    }
    return tableName;
  }

  void createInterstitialAd({bool isInit, bool isFromFailedToLoad}) {
    _interstitialAd ??= InterstitialAd(
      adUnitId: Constants.interstitialId,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('${ad.runtimeType} loaded.');
          _interstitialReady = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('${ad.runtimeType} failed to load: $error.');
          if (!isInit) {
            goToStoryDisplayPage();
          }
        },
        onAdOpened: (Ad ad) => print('${ad.runtimeType} onAdOpened.'),
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed.');
          ad.dispose();
          createInterstitialAd(isInit: false);
          if (!isInit) {
            goToStoryDisplayPage();
          }
        },
        onApplicationExit: (Ad ad) =>
            print('${ad.runtimeType} onApplicationExit.'),
      ),
    )..load();
  }

  void goToStoryDisplayPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return StoryDisplayPage(
        story: story,
        storyPublishTime: "",
      );
    }));
  }
}
