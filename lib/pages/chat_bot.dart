// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:on_spot_mechanic/utils/colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _userMessage = TextEditingController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  static const apiKey = 'AIzaSyA8FHucgMMgJUxMTdqFq7m_Bxcbmb5bbgU';

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final List<Message> _messages = [];

  Future<void> sendMessage() async {
    final message = _userMessage.text;
    _userMessage.clear();
    isLoading;

    setState(() {
      _messages.add(Message(isUser: true, message: message));
      _isLoading = true;
    });

    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    setState(() {
      _messages.add(Message(isUser: false, message: response.text ?? " "));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text('MechBot',
            style: TextStyle(
                color: Color(0xFF222831), fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Messages(
                  isLoading: isLoading,
                  isUser: message.isUser,
                  message: message.message,
                  // date: DateFormat('HH:mm').format(message.date)
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 15,
                  child: TextFormField(
                    style: TextStyle(color: secondaryColor, fontSize: 18),
                    cursorColor: primaryColor,
                    controller: _userMessage,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: primaryColor)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      hintText: 'Message ChatBot...',
                    ),
                  ),
                ),
                const SizedBox(
                    width: 10), // Spacer between message box and send button
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF222831),
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.all(8),
                    iconSize: 24,
                    color: primaryColor,
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      sendMessage();
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final bool isLoading;
  // final String date;

  const Messages(
      {super.key,
      required this.isUser,
      required this.message,
      required this.isLoading
      // required this.date
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (isLoading && !isUser)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 8),
          //     child: SizedBox(
          //       width: 16,
          //       height: 16,
          //       child: CircularProgressIndicator(
          //         strokeWidth: 4,
          //         color: secondaryColor, // Adjust the thickness of the circle
          //         // Use the color animation
          //       ),
          //     ),
          //   ),
          if (isUser)
            Text(
              "YOU",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (!isUser)
            Text(
              "MECHBOT",
              style: TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          // if (isLoading)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 8),
          //     child: SizedBox(
          //       width: 16,
          //       height: 16,
          //       child: CircularProgressIndicator(
          //         strokeWidth: 4,
          //         color: secondaryColor, // Adjust the thickness of the circle
          //         // Use the color animation
          //       ),
          //     ),
          //   ),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  // final DateTime date;

  Message({
    required this.isUser,
    required this.message,
    // required this.date,
  });
}
