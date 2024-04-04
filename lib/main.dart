// ignore_for_file: prefer_const_constructors, library_prefixes
//ed:3a:9b:46:d2:90:06:9c:96:50:32:51:cd:07:3a:dc:4f:15:e0:e5

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/welcome.dart';
import 'package:on_spot_mechanic/authentication/auth_provider.dart'
    as MyAppAuthProvider;

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures that Flutter has been initialized before initializing Firebase.

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyAppAuthProvider.AuthProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomePage(),
        title: "FlutterPhoneAuth",
      ),
    );
  }
}
