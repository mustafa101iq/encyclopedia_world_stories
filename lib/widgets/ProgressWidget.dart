import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: CircularProgressIndicator(

      valueColor:AlwaysStoppedAnimation(Colors.green) ,
    ),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: LinearProgressIndicator(
      valueColor:AlwaysStoppedAnimation(Colors.green) ,
    ),
  );
}

ProgressDialog pr;
showProgressDialog(BuildContext context,String message){
  // init progress dialog
  pr = new ProgressDialog(context,
      showLogs: true, textDirection: TextDirection.rtl, isDismissible: false);
  pr.style(message: message,textAlign: TextAlign.center);
  pr.show();
}
hideProgressDialog(){
  return pr.hide();
}
