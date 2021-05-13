

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Constants {
  static String appName = "Foody Bite";
  static String packageName = "com.alhamdany.mustafa.encyclopedia_world_stories" ;
  static String admobAppId="ca-app-pub-1023549411111030~9458702754";
  static String bannerId = "ca-app-pub-1023549411111030/1566117909";
  //  static String bannerId = BannerAd.testAdUnitId;
  static String interstitialId = "ca-app-pub-1023549411111030/7556811182";
  //  static String interstitialId = InterstitialAd.testAdUnitId;


  //font size in px
  static double h1 = 32;
  static double h2 = 24;
  static double h3 = 18;
  static double h4 = 16;
  static double h5 = 14;
  static double h6 = 12;

  //Colors for theme
  static Color lightPrimary = Colors.blue;
  static Color darkPrimary = Colors.black45 ;
  static Color lightAccent = Color(0xff5563ff);
  static Color darkAccent = Colors.yellow[700];
  static Color lightBG = Colors.white;
  static Color darkBG = Color(0xff222831);
  static Color ratingBG = Colors.yellow[600];
  static Color lightCard = Colors.brown;
  static Color darkCard = Colors.black54;
  static Color fieldColor =Color(0xfff5fffe);
  static Color fieldTextColor = Color(0xff81828c);


  //default value
  static Color defaultStoryBgColor = darkBG;
  static Color defaultStoryFontColor = Colors.white;
  static double defaultStoryFontSize = 16;

  //firebase path
  static final allStoryReference = FirebaseFirestore.instance.collection("allStory");
  static final usersReference = FirebaseFirestore.instance.collection("users");
  static final notificationReference = FirebaseFirestore.instance.collection("notifications");
  static final notesReference = FirebaseFirestore.instance.collection("notes");

  static Reference allStoryImagesReference = FirebaseStorage.instance.ref().child("Images").child("allStoryImages");
  static Reference userProfileImageReference = FirebaseStorage.instance.ref().child("Images").child("userProfileImage");


  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    cardColor: lightCard,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        headline6: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    cardColor: darkCard,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        headline6: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    fontFamily: "Cairo"
  );
}
