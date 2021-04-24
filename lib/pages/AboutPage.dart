import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final phoneNumber = "07715456704";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'موسوعة القصص العالمية عبارة عن منصة قصصية كاملة وبيئة تفاعلية لمحبين القصص والقراءة تحتوي مجموعة كبيرة من القصص الشيقة المتجددة باستمرار  يمكنك التواصل مع المبرمج عبر :',
                  style: new TextStyle(
                      fontSize: 17.0,
                      color: Colors.white,
                      fontFamily: "Cairo",
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              elevation: 5),
          Card(
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'رقم الهاتف : $phoneNumber',
                        style: new TextStyle(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontFamily: "Cairo",
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                        color: Colors.blueAccent,
                        iconSize: 30,
                        // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                        icon: FaIcon(FontAwesomeIcons.phone),
                        onPressed: () {
                          callNumber(phoneNumber);
                        }),
                  )
                ],
              ),
              elevation: 5),
          Card(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    child: Flex(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      direction: Axis.horizontal,
                      children: [
                        Flexible(
                            child: IconButton(
                                color: Colors.blueAccent,
                                iconSize: 40,
                                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                icon: FaIcon(FontAwesomeIcons.facebook),
                                onPressed: () {
                                  openFacebookPage();
                                })),
                        Flexible(
                            child: IconButton(
                                color: Colors.pink,
                                iconSize: 40,
                                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                icon: FaIcon(FontAwesomeIcons.instagram),
                                onPressed: () {
                                  openInstagramPage();
                                })),
                        Flexible(
                            child: IconButton(
                                iconSize: 40,
                                color: Colors.blueAccent,
                                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                icon: FaIcon(FontAwesomeIcons.envelope),
                                onPressed: () {
                                  sendMessageByEmail(
                                      "mustafa.dev2230@gmail.com",
                                      "تطبيق موسوعة القصص العالمية",
                                      "");
                                })),
                        Flexible(
                            child: IconButton(
                                iconSize: 40,
                                color: Colors.green,
                                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                icon: FaIcon(FontAwesomeIcons.whatsapp),
                                onPressed: () {
                                  openWhatsApp();
                                })),
                        Flexible(
                            child: IconButton(
                                iconSize: 40,
                                color: Colors.blueAccent,
                                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                icon: FaIcon(FontAwesomeIcons.telegram),
                                onPressed: () {
                                  openTelegram();
                                })),
                      ],
                    ),
                  )),
              elevation: 5),
        ]),
      ),
    ));
  }

  void openFacebookPage() async {

    String fallbackUrl = 'https://www.facebook.com/mustafa101iq';

    try {
//    bool launched = await launch(fbProtocolUrl, forceSafariVC: false);
      bool launched = false;

      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false);
    }
  }

  void openInstagramPage() async {
    var url = 'https://www.instagram.com/mustafa_101_iq/';

    if (await canLaunch(url)) {
      await launch(url,
          universalLinksOnly: true,
          forceSafariVC: true,
          enableJavaScript: true,
          enableDomStorage: true);
    } else {
      throw 'There was a problem to open the url: $url';
    }
  }

  void openWhatsApp() async {
    var whatsappUrl = "whatsapp://send?phone=+964$phoneNumber";
    await canLaunch(whatsappUrl)
        ? launch(whatsappUrl)
        : print(
            "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }

  void openTelegram() async {
    var whatsappUrl = "https://telegram.me/mustafa101iq";
    await canLaunch(whatsappUrl)
        ? launch(whatsappUrl)
        : print(
            "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }

  sendMessageByEmail(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  callNumber(String number) {
    launch("tel://$number");
  }
}
