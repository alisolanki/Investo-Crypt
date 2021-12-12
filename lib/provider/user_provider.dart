import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  late UserModel userModel;

  setUser(UserModel _userModel) {
    userModel = _userModel;
    notifyListeners();
  }
}
