import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:pamper_app_web/Modal/User.dart';


import 'Database.dart';
User currentUser;
FirebaseUser _user;
class signinUser extends ChangeNotifier{
  String _uid;
  String _email;
  String get getUid => _uid;
  String get getEmail => _email;
  FirebaseAuth _auth = FirebaseAuth.instance;
  // final DynamicLinkService dynamicLinkService = locator<DynamicLinkService>();

  Future<String> signUpUser(
      String email, String password, String fullName) async {
    String retVal = "error";
    try {
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      User _user = User(
        id: _authResult.user.uid,
        email: _authResult.user.email,
        username: fullName.trim(),
      );
      String _returnString = await DatabaseMethods().createUser(_user);
      DocumentSnapshot documentSnapshot = await Firestore.instance.collection("Users").document(_authResult.user.uid).get();
      currentUser = User.fromDocument(documentSnapshot);
      if (_returnString == "success") {
        retVal = "success";
      }
    } on PlatformException catch (e) {
      retVal = e.message;
    } catch (e) {
      print(e);
    }

    return retVal;
  }
  Future<String> loginUserWithEmail(String email, String password) async {
    String retVal = "error";

    try {
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      DocumentSnapshot documentSnapshot = await Firestore.instance.collection("Users").document(_authResult.user.uid).get();
      currentUser = User.fromDocument(documentSnapshot);
    } on PlatformException catch (e) {
      retVal = e.message;
    } catch (e) {
      print(e);
    }

    return retVal;
  }


}