import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encyclopedia_world_stories/Pages/LoginPage.dart';
import 'package:encyclopedia_world_stories/models/Comment.dart';
import 'package:encyclopedia_world_stories/nodes/CommentNode.dart';
import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/CustomAlertDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void showCommentBottomSheet(
    BuildContext context, String storyID, String storyTitle) {
  TextEditingController commentController = TextEditingController();

  if (!(storyTitle.contains('قصة') || storyTitle.contains('قصه'))) {
    storyTitle = "قصة " + storyTitle;
  }

  showMaterialModalBottomSheet(
    backgroundColor: Color(0xff111111),
    context: context,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30))),
    builder: (context) => SingleChildScrollView(
      controller: ModalScrollController.of(context),
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        height: MediaQuery.of(context).size.height / 1.3,
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ))),
                    Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Text(
                              "التعليقات على $storyTitle",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: 125,
                              height: 1,
                              child: Container(
                                color: Colors.yellow,
                              ),
                            )
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 1,
                          height: 1,
                        ))
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child:    StreamBuilder<QuerySnapshot>(
                  stream: Constants.allStoryReference.doc(storyID).collection("comments").orderBy('timestamp', descending: true).snapshots(),
                  builder: (context , AsyncSnapshot<QuerySnapshot> doc){
                    if (!doc.hasData) {
                      return SizedBox();
                    } else {
                      List<CommentNode> commentsList = [];
                      doc.data.docs.forEach((document) {
                        Comment story = Comment.fromDocument(document);

                        CommentNode storyNode = CommentNode(story);
                        commentsList.add(storyNode);
                      });

                      return ListView(children: commentsList,scrollDirection: Axis.vertical,physics: BouncingScrollPhysics(),reverse: true,);
                    }
                  },
                ),
            ),
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: TextField(
                          controller: commentController,
                          autofocus: false,
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xfff9f9f9),
                            hintText: "تعليق",
                            hintStyle: TextStyle(
                                fontSize: 15.0, color: Color(0xff9d9d9d)),
                            contentPadding: const EdgeInsets.all(8),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        height: 45,
                        child: IconButton(
                          icon: Icon(Icons.send),
                          color: Colors.blue,
                          onPressed: () {
                            if(FirebaseAuth.instance.currentUser!=null){
                              if(commentController.text.isNotEmpty){
                                sendComment(storyID,commentController);
                              }else{
                                var dialog =CustomAlertDialog(title: "تنبيه",
                                    message: "لا يمكن ارسال تعليق فارغ",
                                    positiveBtnText: "حسناً",
                                    bgColor:Color(0xff111111),
                                    circularBorderRadius: 15,
                                    onPostivePressed: () {});

                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) => dialog);
                              }
                            }else{
                              var dialog =CustomAlertDialog(title: "تنبيه",
                                message: "للتعليق على القصة يجب تسجيل الدخول اولا",
                                positiveBtnText: "تسجيل الدخول",
                                negativeBtnText: "الغاء",
                                bgColor:Color(0xff111111),
                                circularBorderRadius: 15,
                                onNegativePressed: (){},
                                onPostivePressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){return LoginPage();
                                  }));},);

                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) => dialog);

                            }

                          },
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xfff9f9f9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void sendComment(String storyId,TextEditingController commentController) {

  Timestamp timestamp = Timestamp.now();
  String commentId = timestamp.millisecondsSinceEpoch.toString();
  Constants.allStoryReference.doc(storyId).collection("comments").doc(commentId).set({
    "id" : commentId,
    "commentBy":FirebaseAuth.instance.currentUser.uid,
    "commentContent":commentController.text,
    "timestamp":timestamp
  }).whenComplete((){
    increaseStoryCommentCount(storyId);
    increaseUserInteractionsNumber(FirebaseAuth.instance.currentUser.uid);
  });
  commentController.text= "";

}
void increaseUserInteractionsNumber(String userId) {
  Constants.usersReference.doc(userId).get().then((DocumentSnapshot document){
    int storyView = document["interactionsNumber"];
    Constants.usersReference.doc(userId).update({
      "interactionsNumber":++storyView
    });

  });
}
void increaseStoryCommentCount(String storyId ) {
  Constants.allStoryReference.doc(storyId).get().then((
      DocumentSnapshot document) {
    int storyLikes = document["storyCommentsCount"];
    Constants.allStoryReference.doc(storyId).update({
      "storyCommentsCount": ++storyLikes
    });
  });
}



