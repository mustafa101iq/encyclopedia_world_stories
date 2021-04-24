import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encyclopedia_world_stories/models/Usser.dart';
import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/ProgressWidget.dart';
import 'package:encyclopedia_world_stories/widgets/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status {Uninitialized,Authenticated, Unauthenticated }

class AuthenticationsProvider with ChangeNotifier{
  FirebaseAuth _auth ;
  final gooleSignIn = GoogleSignIn();

  Status _status = Status.Uninitialized;

  AuthenticationsProvider.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;


  Future<bool> googleSignIn(BuildContext context) async {

    showProgressDialog(context,"انتظر ثواني ...");
    GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();

    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      await _auth.signInWithCredential(credential);

      User user = _auth.currentUser;
      Usser usser = Usser(id: user.uid,displayName: user.displayName,email: user.email,photoUrl: user.photoURL);
      saveUserDataToFireStore(user: usser);
      _status = Status.Authenticated;
      notifyListeners();
      hideProgressDialog();
      return Future.value(true);
    }
    _status = Status.Unauthenticated;
    notifyListeners();
     return Future.value(false);
  }

  Future<User> signin(String email, String password, BuildContext context) async {
    showProgressDialog(context,"جاري تسجيل الدخول...");
    try {
      UserCredential result =
      await _auth.signInWithEmailAndPassword(email: email, password: email);
      User user = result.user;
      showToast("تم تسجيل الدخول بنجاح");
      hideProgressDialog();
      notifyListeners();
     return Future.value(user);
    } catch (e) {
      // simply passing error code as a message
      print(e.code);
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          showToast("البريد الالكتروني غير صحيح");
          break;
        case 'ERROR_WRONG_PASSWORD':
          showToast("كلمة السر غير صحيحة");
          break;
        case 'ERROR_USER_NOT_FOUND':
          showToast("المستخدم غير موجود");
          break;
        case 'ERROR_USER_DISABLED':
          showToast("المستخدم غير مفعل");
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          showToast("الكثير من الطلبات");
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          showToast("العملية غير مسموح بها");
          break;


      }

      hideProgressDialog();
      _status = Status.Unauthenticated;
      notifyListeners();
     return Future.value(null);
    }
  }

  Future<User> signUp({String email, String password,String displayName ,File profileImageFile, BuildContext context}) async {
    showProgressDialog(context,"جاري التسجيل...");
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: email);
      User user = result.user;
      String userProfileImageName = "profileImage${user.uid}";

      String photoUrl = await uploadPhoto(profileImageFile,Constants.userProfileImageReference.child(userProfileImageName));
      Usser usser = Usser(id: user.uid,displayName: displayName,email: user.email,photoUrl: photoUrl);

      saveUserDataToFireStore(user: usser);
      hideProgressDialog();
      _status = Status.Authenticated;
     // await getCurrentUser();
      notifyListeners();
      return Future.value(user);
      // return Future.value(true);
    } catch (error) {
      switch (error.code) {
        case "email-already-in-use":
          showToast("البريد الالكتروني مستخدم");
          break;
        case "email-already-exists":
          showToast("البريد الالكتروني موجود");
          break;
        case 'invalid-email':
          showToast("البريد الالكتروني غير صحيح");
          break;
        case 'weak-password':
          showToast("الرجاء اختيار كلمة سر قوية");
          break;
      }
      hideProgressDialog();
      _status = Status.Unauthenticated;
      notifyListeners();
      return Future.value(null);
    }

  }

  Future<void> signOutUser(BuildContext context) async {
    showProgressDialog(context,"جاري تسجيل الخروج");
    User user = _auth.currentUser;
   // print(user.providerData[0].providerId);
    if (user.providerData[0].providerId == 'google.com') {
      await gooleSignIn.disconnect();
    }
    await _auth.signOut();
    hideProgressDialog();
    showToast("تم تسجيل الخروج بنجاح");
    _status = Status.Unauthenticated;
    notifyListeners();
  }

  void saveUserDataToFireStore({Usser user})  {

    Timestamp timestamp = Timestamp.now();

    Constants.usersReference.doc(user.id).get().then((DocumentSnapshot doc) {
      if(!doc.exists)
        //save data to fireStore
        Constants.usersReference.doc(user.id).set({
          "id": user.id,
          "displayName": user.displayName,
          "email": user.email,
          "photoUrl": user.photoUrl,
          "isUserVerification": false,
          "interactionsNumber": 0,
          "storiesNumber": 0,
          "timestamp" : timestamp
        });
    }).whenComplete(() {
      hideProgressDialog();
      showToast("تم تسجيل الدخول بنجاح");
    });


  }

  Future<String> uploadPhoto(File imageFile,Reference storageReference) async {
    UploadTask storageUploadTask = storageReference.putFile(imageFile);
    String downloadUrl = await (await storageUploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      // _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

}