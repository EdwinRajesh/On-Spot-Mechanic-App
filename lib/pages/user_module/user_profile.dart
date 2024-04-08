// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:on_spot_mechanic/providers/auth_provider.dart'
    as MyAppAuthorizationProvider;
import 'package:provider/provider.dart';

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
    final ap = Provider.of<MyAppAuthorizationProvider.AuthorizationProvider>(
        context,
        listen: false);
    return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: primaryColor,
              backgroundImage: NetworkImage(ap.userModel.profilePic),
              radius: 64,
            ),
            const SizedBox(height: 20),
            Text(
              ap.userModel.name,
              style: TextStyle(
                  fontSize: 28,
                  color: secondaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              ap.userModel.email,
              style: TextStyle(
                fontSize: 22,
                color: tertiaryColor,
              ),
            ),
            Text(
              ap.userModel.phoneNumber ?? "",
              style: TextStyle(
                  fontSize: 20, color: silver, fontWeight: FontWeight.bold),
            )
          ],
        )),
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
