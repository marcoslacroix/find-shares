import 'package:flutter/foundation.dart';

class Auth with ChangeNotifier {
  late String _token;

  String get token => _token;

  set token(String value) {
    _token = value;
    notifyListeners();
  }
}
