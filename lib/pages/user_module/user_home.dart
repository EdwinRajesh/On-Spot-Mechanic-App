// ignore_for_file: prefer_const_constructors, library_prefixes, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:on_spot_mechanic/pages/authentication_module/welcome.dart';
import 'package:on_spot_mechanic/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:on_spot_mechanic/providers/auth_provider.dart'
    as MyAppAuthorizationProvider;

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
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: secondaryColor,
              size: 32,
            ),
            onPressed: () {},
          ),
          actions: [
            GestureDetector(
              child: IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: secondaryColor,
                  size: 24,
                ),
                onPressed: () {
                  ap.userSignOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomePage()),
                  );
                },
              ),
            ),
          ],
        ),
        body: Padding(
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
            ],
          )),
        ));
  }
}
