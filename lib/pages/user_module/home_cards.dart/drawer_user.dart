// ignore_for_file: library_prefixes, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:on_spot_mechanic/providers/auth_provider.dart'
    as MyAppAuthorizationProvider;
import '../../../utils/colors.dart';
import '../../authentication_module/welcome.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<MyAppAuthorizationProvider.AuthorizationProvider>(
        context,
        listen: false);
    return SizedBox(
      width: 200,
      height: 400,
      child: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 128.0),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(),
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/logo.jpeg'),
                          fit: BoxFit
                              .cover, // Adjust this property according to your image aspect ratio
                        ),
                      ),
                      child: Container(
                        height:
                            100, // Adjust the height according to your preference
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("H O M E"),
                    leading: const Icon(Icons.home),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text("S E T T I N G S"),
                    leading: const Icon(Icons.settings),
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const SettingsPa()));
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
              child: ListTile(
                leading: GestureDetector(
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.exit_to_app,
                          color: secondaryColor,
                          size: 24,
                        ),
                        onPressed: () {
                          ap.userSignOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomePage()),
                          );
                        },
                      ),
                      Text(
                        "L O G O U T ",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
