// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/authentication_module/welcome.dart';
import 'package:on_spot_mechanic/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthorizationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomePage(),
        title: "FlutterPhoneAuth",
      ),
    );
  }
}

// class CheckUserLoggedIn extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final AuthorizationProvider = Provider.of<AuthorizationProvider>(context);
//     return AuthorizationProvider.isSignedIn ? UserHomeScreen() : WelcomePage();
//   }
// }
