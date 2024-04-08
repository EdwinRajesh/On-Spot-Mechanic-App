// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:on_spot_mechanic/pages/user_module/user_home.dart';

import '../../utils/colors.dart';
import 'user_add_vehicle.dart';
import 'user_profile.dart';

class UserVehiclePage extends StatefulWidget {
  const UserVehiclePage({super.key});

  @override
  State<UserVehiclePage> createState() => _UserVehiclePageState();
}

class _UserVehiclePageState extends State<UserVehiclePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: GestureDetector(
            child: Container(
                decoration: BoxDecoration(), child: Text('Add vehicle')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserAddVehicle()),
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          color: secondaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16),
            child: GNav(
              selectedIndex: 0,
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfilePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
