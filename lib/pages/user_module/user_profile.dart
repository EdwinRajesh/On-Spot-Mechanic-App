// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../utils/colors.dart';
import 'user_home.dart';
import 'user_vehicle.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(decoration: BoxDecoration(), child: Text('Profile')),
        ),
        bottomNavigationBar: Container(
          color: secondaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16),
            child: GNav(
              selectedIndex: 2,
              backgroundColor: secondaryColor,
              color: Colors.white,
              activeColor: primaryColor,
              tabBackgroundColor: tertiaryColor,
              gap: 8,
              padding: EdgeInsets.all(8),
              tabs: [
                GButton(
                  icon: Icons.car_rental_outlined,
                  text: "Vehicles",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserVehiclePage()),
                    );
                  },
                ),
                GButton(
                  icon: Icons.home,
                  text: "Home",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserHomeScreen()),
                    );
                  },
                ),
                GButton(
                  icon: Icons.person,
                  text: "Profile",
                ),
              ],
            ),
          ),
        ));
  }
}
