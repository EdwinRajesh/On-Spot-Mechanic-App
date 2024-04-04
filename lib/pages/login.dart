// ignore_for_file: prefer_const_constructors

// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:on_spot_mechanic/pages/registration.dart';

import 'package:provider/provider.dart';
import '../authentication/auth_provider.dart' as MyAppAuthProvider;
import '../utils/button.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import 'welcome.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isValidPhone = false;

  TextEditingController phoneController = TextEditingController();

  bool isNumeric(String text) {
    RegExp numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(text);
  }

  void updateValidity() {
    setState(() {
      isValidPhone =
          phoneController.text.length == 10 && isNumeric(phoneController.text);
    });
  }

  Future<void> _login(BuildContext context) async {
    final String phoneNumber = phoneController.text.trim();

    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('phoneNumber', isEqualTo: phoneNumber)
            .get();

    if (!querySnapshot.docs.isNotEmpty) {
      sendPhoneNumber();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Phone number is not registered.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<bool> checkUserExists(String phoneNumber) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  void sendPhoneNumber() {
    final ap =
        Provider.of<MyAppAuthProvider.AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+91$phoneNumber");
  }

  void checkUserExistsFunction() async {
    String phoneNumber = phoneController.text.trim();
    bool userExists = await checkUserExists(phoneNumber);
    if (userExists) {
      sendPhoneNumber();
    } else {
      showSnackBar(context, "You have'nt  registered yet!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WelcomePage()));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Login to your account to access our services',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                textField(),
                SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: registerButton(context),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        "Not registered yet?",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Registration()));
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding textField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        controller: phoneController,
        cursorColor: primaryColor,
        onChanged: (value) {
          updateValidity();
        },
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 11.0, 8.0, 0),
            child: Text(
              '+91',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 13, 10, 13)),
            ),
          ),
          suffixIcon: isValidPhone
              ? Icon(
                  Icons.check_circle,
                  color: primaryColor,
                  size: 32,
                )
              : null,
          hintText: "Enter phone number",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
      ),
    );
  }

  Padding registerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: CustomButton(
        text: 'Sign In',
        onPressed: () {
          isValidPhone
              ? _login(context)
              : showSnackBar(context, "Invalid Number");
        },
      ),
    );
  }
}
