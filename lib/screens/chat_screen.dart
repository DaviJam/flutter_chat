import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String messageText = "";
  final messageTextController = TextEditingController();
  DateFormat dateFormat;
  DateTime time;
  Timer timer;

  @override
  void initState() {
    super.initState();
    loggedInUser = this.getCurrentUser();
    time = DateTime.now();
    initializeDateFormatting('fr', null);
    dateFormat = DateFormat.yMMMEd("fr");
  }

  User getCurrentUser() {
    User _user;
    try {
      final w_user = _auth.currentUser;
      if (w_user != null) {
        _user = w_user;
      }
    } catch (e) {
      print(e);
    }
    return _user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat      ${dateFormat.format(time)}'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _firestore.collection('messages').add({
                        'timestamp': FieldValue.serverTimestamp(),
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                      messageTextController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final scroller = ScrollController(initialScrollOffset: 50);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        List<MessageBubble> messageWidgets = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs;
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];
          final messageTime = message.data()['timestamp'];

          final currentUser = loggedInUser.email;

          final messageWidget = MessageBubble(
            text: messageText,
            sender: messageSender,
            timestamp: messageTime,
            isMe: currentUser == messageSender,
          );
          messageWidgets.add(messageWidget);
        }
        // set a callback to be called after build is finished
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scroller.hasClients) {
            scroller.animateTo(scroller.position.maxScrollExtent,
                duration: Duration(microseconds: 300), curve: Curves.easeOut);
          }
        });

        return Flexible(
          child: ListView(
            controller: scroller,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.timestamp, this.isMe});
  final String text;
  final String sender;
  final Timestamp timestamp;
  final bool isMe;

  String getText() {
    String ret = "";
    if (text != null && sender != null && timestamp != null && isMe != null) {
      ret =
          '$sender at ${timestamp.toDate().toLocal().hour.toString()}:${timestamp.toDate().toLocal().minute.toString()}';
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            (isMe) ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            getText(),
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white38,
            ),
          ),
          Bubble(text: text, isSender: isMe),
        ],
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  const Bubble({@required this.text, this.isSender = true});

  final String text;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.only(
          topLeft: (isSender != true) ? Radius.circular(15.0) : Radius.zero,
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
          topRight: (isSender != true) ? Radius.zero : Radius.circular(15.0)),
      elevation: 5.0,
      shadowColor: (isSender == true) ? Colors.white54 : Colors.lightBlue[50],
      color: (isSender == true) ? Colors.white : Colors.lightBlueAccent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Text(
          '$text',
          style: TextStyle(
            fontSize: 20,
            color: (isSender == true) ? Colors.black54 : Colors.white,
          ),
        ),
      ),
    );
  }
}
