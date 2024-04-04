import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/otp_screen.dart';
import '../utils/utils.dart';
import '../models/user_models.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;

  late UserModel _userModel;
  UserModel get userModel => _userModel;

  static final FirebaseAuth auth1 = FirebaseAuth.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;
  AuthProvider() {
    checkSignIn();
  }

  static Future<bool> isLoggedIn() async {
    var user = auth1.currentUser;
    return user != null;
  }

  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signed_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await auth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException error) {
            throw Exception(error.message);
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OtpScreen(verificationId: verificationId)));
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await auth.signInWithCredential(creds)).user!;

      _uid = user.uid;
      onSuccess();

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  //DATABASE OPERATIONS
  void saveUserDataToFirebase(
      {required BuildContext context,
      required UserModel userModel,
      required Function OnSuccess}) async {
    _isLoading = true;
    notifyListeners();
    try {
      userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
      userModel.phoneNumber = auth.currentUser?.phoneNumber;
      userModel.uid = auth.currentUser?.phoneNumber;
      _userModel = userModel;

      //upload to db
      await store
          .collection('users')
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        OnSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot = await store.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await auth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }

  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }
}
