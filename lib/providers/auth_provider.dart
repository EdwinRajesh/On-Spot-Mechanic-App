import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/mechanic_model.dart';
import '../pages/authentication_module/otp_screen.dart';
import '../utils/utils.dart';
import '../models/user_models.dart';

class AuthorizationProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;

  late UserModel _userModel = UserModel(
    name: 'John Doe',
    email: 'john@example.com',
    createdAt: DateTime.now().toString(),
    phoneNumber: '1234567890',
    uid: 'user123',
  );
  UserModel get userModel => _userModel;

  late MechanicModel _mechanicModel;
  MechanicModel get mechanicModel => _mechanicModel;

  static final FirebaseAuth auth1 = FirebaseAuth.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;
  AuthorizationProvider() {
    checkSignIn();
  }

//check Log in

  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signed_in") ?? false;
    notifyListeners();
  }

//set sign in
  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  //sign out
  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await auth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }

//register the phinoe number guys
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

//otp verification
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

  Future getDataFromFirestore() async {
    await store
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        name: snapshot['name'],
        email: snapshot['email'],
        createdAt: snapshot['createdAt'],
        uid: snapshot['uid'],
        phoneNumber: snapshot['phoneNumber'],
      );
      _uid = userModel.uid;
    });
  }

//check if user is registered
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot = await store.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? "";
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel.uid;
    notifyListeners();
  }

  //Mechanic
  void saveMechanicDataToFirebase(
      {required BuildContext context,
      required MechanicModel mechanicModel,
      required Function OnSuccess}) async {
    _isLoading = true;
    notifyListeners();
    try {
      mechanicModel.createdAt =
          DateTime.now().millisecondsSinceEpoch.toString();
      mechanicModel.phoneNumber = auth.currentUser?.phoneNumber;
      mechanicModel.uid = auth.currentUser?.phoneNumber;
      _mechanicModel = mechanicModel;

      //upload to db
      await store
          .collection('mechanic')
          .doc(_uid)
          .set(mechanicModel.toMap())
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

  Future saveMechanicDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("mechanic_model", jsonEncode(mechanicModel.toMap()));
  }

  Future getMechanicDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("mechanic_model") ?? "";
    _mechanicModel = MechanicModel.fromMap(jsonDecode(data));
    _uid = _mechanicModel.uid;
    notifyListeners();
  }

  Future<bool> checkExistingMechanic() async {
    DocumentSnapshot snapshot =
        await store.collection("mechanic").doc(_uid).get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future getMechanicDataFromFirestore() async {
    await store
        .collection("mechanic")
        .doc(auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _mechanicModel = MechanicModel(
        name: snapshot['name'],
        email: snapshot['email'],
        createdAt: snapshot['createdAt'],
        uid: snapshot['uid'],
        phoneNumber: snapshot['phoneNumber'],
      );
      _uid = mechanicModel.uid;
    });
  }
}
