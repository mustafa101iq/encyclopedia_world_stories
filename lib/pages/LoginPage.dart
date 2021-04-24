import 'dart:io';

import 'package:encyclopedia_world_stories/Pages/HomePage.dart';
import 'package:encyclopedia_world_stories/Pages/SignupPage.dart';
import 'package:encyclopedia_world_stories/providers/AuthenticationsProvider.dart';
import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/ProgressWidget.dart';
import 'package:encyclopedia_world_stories/widgets/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    var authenticationsProvider = Provider.of<AuthenticationsProvider>(context);
    FlutterStatusbarcolor.setStatusBarColor(Colors.black);

    return Scaffold(
      body: SingleChildScrollView(
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(50.0)),
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 80,
                    height: 80,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "موسوعة القصص العالمية",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: "Cairo",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      emailTextField(),
                      passwordTextField(),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: 200,
                        height: 45,
                        child: RaisedButton(
                          // passing an additional context parameter to show dialog boxs
                          onPressed: login,
                          color: Colors.green,
                          textColor: Colors.white,
                          child: Text(
                            "تسجيل دخول",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, right: 15, left: 15),
              child: Row(
                children: [
                  Expanded(
                      flex: 7,
                      child: SizedBox(
                          height: 1,
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: Container(
                            color: Colors.white,
                          ))),
                  Expanded(
                      flex: 1,
                      child: Center(
                          child: Text(
                        "أو",
                        style: TextStyle(fontSize: 18),
                      ))),
                  Expanded(
                      flex: 7,
                      child: SizedBox(
                          height: 1,
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: Container(
                            color: Colors.white,
                          )))
                ],
              ),
            ),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                bool isSignIn = await authenticationsProvider.googleSignIn(context);

                if (isSignIn) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ));
                } else {
                  hideProgressDialog();
                }
              },
              child: Image.asset(
                'assets/images/signin.png',
                width: 200.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("لا تمتلك حساب ؟", style: TextStyle(fontSize: 15)),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    // send to login screen
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text(
                    "سجل الان",
                    style: TextStyle(color: Colors.green, fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void login() async{
    var authenticationsProvider = Provider.of<AuthenticationsProvider>(context, listen: false);
    if (formkey.currentState.validate()) {
      if(await isInternetAvailable()){
        showProgressDialog(context, "جاري تسجيل الدخول...");
        // formkey.currentState.save();
        authenticationsProvider
            .signin(email, password, context)
            .then((value) async {
          if (value != null) {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ));
          }
        });
      }else {
        showToast("لا يوجد اتصال ب الانترنت");
      }

    }
  }

  emailTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "البريد الالكتروني",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            textInputAction: TextInputAction.done,
            //   controller: storyTitleController,
            validator: MultiValidator([
              RequiredValidator(errorText: "* البريد الالكتروني مطلوب"),
              EmailValidator(errorText: "* بريد الكتروني غير صالح"),
            ]),
            onChanged: (val) {
              email = val;
            },
            style: TextStyle(
                fontFamily: "Cairo",
                fontSize: Constants.h5,
                color: Constants.fieldTextColor,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              errorStyle: TextStyle(
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent),
              fillColor: Constants.fieldColor,
              filled: true,
              hintText: "ادخل البريد الالكتروني",
              hintStyle: TextStyle(
                  fontFamily: "Cairo",
                  fontSize: Constants.h5,
                  color: Constants.fieldTextColor,
                  fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey[900]),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  passwordTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "كلمة السر",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            obscureText: true,
            textInputAction: TextInputAction.done,
            //   controller: storyTitleController,
            validator: MultiValidator([
              RequiredValidator(errorText: "* كلمة السر مطلوبة"),
              MinLengthValidator(6,
                  errorText: "* ادخل 6 رموز او ارقام على الاقل"),
            ]),
            onChanged: (val) {
              password = val;
            },
            style: TextStyle(
                fontFamily: "Cairo",
                fontSize: Constants.h5,
                color: Constants.fieldTextColor,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              errorStyle: TextStyle(
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent),
              fillColor: Constants.fieldColor,
              filled: true,
              hintText: "ادخل كلمة السر",
              hintStyle: TextStyle(
                  fontFamily: "Cairo",
                  fontSize: Constants.h5,
                  color: Constants.fieldTextColor,
                  fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey[900]),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> isInternetAvailable() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }else{
        return false ;
      }
    } on SocketException catch (_) {
      return false ;
    }
  }

}
