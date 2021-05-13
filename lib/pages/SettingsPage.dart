import 'package:encyclopedia_world_stories/providers/SettingsProvider.dart';
import 'package:encyclopedia_world_stories/utils/SharedPreferencesManager.dart';
import 'package:encyclopedia_world_stories/widgets/HeaderWidget.dart';
import 'package:encyclopedia_world_stories/widgets/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    settingsProvider.loadFontSize();
    settingsProvider.loadStoryBGColor();
    settingsProvider.loadStoryFontColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "الأعدادات"),
      body: ListView(
        children: [
          changeStoryFontSize(),
          changeStoryBGColor(),
          changeStoryFontColor(),
          testChangeCard(),
          backToDefaultSettings()
        ],
      ),
    );
  }

  changeStoryFontSize() {
    var settingsProvider = Provider.of<SettingsProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "تغير حجم خط القصة",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(right: 10, top: 3, bottom: 3),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xfff9f9f9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  onPressed: () {
                    settingsProvider
                        .saveFontSize(++settingsProvider.storyFontSize);
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Text(
                  settingsProvider.storyFontSize.toString(),
                  style: TextStyle(color: Colors.black),
                ),
                FlatButton(
                  onPressed: () {
                    settingsProvider
                        .saveFontSize(--settingsProvider.storyFontSize);
                  },
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  changeStoryBGColor() {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "تغير لون خلفية القصة",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(right: 10, top: 3, bottom: 3),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xfff9f9f9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FlatButton(
                  onPressed: () {
                    // raise the [showDialog] widget
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "موافق",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 18),
                                    ))
                              ],
                              backgroundColor: Color(0xff111111),
                              title: const Text('اختر لون الخلفية !'),
                              content: SingleChildScrollView(
                                  child: BlockPicker(
                                pickerColor: Color(int.parse(
                                    settingsProvider.storyBGColor,
                                    radix: 16)),
                                onColorChanged: (color) {
                                  setState(() {
                                    String colorString =
                                        color.toString(); // Color(0x12345678)
                                    String hexColorString = colorString
                                        .split('(0x')[1]
                                        .split(')')[0];
                                    settingsProvider
                                        .saveStoryBGColor(hexColorString);
                                  });
                                },
                              )));
                        });
                  },
                  child: Icon(Icons.color_lens,
                      color: Color(
                          int.parse(settingsProvider.storyBGColor, radix: 16))),
                ),
                Text(
                  "اختر لون مريح للعين",
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  changeStoryFontColor() {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "تغير لون خط القصة",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(right: 10, top: 3, bottom: 3),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xfff9f9f9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FlatButton(
                  onPressed: () {
                    // raise the [showDialog] widget
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "موافق",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 18),
                                    ))
                              ],
                              backgroundColor: Color(0xff111111),
                              title: const Text('اختر لون الخط!'),
                              content: SingleChildScrollView(
                                  child: BlockPicker(
                                pickerColor: Color(int.parse(
                                    settingsProvider.storyFontColor,
                                    radix: 16)),
                                onColorChanged: (color) {
                                  setState(() {
                                    String colorString =
                                        color.toString(); // Color(0x12345678)
                                    String hexColorString = colorString
                                        .split('(0x')[1]
                                        .split(')')[0];
                                    settingsProvider
                                        .saveStoryFontColor(hexColorString);
                                  });
                                },
                              )));
                        });
                  },
                  child: Icon(Icons.color_lens,
                      color: Color(int.parse(settingsProvider.storyFontColor,
                          radix: 16))),
                ),
                Text(
                  "اختر لون يتناسب مع لون الخلفية",
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  testChangeCard() {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 8, left: 8),
      child: Container(
        height: 200,
        padding: EdgeInsets.only(right: 10, top: 3, bottom: 3),
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(
          color: Color(int.parse(settingsProvider.storyBGColor, radix: 16)),
          // border: Border.all(
          //   color: Colors.grey[600],
          //   width: 1.0 ,
          // ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
          child: SingleChildScrollView(
            child: Text(
                "هنا يتم تطبيق جميع التغيرات التي تقوم بأجراها يرجى اختيار الوان متناسقة ومريحة للعين",
                softWrap: true,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: settingsProvider.storyFontSize.toDouble(),
                  color: Color(
                      int.parse(settingsProvider.storyFontColor, radix: 16)),
                )),
          ),
        ),
      ),
    );
  }

  backToDefaultSettings() {

    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 8, left: 8),
      child: Container(
          padding: const EdgeInsets.all(4),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            // border: Border.all(
            //   color: Colors.grey[600],
            //   width: 1.0 ,
            // ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: FlatButton(
            child: Text(
              "الرجوع الى الاعدادات الافتراضية",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              SharedPreferencesManager.instance.removeValue("storyFontSize");
              SharedPreferencesManager.instance.removeValue("storyBGColor");
              SharedPreferencesManager.instance.removeValue("storyFontColor");
              settingsProvider.loadStoryFontColor();
              settingsProvider.loadStoryBGColor();
              settingsProvider.loadFontSize();
              settingsProvider.applyChange();
              showToast("تم الرجوع الى الاعدادات الافتراضية");
            },
          )),
    );
  }
}
