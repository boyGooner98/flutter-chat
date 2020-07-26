import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String userId;
  String token;
  String tokenExpirationTime;
  String mobileNumber;
  bool _isAuthenticated = false;
  bool get isAuth {
    return _isAuthenticated == true;
  }

  Future<void> registerUser(String email, String password, String name) async {
    try {
      const url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBQx0VFQY9Rl6QtlDyjLDGMoLVrMFOXLLQ';
      var response =
          await http.post(url, body: json.encode({'email': email, 'password': password, 'returnSecureToken': true}));
      final responseData = json.decode(response.body);
      token = responseData['idToken'];
      tokenExpirationTime = responseData['expiresIn'];
      _isAuthenticated = true;
      userId = responseData['localId'];

      await Firestore.instance.document('users/$userId').setData({
        'userData': {
          'id': userId,
          'name': name,
          'imageUrl':
              'https://images.pexels.com/photos/2228586/pexels-photo-2228586.jpeg?cs=srgb&dl=woman-holding-white-book-2228586.jpg&fm=jpg',
        },
      });
      await Firestore.instance
          .document('active-users/$userId')
          .setData({'isActive': true, 'lastActiveTime': Timestamp.now(), 'id': userId});
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  Future<void> loginUser(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBQx0VFQY9Rl6QtlDyjLDGMoLVrMFOXLLQ';
    var response =
        await http.post(url, body: json.encode({'email': email, 'password': password, 'returnSecureToken': true}));
    final responseData = json.decode(response.body);
    token = responseData['idToken'];
    tokenExpirationTime = responseData['expiresIn'];
    _isAuthenticated = true;
    userId = responseData['localId'];
    await Firestore.instance.document('active-users/$userId').setData({
      'isActive': true,
      'lastActiveTime': Timestamp.now(),
      'id': responseData['localId'],
    });
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'userId': userId,
      'token': token,
    });
    prefs.setString('userData', userData);
  }
}
