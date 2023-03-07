import 'package:flutter/material.dart';
import 'package:social_media_app/models/user.dart' as model;

import '../database/auth_methods.dart';

// ignore: camel_case_types
class userProvider with ChangeNotifier {
  model.User? _user; // our model user
  final AuthMethods _authMethods = AuthMethods();
  model.User get getUser => _user!; // getter for user

  Future<void> refreshUser() async {
    //
    model.User user = await _authMethods.getUserDetail();
    _user = user;
    notifyListeners();
  }
}
