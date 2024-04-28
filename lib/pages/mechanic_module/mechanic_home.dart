// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:on_spot_mechanic/providers/auth_provider.dart'
    as MyAppAuthorizationProvider;

import '../../utils/colors.dart';
import '../authentication_module/welcome.dart';

class MechanicHomeScreen extends StatefulWidget {
  const MechanicHomeScreen({super.key});

  @override
  State<MechanicHomeScreen> createState() => _MechanicHomeScreenState();
}

class _MechanicHomeScreenState extends State<MechanicHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<MyAppAuthorizationProvider.AuthorizationProvider>(
        context,
        listen: false);
    String name = ap.mechanicModel.name.split(' ')[0];
    String userName = name[0].toUpperCase() + name.substring(1);
    return Scaffold(
        appBar: AppBar(
          title: Text("Mechanic"),
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
                    // ignore: unnecessary_string_interpolations
                    "$userName",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 128,
              ),
              CircleAvatar(
                backgroundColor: primaryColor,
                backgroundImage: NetworkImage(ap.mechanicModel.profilePic),
                radius: 64,
              ),
              const SizedBox(height: 20),
              Text(
                ap.mechanicModel.name,
                style: TextStyle(
                    fontSize: 28,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                ap.mechanicModel.email,
                style: TextStyle(
                  fontSize: 22,
                  color: tertiaryColor,
                ),
              ),
              Text(
                ap.mechanicModel.phoneNumber ?? "",
                style: TextStyle(
                    fontSize: 20, color: silver, fontWeight: FontWeight.bold),
              ),
              Text(
                ap.mechanicModel.qualification,
                style: TextStyle(
                    fontSize: 20, color: silver, fontWeight: FontWeight.bold),
              )
            ],
          )),
        ));
  }
}
