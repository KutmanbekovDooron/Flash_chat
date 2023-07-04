import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_project/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User? loggetInUser;
class ChatScreen extends StatefulWidget {
  static const String id = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextControler = TextEditingController();
  final _auth = FirebaseAuth.instance;
  var messageText;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggetInUser = user;
        print(loggetInUser?.email);
      }
    } catch (e) {
      print(" $e  hello ");
    }
  }

  void messagesStream() async {
    print('hello');
    await for (var messag in _firestore.collection('messages').snapshots()) {
      for (var message in messag.docs) {
        print("${message.data()}");
      }
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
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
                messagesStream();
                // _auth.signOut();
                // Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("messages").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text("wiat"),
                  );
                }
                final messages = snapshot.data!.docs;
                List<MessegeDubble> meassegesDubbles = [];
                for (var message in messages) {
                  final meassegeText = message.get("text");
                  final meassegeSender = message.get("sender");

                  final currentUser = loggetInUser?.email;

                  final messageDubble = MessegeDubble(sender: meassegeSender, text: meassegeText,isMe: currentUser == meassegeSender,);

                  meassegesDubbles.add(messageDubble);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                    children: meassegesDubbles,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextControler,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextControler.clear();
                      _firestore.collection("messages").add(
                          {"text": messageText, 'sender': loggetInUser?.email});
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

class MessegeDubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  MessegeDubble({required this.sender, required this.text,required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          Text(sender,style: TextStyle(fontSize: 12,color: Colors.black54),),
          Material(
            borderRadius: BorderRadius.only(topRight: Radius.circular(isMe?0:30),topLeft: Radius.circular(isMe?30:0),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
            elevation: 5,
            color: isMe? Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Text("$text",
                style: TextStyle(color:isMe?Colors.white:Colors.black54,fontSize: 15),),
            ),
          ),
        ],
      ),
    );
  }
}

