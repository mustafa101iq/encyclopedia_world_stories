import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SendNotePage extends StatefulWidget {
  @override
  _SendNotePageState createState() => _SendNotePageState();
}

class _SendNotePageState extends State<SendNotePage> {
  static const double fontSize = 18;
  final _formKey = GlobalKey<FormState>();
  ProgressDialog pr;

  String id = DateTime.now().millisecondsSinceEpoch.toString(),
      validatorErrorText = "* مطلوب";

  TextEditingController noteController, nameController, phoneNumberController;

  @override
  void initState() {
    super.initState();

    //Initialize Text Editing Controller
    noteController = TextEditingController();
    nameController = TextEditingController();
    phoneNumberController = TextEditingController();

    //Initialize Progress Dialog
    pr = new ProgressDialog(context,
        showLogs: true, textDirection: TextDirection.rtl, isDismissible: false);
    pr.style(message: 'الرجاء الانتظار\n     جاري الارسال');

    if (FirebaseAuth.instance.currentUser != null) {
      nameController.text = FirebaseAuth.instance.currentUser.displayName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "ارسل  لنا ملاحظاتك او اقتراحتك حول تحسين التطبيق وتطويره سوف يتم اخذ جميع الملاحظات بنظر الاعتبار واضافتها في التحديثات القادمة",
                        style: new TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontFamily: "Cairo",
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  name(),
                  note(),
                  // phoneNumber(),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 30),
                      child: Material(
                        //Wrap with Material
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        elevation: 18.0,
                        color: Colors.blue,
                        clipBehavior: Clip.antiAlias,
                        // Add This
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width / 2,
                          height: 55,
                          color: Colors.blue,
                          child: new Text('ارسال',
                              style: new TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontFamily: "Cairo",
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, save data.
                              saveDataToFireStore();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  note() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            textInputAction: TextInputAction.done,
            maxLines: 8,
            controller: noteController,
            validator: (value) {
              if (value.isEmpty) {
                return validatorErrorText;
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
              hintText: "ادخل محلاحظتك هنا ...",
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

  name() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        controller: nameController,
        validator: (value) {
          if (value.isEmpty) {
            return validatorErrorText;
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
          hintText: "ادخل اسمك هنا...",
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
    );
  }

  void saveDataToFireStore() async {
    pr.show();
    Timestamp timestamp = Timestamp.now();

    Constants.notesReference.doc(id).set({
      "id": id,
      "note": noteController.text,
      "name": nameController.text,
      "timestamp": timestamp,
    }).then((value) => {
          pr.hide().whenComplete(() => {
                showToast(
                    "نشكرك على اهتمامك وارسال الملاحضات لنا ... سيتم اخذها بنظر الاعتبار")
              }),
          noteController.text = "",
          nameController.text = ""
        });
  }
}
