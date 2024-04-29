//import 'dart:html';

//import 'dart:ffi';

//import 'package:chat_app_3/models/message.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChatService();

  Stream<List<Map<String, dynamic>>> getMechanicsStream(selectedService) {
    return _firestore
        .collection("mechanic")
        .where(selectedService, isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getUserStream(String userID) {
    return _firestore
        .collection("chat_rooms")
        .snapshots()
        .asyncMap((chatRoomsSnapshot) async {
      List<Map<String, dynamic>> userList = [];

      for (var chatRoomDoc in chatRoomsSnapshot.docs) {
        var messagesSnapshot = await chatRoomDoc.reference
            .collection("messages")
            .where("receiverID", isEqualTo: userID)
            .get();

        for (var messageDoc in messagesSnapshot.docs) {
          var senderID = messageDoc["senderID"];
          var userDataSnapshot =
              await _firestore.collection("user").doc(senderID).get();

          var userData = userDataSnapshot.data();
          if (userData != null) {
            userList.add(userData);
          }
        }
      }

      return userList;
    });
  }

  Future<void> sendMessage(String receiverID, String message) async {
    final User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      final String currentUserID = currentUser.phoneNumber ?? '';
      final String currentUserEmail = currentUser.email!;
      final Timestamp timestamp = Timestamp.now();

      Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp,
      );

      List<String> ids = [currentUserID, receiverID];
      ids.sort();
      String chatRoomID = ids.join('_');

      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .add(newMessage.toMap());
    } else {
      // Handle the case when the current user is null
      print("Error: Current user is null");
      // You can also show an error message to the user or take appropriate action
    }
  }

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
