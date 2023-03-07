import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/database/storage_method.dart';
import 'package:social_media_app/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Method to get user Detail
  Future<model.User> getUserDetail() async {
    User? currUser = _auth.currentUser; // user which provided by firebase

    DocumentSnapshot snap = await _firestore
        .collection("users")
        .doc(currUser!.uid)
        .get(); //it will return the current user is for documents
    return model.User.fromSnap(snap);
  }

  //Mehtods for User SignUp
  Future<String> signUpUser({
    required String email,
    required String name,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          name.isEmpty ||
          bio.isNotEmpty ||
          // ignore: unnecessary_null_comparison
          file != null) {
        //register User
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        //to get the picture Url
        cred.user!.updateDisplayName(name);
        String photoUrl = await StorageMethodsClass()
            .uploadImageToStorage("ProfilePic", file, false);
        print("The url downloaded is -->$photoUrl");
        //add user to database firestore
        model.User user = model.User(
            username: username,
            name: name,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            photoUrl: photoUrl,
            followers: [],
            following: []);
        _firestore.collection("users").doc(cred.user!.uid).set(user.toJson());
        // ignore: avoid_print

        print("Data is uploaded successfully");
      }
      res = "success";
    } on FirebaseException catch (e) {
      if (e.code == "invalid-email") {
        res = "The email is badly formated.";
      } else if (e.code == "weak-password") {
        res = "Yor password is too weak";
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

//======For login users
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
        //print("User is loged In Successfully");
      } else {
        res = "Please Enter all the fields";
      }
    } on FirebaseException catch (e) {
      res = e.toString();
    }
    return res;
  }
  //--------- Methods for signOut User ----------

  Future<void> signOutUser() async {
    await _auth.signOut();
  }
}// end of auth class


