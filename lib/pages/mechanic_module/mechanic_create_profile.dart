// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:on_spot_mechanic/pages/mechanic_module/mechanic_home.dart';
import 'package:on_spot_mechanic/providers/auth_provider.dart'
    as MyAppAuthorizationProvider;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../models/mechanic_model.dart';
import '../../providers/auth_provider.dart';
import '../../utils/button.dart';
import '../../utils/colors.dart';
import '../../utils/signup_textfield.dart';
import '../../utils/utils.dart';

class MechanicProfile extends StatefulWidget {
  const MechanicProfile({super.key});

  @override
  State<MechanicProfile> createState() => _MechanicProfileState();
}

class _MechanicProfileState extends State<MechanicProfile> {
  File? image;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
  }

  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(Icons.arrow_back),
            onTap: () {
              AuthorizationProvider auth =
                  MyAppAuthorizationProvider.AuthorizationProvider();
              auth.userSignOut();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
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
                  InkWell(
                    onTap: () => selectImage(),
                    child: image == null
                        ? const CircleAvatar(
                            backgroundColor: Colors.teal,
                            radius: 50,
                            child: Icon(
                              Icons.account_circle,
                              size: 50,
                              color: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(image!),
                            radius: 50,
                          ),
                  ),
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
                    height: 8,
                  ),
                  SignTextField(
                      hintText: "Education",
                      controller: qualificationController,
                      icon: Icons.cast_for_education),
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
          ),
        ));
  }

  void storeData() async {
    final ap = Provider.of<AuthorizationProvider>(context, listen: false);
    MechanicModel mechanicModel = MechanicModel(
        qualification: qualificationController.text.trim(),
        email: emailController.text.trim(),
        name: nameController.text.trim(),
        phoneNumber: "",
        profilePic: "",
        createdAt: '',
        uid: '');

    ap.saveMechanicDataToFirebase(
        context: context,
        OnSuccess: () {
          ap.saveMechanicDataToSP().then((value) => ap.setSignIn().then(
              (value) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MechanicHomeScreen()),
                  (route) => false)));
        },
        mechanicModel: mechanicModel,
        profilePic: image!);
  }
}
