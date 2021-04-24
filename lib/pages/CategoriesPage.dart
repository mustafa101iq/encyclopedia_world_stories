import 'package:encyclopedia_world_stories/Pages/CategoriesOfflinePage.dart';
import 'package:encyclopedia_world_stories/Pages/StoriesListPage.dart';
import 'package:encyclopedia_world_stories/utils/LocalData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
         physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 10),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8,left: 8),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return CategoriesOfflinePage();
                }));
              },
              child: Card(
                color: Colors.white,
                child: Container(
                  width:MediaQuery.of(context).size.width/1.1 ,
                  height: 170,
                  child: Column(
                    children: [
                      Flexible(flex:1,child: Align(alignment: Alignment.center,child: Image.asset("assets/images/logo.png",height: 70,width: 70,))),
                      Flexible(
                        flex: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text("قصص وحكايات اوف لان",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold

                                )
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              categoryCard(image: "assets/images/islamic.png",title:islamicStoriesStr ),
              categoryCard(image: "assets/images/international.png",title:internationalStoriesStr ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              categoryCard(image: "assets/images/expressive.png",title: expressiveStoriesStr),
              categoryCard(image: "assets/images/funny.png",title: funnyStoriesStr),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              categoryCard(image: "assets/images/girl.png",title: girlsStoriesStr),
              categoryCard(image: "assets/images/real.png",title: realStoriesStr),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              categoryCard(image: "assets/images/short.png",title: shortStoriesStr),
              categoryCard(image: "assets/images/love.png",title: loveStoriesStr),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              categoryCard(image: "assets/images/children.png",title: childrenStoriesStr),
              categoryCard(image: "assets/images/historical.png",title: historicalStoriesStr),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              categoryCard(image: "assets/images/social.png",title: socialStoriesStr),
              categoryCard(image: "assets/images/success.png",title: successStories),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              categoryCard(image: "assets/images/gen.png",title: horrorStoriesStr),
              categoryCard(image: "assets/images/war.png",title: warStoriesStr),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              categoryCard(image: "assets/images/movies.png",title: moviesStoriesStr),
              categoryCard(image: "assets/images/police.png",title: policeStoriesStr),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              categoryCard(image: "assets/images/sad.png",title: sadStoriesStr),
              categoryCard(image: "assets/images/juha.png",title: juhaStoriesStr),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              categoryCard(image: "assets/images/mix.png",title: mixStoriesStr),
              categoryCard(image: "assets/images/amthal.png",title: amthalStoriesStr),
            ],
          ),

        ],
      ),
    );
  }

  categoryCard({image:String,title:String}){
    return  Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return StoriesListPage(category: title,);
          }));
        },
        child: Card(
          color: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width/2.2,
            height: MediaQuery.of(context).size.width/2.3,
            child: Flex(
              direction: Axis.vertical,
              children: [
                Flexible(flex:1,child: Align(alignment: Alignment.center,child: Image.asset(image,height: 60,width: 60,))),
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
                            fontWeight: FontWeight.bold

                          )
                      ),
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
