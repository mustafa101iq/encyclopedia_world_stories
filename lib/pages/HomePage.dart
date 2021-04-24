import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:encyclopedia_world_stories/Pages/AboutPage.dart';
import 'package:encyclopedia_world_stories/Pages/CategoriesPage.dart';
import 'package:encyclopedia_world_stories/Pages/LoginPage.dart';
import 'package:encyclopedia_world_stories/Pages/MainPage.dart';
import 'package:encyclopedia_world_stories/Pages/NotificationsListPage.dart';
import 'package:encyclopedia_world_stories/Pages/ProfilePage.dart';
import 'package:encyclopedia_world_stories/Pages/PublishStoryPage.dart';
import 'package:encyclopedia_world_stories/Pages/SendNotePage.dart';
import 'package:encyclopedia_world_stories/Pages/SettingsPage.dart';
import 'package:encyclopedia_world_stories/models/Message.dart';
import 'package:encyclopedia_world_stories/models/Usser.dart';
import 'package:encyclopedia_world_stories/providers/AuthenticationsProvider.dart';
import 'package:encyclopedia_world_stories/utils/SharedPreferencesManager.dart';
import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/CustomAlertDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

enum pages { mainPage, categoriesPage, sendNotePage, aboutPage }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPage = 0, unReadNotificationCount = 0;
  bool isMainPage = true;

  String pageTitle = "الصفحة الرئيسية";
  TabController tabController;
  Usser currentUser;
  final pageOptions = [
    MainPage(),
    CategoriesPage(),
    SendNotePage(),
    AboutPage(),
  ];

  //declare push notification variable
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _firebaseMessaging.subscribeToTopic('notification');
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        setNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        setNotification(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    getUnReadNotificationCount();
  }

  @override
  Widget build(BuildContext context) {
    var authenticationsProvider = Provider.of<AuthenticationsProvider>(context);
    getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        actions: [
          isMainPage
              ? IconButton(
                  icon: unReadNotificationCount == 0
                      ? Icon(Icons.notifications_active)
                      : Badge(
                          position: BadgePosition.bottomEnd(bottom: 0, end: 14),
                          badgeContent:
                              Text(unReadNotificationCount.toString()),
                          child: Icon(Icons.notifications_active),
                        ),
                  onPressed: () async {
                    int newNotificationCount = await SharedPreferencesManager
                        .instance
                        .getIntValue("newNotificationCount", 0);
                    SharedPreferencesManager.instance.setIntValue(
                        "oldNotificationCount", newNotificationCount);
                    getUnReadNotificationCount();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return NotificationsListPage();
                    }));
                  })
              : Container()
        ],
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: Text(
          pageTitle,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 18,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      body: pageOptions[selectedPage],
      drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: Container(
        color: Theme.of(context).backgroundColor,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: [
                  //if user sign in
                  if (currentUser != null)
                    Column(
                      children: [
                        ClipOval(
                            child: CachedNetworkImage(
                          imageUrl: currentUser.photoUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.fill,
                        )),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(currentUser.displayName),
                            //get user verification status
                            StreamBuilder(
                              stream: Constants.usersReference
                                  .doc(currentUser.id)
                                  .snapshots(),
                              builder: (context, document) {
                                if (document.hasData) {
                                  bool isUserVerification =
                                      document.data["isUserVerification"];
                                  return !isUserVerification
                                      ? SizedBox()
                                      : Row(
                                          children: [
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Image.asset(
                                              "assets/images/verification.png",
                                              height: 18,
                                              width: 18,
                                            )
                                          ],
                                        );
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
                          ],
                        ),
                        Text(currentUser.email),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Text('موسوعة القصص العالمية'),
                        Image.asset(
                          "assets/images/logo.png",
                          width: 100,
                          height: 100,
                        )
                      ],
                    ),
                ],
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            FirebaseAuth.instance.currentUser == null
                ? ListTile(
                    leading: Icon(Icons.login),
                    title: Text('تسجيل الدخول'),
                    onTap: () {
                      //close the drawer
                      Navigator.pop(context);
                      // Update the state of the app
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      })).whenComplete(() {
                        setState(() {});
                      });
                    },
                  )
                : ListTile(
                    leading: Icon(Icons.person),
                    title: Text('الملف الشخصي'),
                    onTap: () {
                      // close the drawer
                      Navigator.pop(context);
                      // Update the state of the app
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ProfilePage(
                            FirebaseAuth.instance.currentUser.uid);
                      }));
                    },
                  ),
            ListTile(
              leading: Icon(Icons.post_add),
              title: Text('نشر قصة'),
              onTap: () {
                // close the drawer
                Navigator.pop(context);
                // Update the state of the app
                if (FirebaseAuth.instance.currentUser != null) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return PublishStoryPage();
                  }));
                } else {
                  CustomAlertDialog dialog = CustomAlertDialog(
                    title: "تنبيه",
                    message: "لنشر قصة يجب تسجيل الدخول اولا",
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
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('الأعدادات'),
              onTap: () {
                // close the drawer
                Navigator.pop(context);
                // Update the state of the app
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return SettingsPage();
                }));
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_sharp),
              title: Text('سياسة الخصوصية'),
              onTap: () async {
                // close the drawer
                Navigator.pop(context);
                // Update the state of the app
                if (await canLaunch(
                    "https://sites.google.com/view/mustafa101iq/privacy-policy")) {
                  await launch(
                      "https://sites.google.com/view/mustafa101iq/privacy-policy");
                } else {
                  throw 'Could not launch privacy policy';
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('مشاركة التطبيق'),
              onTap: () async {
                // close the drawer
                Navigator.pop(context);
                // Update the state of the app
                Share.share(
                    "https://play.google.com/store/apps/details?id=${Constants.packageName}");
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('تقيم التطبيق'),
              onTap: () async {
                // close the drawer
                Navigator.pop(context);
                // Update the state of the app
                if (await canLaunch(
                    "https://play.google.com/store/apps/details?id=${Constants.packageName}")) {
                  await launch(
                      "https://play.google.com/store/apps/details?id=${Constants.packageName}");
                } else {
                  throw 'Could not launch https://play.google.com/store/apps/details?id=${Constants.packageName}';
                }
              },
            ),
            FirebaseAuth.instance.currentUser != null
                ? ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('تسجيل الخروج'),
                    onTap: () {
                      // Update the state of the app
                      authenticationsProvider
                          .signOutUser(context)
                          .whenComplete(() {
                        // Then close the drawer
                        Navigator.pop(context);
                      });
                    },
                  )
                : SizedBox(),
          ],
        ),
      )),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        controller: tabController,
        style: TabStyle.textIn,
        items: [
          TabItem(icon: Icons.home, title: 'الرئيسية'),
          TabItem(icon: Icons.category, title: 'الاقسام'),
          TabItem(icon: Icons.email, title: 'ارسال ملاحظة'),
          TabItem(icon: Icons.info_outline, title: 'حول'),
        ],
        initialActiveIndex: selectedPage,
        //optional, default as 0
        onTap: (int i) async {
          if (i == pages.mainPage.index) {
            pageTitle = "الصفحة الرئيسة";
            isMainPage = true;
          } else if (i == pages.categoriesPage.index) {
            pageTitle = "الاقسام";
            isMainPage = false;
          } else if (i == pages.sendNotePage.index) {
            pageTitle = "ارسال ملاحظة";
            isMainPage = false;
          } else if (i == pages.aboutPage.index) {
            pageTitle = "حول التطبيق";
            isMainPage = false;
          }

          setState(() {
            selectedPage = i;
          });
        },
      ),
    );
  }

  void setNotification(Map<String, dynamic> message) {
    final notification = message['data'];
    setState(() {
      messages.add(Message(
        title: '${notification['title']}',
        body: '${notification['body']}',
      ));
    });

  }

  void getUnReadNotificationCount() async {
    int newNotificationCount = await SharedPreferencesManager.instance
        .getIntValue("newNotificationCount", 0);
    int oldNotificationCount = await SharedPreferencesManager.instance
        .getIntValue("oldNotificationCount", 0);

    await Constants.notificationReference.get().then((value) {
      int notificationCount = value.docs.length;
      SharedPreferencesManager.instance
          .setIntValue("newNotificationCount", notificationCount);
    });

    setState(() {
      unReadNotificationCount = newNotificationCount - oldNotificationCount;
    });
  }

  getCurrentUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await Constants.usersReference
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          if (mounted)
            setState(() {
              currentUser = Usser.fromDocument(doc);
            });
        }
      });
    } else {
      setState(() {
        currentUser = null;
      });
    }
  }
}
