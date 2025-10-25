import 'package:flutter/foundation.dart';

class AuthService {
  static const String _correctUsername = 'user';
  static const String _correctPassword = 'pass';

  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (username == _correctUsername && password == _correctPassword) {
      debugPrint("Authentication successful. You are going to login.");
      return true;
    } else {
      debugPrint("Authentication failed. Try Again.");
      return false;
    }
  }
}
