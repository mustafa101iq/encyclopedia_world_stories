import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encyclopedia_world_stories/Pages/HomePage.dart';
import 'package:encyclopedia_world_stories/models/Story.dart';
import 'package:encyclopedia_world_stories/utils/LocalData.dart';
import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/CustomAlertDialog.dart';
import 'package:encyclopedia_world_stories/widgets/HeaderWidget.dart';
import 'package:encyclopedia_world_stories/widgets/ProgressWidget.dart';
import 'package:encyclopedia_world_stories/widgets/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PublishStoryPage extends StatefulWidget {
  @override
  _PublishStoryPageState createState() => _PublishStoryPageState();
}

class _PublishStoryPageState extends State<PublishStoryPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {'storyType': null};
  TextEditingController storyTitleController, storyContentController;
  bool isSelectStoryImage = false;

  File storyImageFile = null;

  @override
  void initState() {
    super.initState();
    storyTitleController = TextEditingController();
    storyContentController = TextEditingController();
    Future.delayed(Duration.zero, () {
      showNotesDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "نشر قصة جديدة"),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                storyType(),
                storyTitle(),
                storyContent(),
                storyImage(),
                publishButton(),
              ],
            ),
          )
        ],
      ),
    );
  }

  storyType() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "نوع القصة",
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
            height: 65,
            decoration: BoxDecoration(
              color: Constants.fieldColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black),
            ),
            child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    hint: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "اضغط هنا لاختبار نوع القصة",
                        style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: Constants.h5,
                            color: Constants.fieldTextColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    icon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.redAccent,
                        size: 25,
                      ),
                    ),
                    isExpanded: true,
                    value: formData['storyType'],
                    dropdownColor: Colors.black,
                    items: storyTypeList.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item,
                            style: TextStyle(
                                fontFamily: "Cairo",
                                fontSize: Constants.h5,
                                color: Constants.fieldTextColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (selectedItem) => setState(
                          () {
                            formData['storyType'] = selectedItem;
                          },
                        ))),
          ),
        ],
      ),
    );
  }

  storyTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "عنوان القصة",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            textInputAction: TextInputAction.done,
            controller: storyTitleController,
            validator: (value) {
              if (value.isEmpty) {
                return "مطلوب";
              }
              return null;
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
              hintText: "ادخل عنوان القصة هنا ...",
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

  storyContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "محتوى القصة",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            textInputAction: TextInputAction.done,
            maxLines: 8,
            controller: storyContentController,
            validator: (value) {
              if (value.isEmpty) {
                return "مطلوب";
              }
              return null;
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
              hintText: "ادخل محتوى القصة هنا ...",
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

  storyImage() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 8, left: 8, top: 20),
      child: Column(
        children: [
          isSelectStoryImage
              ? Image(
                  image: FileImage(storyImageFile),
                  width: MediaQuery.of(context).size.width,
                  height: 110,
                )
              : Icon(
                  Icons.image_outlined,
                  size: 110,
                ),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: InkWell(
              child: Text(" تحديد صورة للقصة",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontFamily: "Cairo",
                      fontWeight: FontWeight.bold)),
              onTap: () => pickStoryImageFromGallery(),
            ),
          )
        ],
      ),
    );
  }

  pickStoryImageFromGallery() async {
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
      storyImageFile = croppedFile;

      if (storyImageFile != null)
        isSelectStoryImage = true;
      else
        isSelectStoryImage = false;
    });
  }

  publishButton() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 30),
        child: Material(
          //Wrap with Material
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
          elevation: 18.0,
          color: Colors.redAccent,
          clipBehavior: Clip.antiAlias,
          // Add This
          child: MaterialButton(
            minWidth: 300.0,
            height: 60,
            color: Colors.redAccent,
            child: new Text('نشر القصة',
                style: new TextStyle(
                    fontSize: Constants.h3,
                    color: Colors.white,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold)),
            onPressed: () async {
              // Validate returns true if the form is valid, or false
              // otherwise.
              if (_formKey.currentState.validate()) {
                // If the form is valid, send data to firebase.

                if (formData['storyType'] != null) {
                  if (storyImageFile != null) {
                    Timestamp timestamp = Timestamp.now();
                    String storyID =
                        timestamp.millisecondsSinceEpoch.toString();
                    String storyImageName = "storyImage$storyID";
                    Reference storyImageReference =
                        Constants.allStoryImagesReference;

                    // switch(formData['storyType']){
                    //   case horrorStoriesStr :
                    //     storyImageName = "horrorStories_$storyID.jpg" ;
                    //     break;
                    //   case expressiveStoriesStr :
                    //     storyImageName = "expressiveStories_$storyID.jpg" ;
                    //     break;
                    // }

                    //show loading progress
                    showProgressDialog(context, "جاري نشر القصة ...");

                    //upload image and get url from firebase storage
                    storyImageReference =
                        storyImageReference.child(storyImageName);
                    String storyImageUrl = await uploadPhoto(storyImageFile, storyImageReference);
                    Story story = Story(
                        id: storyID,
                        publishedBy: FirebaseAuth.instance.currentUser.uid,
                        storyType: formData['storyType'],
                        storyTitle: storyTitleController.text,
                        storyContent: storyContentController.text,
                        storyImageUrl: storyImageUrl,
                        isApproved: false,
                        storyLikesCount: 0,
                        storyCommentsCount: 0,
                        storyViewedCount: 0,
                        timestamp: timestamp);
                    saveDataToFireStore(story: story);
                  } else {
                    showToast("يجب اختيار صورة للقصة");
                  }
                } else {
                  showToast("يجب اختيار نوع القصة");
                }
              }
            },
          ),
        ),
      ),
    );
  }

  void saveDataToFireStore({Story story}) async {
    //save data to fireStore
    Constants.allStoryReference.doc(story.id).set({
      "id": story.id,
      "publishedBy": story.publishedBy,
      "storyType": story.storyType,
      "storyTitle": story.storyTitle,
      "storyContent": story.storyContent,
      "storyImageUrl": story.storyImageUrl,
      "isApproved": story.isApproved,
      "storyLikesCount": story.storyLikesCount,
      "storyCommentsCount": story.storyCommentsCount,
      "storyViewedCount": story.storyViewedCount,
      "timestamp": story.timestamp
    }).whenComplete(() async {
      await Constants.usersReference
          .doc(story.publishedBy)
          .collection("myStory")
          .doc(story.id)
          .set({"id": story.id, "timestamp": story.timestamp});

      await Constants.usersReference
          .doc(story.publishedBy)
          .collection("myStory")
          .get()
          .then((value) {
        int publisherStoryNumber = value.docs.length - 1;
        Constants.usersReference
            .doc(story.publishedBy)
            .update({"storiesNumber": ++publisherStoryNumber});
      });

      hideProgressDialog().whenComplete(() => {
            showToast("القصة تحت المراجعة"),
            // Navigator.pop(context),
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return HomePage();
            }))
          });
    });
  }

  Future<String> uploadPhoto(File imageFile, Reference storageReference) async {
    UploadTask storageUploadTask = storageReference.putFile(imageFile);
    String downloadUrl = await (await storageUploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  void showNotesDialog() {
    CustomAlertDialog dialog = CustomAlertDialog(
      title: "محلاحظات مهمة",
      message: "1- يجب ان تكون القصة غير موجودة في التطبيق\n"
          "2- يجب اختيار صورة ترمز للقصة او نوع القصة\n"
          "3-سوف يتم مراجعة القصة قبل نشرها من قبل ادارة التطبيق وسوف يتم الموافقه عليها في اقرب وقت\n",
      positiveBtnText: "موافق",
      bgColor: Color(0xff111111),
      circularBorderRadius: 15,
      onPostivePressed: () {},
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialog);
  }
}
