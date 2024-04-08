// ignore_for_file: prefer_const_constructors, library_prefixes, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:on_spot_mechanic/pages/user_module/home_cards.dart/card.dart';
import 'package:on_spot_mechanic/pages/user_module/home_cards.dart/drawer_user.dart';
import 'package:on_spot_mechanic/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:on_spot_mechanic/providers/auth_provider.dart'
    as MyAppAuthorizationProvider;

import '../chat_bot.dart';
import 'user_profile.dart';
import 'user_vehicle.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<MyAppAuthorizationProvider.AuthorizationProvider>(
        context,
        listen: false);
    String name = ap.userModel.name.split(' ')[0];
    String userName = name[0].toUpperCase() + name.substring(1);
    return Scaffold(
        drawer: UserDrawer(),
        appBar: AppBar(
          actions: [],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Hey, ",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "$userName",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserCard(
                        name: "2 Wheel Repair",
                        svgPath: 'assets/bike.svg',
                      ),
                      UserCard(
                        name: "4 Wheel Repair",
                        svgPath: 'assets/car.svg',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserCard(
                          name: "6 Wheel Repair", svgPath: 'assets/6wheel.svg'),
                      UserCard(name: "Tow Service", svgPath: 'assets/tow.svg'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          },
          backgroundColor: primaryColor,
          child: Icon(
            Icons.android_outlined,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: MiddleRightFloatingActionButtonLocation(),
        bottomNavigationBar: Container(
          color: secondaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16),
            child: GNav(
              selectedIndex: 1,
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

class MiddleRightFloatingActionButtonLocation
    extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double x = scaffoldGeometry.scaffoldSize.width - 88.0;
    final double screenHeight = scaffoldGeometry.scaffoldSize.height;
    final double buttonHeight = 56.0;
    final double y = screenHeight / 6 -
        buttonHeight / 1.4; // Position between middle and bottom
    return Offset(x, y);
  }
}
