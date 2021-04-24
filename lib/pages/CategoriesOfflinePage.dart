import 'package:encyclopedia_world_stories/Pages/StoriesOfflineListPage.dart';
import 'package:encyclopedia_world_stories/admob/BannerAdWidget.dart';
import 'package:encyclopedia_world_stories/models/OfflineStory.dart';
import 'package:encyclopedia_world_stories/utils/LocalData.dart';
import 'package:encyclopedia_world_stories/utils/SQLiteDBHelper.dart';
import 'package:encyclopedia_world_stories/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CategoriesOfflinePage extends StatefulWidget {
  @override
  _CategoriesOfflinePageState createState() => _CategoriesOfflinePageState();
}

class _CategoriesOfflinePageState extends State<CategoriesOfflinePage> {
  List<OfflineStory> storyList;

  @override
  void initState() {
    super.initState();
    SQLiteDBHelper().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, strTitle: "قصص وحكايات اوف لاين"),
        body: Column(
          children: [
            Flexible(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      categoryCard(
                          image: "assets/images/islamic.png",
                          title: islamicStoriesStr),
                      categoryCard(
                          image: "assets/images/international.png",
                          title: internationalStoriesStr),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      categoryCard(
                          image: "assets/images/children.png",
                          title: childrenStoriesStr),
                      categoryCard(
                          image: "assets/images/historical.png",
                          title: historicalStoriesStr),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      categoryCard(
                          image: "assets/images/social.png", title: socialStoriesStr),
                      categoryCard(
                          image: "assets/images/success.png", title: successStories),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      categoryCard(
                          image: "assets/images/movies.png", title: moviesStoriesStr),
                      categoryCard(
                          image: "assets/images/police.png", title: policeStoriesStr),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      categoryCard(
                          image: "assets/images/mix.png", title: mixStoriesStr),
                      categoryCard(
                          image: "assets/images/amthal.png", title: amthalStoriesStr),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      categoryCard(
                          image: "assets/images/gen.png", title: horrorStoriesStr),
                      categoryCard(
                          image: "assets/images/war.png", title: warStoriesStr),
                    ],
                  ),
                  //NativeAdWidget()
                ],
              ),
            ),
            BannerAdWidget(AdSize.smartBanner, MediaQuery.of(context).size.width, 80)
          ],
        ));
  }

  categoryCard({image: String, title: String, page}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return StoriesOfflineListPage(title, image);
          }));
        },
        child: Card(
          color: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width / 2.2,
            height: MediaQuery.of(context).size.width / 2.3,
            child: Flex(
              direction: Axis.vertical,
              children: [
                Flexible(
                    flex: 1,
                    child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          image,
                          height: 60,
                          width: 60,
                        ))),
                Flexible(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(title,
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
