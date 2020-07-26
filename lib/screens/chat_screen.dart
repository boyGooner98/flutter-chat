import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/display_message.dart';

class ChatScreen extends StatefulWidget {
  final String id;
  final String name;
  final String number;
  final String url;

  ChatScreen(this.id, this.name, this.number, this.url);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String user;
  var textController = TextEditingController();
  Stream<QuerySnapshot> data;
  List<String> userMessages = [];
  Future<void> addMessage() async {
    await Firestore.instance
        .collection('users/$user/${widget.id}')
        .add({'message': textController.text, 'createdAt': Timestamp.now(), 'userId': user});
    textController.clear();
    await Firestore.instance.document('$user/${widget.id}').setData({'id': widget.id, 'lastUpdated': Timestamp.now()});
  }
  @override
  Widget build(BuildContext context) {
    user = Provider.of<Auth>(context).userId;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              decoration:
                  BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black.withOpacity(0.2)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        CircleAvatar(
                          radius: 20,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(widget.url),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(widget.name),
                      ],
                    ),
                  ),
                  Icon(Icons.info),
                ],
              ),
            ),
            Expanded(
                flex: 5,
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('users/$user/${widget.id}')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return StreamBuilder(
                      stream: Firestore.instance
                          .collection('users/${widget.id}/$user')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshots) {
                        if (snapshots.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final documents = snapshot.data.documents;
                        final secondUsersDocs = snapshots.data.documents;
                        List<DocumentSnapshot> list = [];
                        for (int i = 0; i < documents.length; i++) list.add(documents[i]);
                        for (int i = 0; i < secondUsersDocs.length; i++) list.add(secondUsersDocs[i]);
                        list.sort((a, b) {
                          Timestamp timeStamp1 = a['createdAt'];
                          Timestamp timestamp2 = b['createdAt'];
                          return timestamp2.seconds.compareTo(timeStamp1.seconds);
                        });
                        return ListView.builder(
                          reverse: true,
                          itemBuilder: (context, index) {
                            return DisplayMessage(list[index]['userId'], list[index]['message']);
                          },
                          itemCount: list.length,
                        );
                      },
                    );
                  },
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black.withOpacity(0.06))),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.image,
                        size: 30,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey[200]),
                          child: TextField(
                            controller: textController,
                            style: TextStyle(fontSize: 15, fontFamily: 'moderno-medium'),
                            cursorColor: Colors.blue,
                            cursorWidth: 2,
                            decoration: InputDecoration(
                                hintText: 'Aa', border: InputBorder.none, contentPadding: const EdgeInsets.all(5)),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: addMessage,
                      )
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
