import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/Toast.dart';
import 'package:flutter/material.dart';
import 'package:encyclopedia_world_stories/utils/SharedPreferencesManager.dart';

class SettingsProvider with ChangeNotifier {

  double storyFontSize = Constants.defaultStoryFontSize;
  String storyBGColor = Constants.defaultStoryBgColor.toString().split('(0x')[1].split(')')[0];
  String storyFontColor = Constants.defaultStoryFontColor.toString().split('(0x')[1].split(')')[0];

  saveFontSize(double fontSize){
    SharedPreferencesManager.instance.setDoubleValue("storyFontSize", fontSize.toDouble());
    loadFontSize();
  }
  loadFontSize() async{
    storyFontSize = await SharedPreferencesManager.instance.getDoubleValue("storyFontSize", Constants.defaultStoryFontSize) ;
    notifyListeners();
  }

  saveStoryBGColor(String storyBGColor){
    SharedPreferencesManager.instance.setStringValue("storyBGColor", storyBGColor);
    loadStoryBGColor();
  }
  loadStoryBGColor() async{
    storyBGColor = await SharedPreferencesManager.instance.getStringValue("storyBGColor", Constants.defaultStoryBgColor.toString().split('(0x')[1].split(')')[0]);
    notifyListeners();
  }

  saveStoryFontColor(String storyFontColor){
    SharedPreferencesManager.instance.setStringValue("storyFontColor", storyFontColor);
    loadStoryFontColor();
  }
  loadStoryFontColor() async{
    storyFontColor = await SharedPreferencesManager.instance.getStringValue("storyFontColor", Constants.defaultStoryFontColor.toString().split('(0x')[1].split(')')[0]);
    notifyListeners();
  }

  applyChange(){
    notifyListeners();
  }
}