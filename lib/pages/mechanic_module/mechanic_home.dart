// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:on_spot_mechanic/pages/mechanic_module/mechanic_profile.dart';
import 'package:provider/provider.dart';
import 'package:on_spot_mechanic/providers/auth_provider.dart';
import '../../providers/chat_services.dart';

import '../../utils/colors.dart';

class MechanicHomeScreen extends StatefulWidget {
  MechanicHomeScreen({super.key});

  final ChatService chatService = ChatService();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  State<MechanicHomeScreen> createState() => _MechanicHomeScreenState();
}

class _MechanicHomeScreenState extends State<MechanicHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthorizationProvider>(context, listen: false);
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
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  child: CircleAvatar(
                      backgroundColor: primaryColor,
                      backgroundImage:
                          NetworkImage(ap.mechanicModel.profilePic),
                      radius: 20),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MechanicProfilePage()),
                  ),
                ))
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              // _buildUserList(),
            ],
          ),
        ),
      ),
    );
  }
}
//   Widget _buildUserList() {
//     return StreamBuilder(
//       //  stream: widget.chatService.getUserStream(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Text("Error");
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Text("Loading");
//           }

//           return Container(
//             height: 200,
//             child: ListView(
//               children: snapshot.data!
//                   .map<Widget>(
//                       (userData) => _buildUserListItem(userData, context))
//                   .toList(),
//             ),
//           );
//         });
//   }

//   Widget _buildUserListItem(
//       Map<String, dynamic> userData, BuildContext context) {
//     if (userData["email"] != widget.auth.currentUser?.email) {
//       return UserTile(
//         text: userData["name"],
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => MechanicChatPage(
//                 userEmail: userData["email"],
//                 userID: userData["uid"],
//               ),
//             ),
//           );
//         },
//       );
//     } else {
//       return Container();
//     }
//   }
// }

// class MechanicChatPage extends StatelessWidget {
//   final String userEmail;
//   final String userID;

//   MechanicChatPage({super.key, required this.userEmail, required this.userID});

//   final TextEditingController _messageController = TextEditingController();
//   final ChatService _chatService = ChatService();
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   void sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       await _chatService.sendMessage(userID, _messageController.text);
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: tertiaryColor,
//       appBar: AppBar(
//         title: Text(userEmail),
//         backgroundColor: secondaryColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 10,
//           ),
//           Expanded(child: Text('Hai')),
//         ],
//       ),
//     );
//   }
// }
