// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:on_spot_mechanic/pages/welcome.dart';

import '../utils/colors.dart';
import '../utils/utils.dart';
import 'mechanic_profile.dart';
import 'user_profile.dart';

class ProfileSelectionPage extends StatefulWidget {
  const ProfileSelectionPage({super.key});

  @override
  State<ProfileSelectionPage> createState() => _ProfileSelectionPageState();
}

class _ProfileSelectionPageState extends State<ProfileSelectionPage> {
  void signOutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      showSnackBar(context, "Successfully signed out");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Your Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            signOutUser(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfile()),
                );
              },
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 56,
                    child: Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'USER',
                    style: TextStyle(
                      color: tertiaryColor,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MechanicProfile()),
                );
              },
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 56,
                    child: Center(
                      child: Icon(
                        Icons.car_repair,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'MECHANIC',
                    style: TextStyle(
                      color: tertiaryColor,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}