import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/httpexception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return _token;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authSegment(
      String email, String password, String urlSegment) async {
    try {
      final url =
          'https://key=';
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      autoLogOut();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      pref.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authSegment(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authSegment(email, password, 'signInWithPassword');
  }

  Future<bool> tryToLogin() async {
    try {final pref = await SharedPreferences.getInstance();
//    print('nkjkfdbkjgn');
    if(!pref.containsKey('userData')) {
      print('userData Not Found');
      return false;
    }
//    print('geklmklg');
    final extractedUserData = json.decode(pref.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if(expiryDate.isBefore(DateTime.now())){
//      print('userData expire Found');
      return false;
    }
//    print(extractedUserData['token']);
//    print(extractedUserData['userId']);
//    print(expiryDate);

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogOut();
    return true;}catch (error){
      print(error);
    }
  }

  void logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer != null ){_authTimer.cancel();
    _authTimer = null;}
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void autoLogOut() {
    if(_authTimer != null){
       _authTimer.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
//    print(timeToExpire);
    _authTimer = Timer(Duration(seconds: timeToExpire), logOut);
  }
}
