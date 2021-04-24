import 'dart:io';

import 'package:encyclopedia_world_stories/Pages/HomePage.dart';
import 'package:encyclopedia_world_stories/Pages/LoginPage.dart';
import 'package:encyclopedia_world_stories/providers/AuthenticationsProvider.dart';
import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/HeaderWidget.dart';
import 'package:encyclopedia_world_stories/widgets/ProgressWidget.dart';
import 'package:encyclopedia_world_stories/widgets/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  _SignUpPageState();

  String email, password, displayName, photoUrl;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isSelectProfileImage = false;

  File profileImageFile = null;

  @override
  Widget build(BuildContext context) {
    AuthenticationsProvider authenticationsProvider = Provider.of<AuthenticationsProvider>(context);
    return Scaffold(
      appBar: header(context, strTitle: "انشاء حساب"),
      body: ListView(
        padding: EdgeInsets.all(10),
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.90,
            child: Form(
              key: formkey,
              child: Column(
                children: <Widget>[
                  nameTextField(),
                  emailTextField(),
                  passwordTextField(),
                  profileImage(),
                  Container(
                    width: 200,
                    height: 45,
                    child: RaisedButton(
                      onPressed: () {
                        handleSignUp();
                      },
                      color: Colors.green,
                      textColor: Colors.white,
                      child: Text(
                        "تسجيل",
                      ),
                    ),
                  ),
                ],
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
            onPressed: () => authenticationsProvider
                .googleSignIn(context)
                .whenComplete(() async {
              User user = FirebaseAuth.instance.currentUser;
              bool isSignIn =
                  await authenticationsProvider.googleSignIn(context);
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
            }),
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
              Text("تمتلك حساب ؟", style: TextStyle(fontSize: 15)),
              SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () {
                  // send to login screen
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text(
                  "سجل دخول الان",
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void handleSignUp() async {
    AuthenticationsProvider authenticationsProvider =
        Provider.of<AuthenticationsProvider>(context, listen: false);
    if (formkey.currentState.validate()) {
      if (profileImageFile != null) {
        //formkey.currentState.save();

        authenticationsProvider
            .signUp(
                email: email.trim(),
                password: password,
                displayName: displayName,
                profileImageFile: profileImageFile,
                context: context)
            .then((value) {
          if (value != null) {
            Navigator.of(context).pop();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          }
        });
      } else {
        showToast("يجب تحميل صورة شخصية اولا");
      }
    }
  }

  nameTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "الاسم الكامل",
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
              RequiredValidator(errorText: "* الاسم مطلوب"),
            ]),
            onChanged: (val) {
              displayName = val;
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
              hintText: "ادخل اسمك الكامل",
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

  profileImage() {
    return Container(
      height: 210,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 8, left: 8, top: 20),
      child: Column(
        children: [
          Image(
            image: isSelectProfileImage
                ? FileImage(profileImageFile)
                : AssetImage("assets/images/gen.png"),
            width: MediaQuery.of(context).size.width,
            height: 100,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: InkWell(
              child: Text(" تحديد صورة شخصية",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15,
                      fontFamily: "Cairo",
                      fontWeight: FontWeight.bold)),
              onTap: () => pickProfileImageFromGallery(),
            ),
          )
        ],
      ),
    );
  }

  pickProfileImageFromGallery() async {
    File file = (await ImagePicker.pickImage(source: ImageSource.gallery));
    File croppedFile = file != null
        ? await ImageCropper.cropImage(
            sourcePath: file.path,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.blueAccent,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 1.0,
            ))
        : null;
    setState(() {
      profileImageFile = croppedFile;

      if (profileImageFile != null)
        isSelectProfileImage = true;
      else
        isSelectProfileImage = false;
    });
  }
}
