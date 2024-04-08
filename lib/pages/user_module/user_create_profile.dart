// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:on_spot_mechanic/providers/auth_provider.dart';
import 'package:on_spot_mechanic/pages/user_module/user_home.dart';

import 'package:provider/provider.dart';

import '../../models/user_models.dart';
import '../../utils/button.dart';
import '../../utils/colors.dart';
import '../../utils/signup_textfield.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File? image;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(Icons.arrow_back),
            onTap: () {
              AuthorizationProvider auth = AuthorizationProvider();
              auth.userSignOut();
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
            child: Column(
              children: [
                Text(
                  'Get On Board!',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor),
                ),
                SizedBox(height: 8),
                Text(
                  'Create your profile to start your Journey',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                // InkWell(
                //   onTap: () => selectImage(),
                //   child: image == null
                //       ? const CircleAvatar(
                //           backgroundColor: Colors.purple,
                //           radius: 50,
                //           child: Icon(
                //             Icons.account_circle,
                //             size: 50,
                //             color: Colors.white,
                //           ),
                //         )
                //       : CircleAvatar(
                //           backgroundImage: FileImage(image!),
                //           radius: 50,
                //         ),
                // ),
                SizedBox(height: 24),
                SignTextField(
                    hintText: "Full Name",
                    controller: nameController,
                    icon: Icons.person_outline_rounded),
                SizedBox(
                  height: 8,
                ),
                SignTextField(
                    hintText: "E-Mail",
                    controller: emailController,
                    icon: Icons.email_outlined),
                SizedBox(
                  height: 16,
                ),
                CustomButton(
                    text: "SIGN UP",
                    onPressed: () {
                      storeData();
                    })
              ],
            ),
          ),
        ));
  }

  void storeData() async {
    final ap = Provider.of<AuthorizationProvider>(context, listen: false);
    UserModel userModel = UserModel(
        email: emailController.text.trim(),
        name: nameController.text.trim(),
        phoneNumber: "",
        createdAt: '',
        uid: '');
    ap.saveUserDataToFirebase(
        context: context,
        OnSuccess: () {
          ap.saveUserDataToSP().then((value) => ap.setSignIn().then((value) =>
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserHomeScreen()),
                  (route) => false)));
        },
        userModel: userModel);
  }
}
