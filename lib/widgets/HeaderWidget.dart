import 'package:flutter/material.dart';


AppBar header(context , { String strTitle ,bool disappearBackButton = false,bool lineThrough = false}) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white
    ),
    automaticallyImplyLeading: disappearBackButton ? false : true ,
    title: Text(strTitle,
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 18,
        color: Colors.white,
        decoration: lineThrough ? TextDecoration.lineThrough : TextDecoration.none
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor:Theme.of(context).primaryColor,

  );
}
