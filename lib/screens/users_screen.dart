import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/chat_screen.dart';
import '../providers/auth_provider.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (ctx, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = snapshots.data.documents;
          final String currentUserId = Provider.of<Auth>(context).userId;
          List<DocumentSnapshot> users = [];
          for (int i = 0; i < docs.length; i++) {
            if (currentUserId == docs[i]['userData']['id']) continue;
            users.add(docs[i]);
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                users[index]['userData']['id'],
                                users[index]['userData']['name'],
                                users[index]['userData']['number'],
                                users[index]['userData']['imageUrl']),
                          ));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0xffFDCF09),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(docs[index]['userData']['imageUrl']),
                        ),
                      ),
                      title: Text('${users[index]['userData']['name']}'),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  )
                ],
              );
            },
            itemCount: users.length,
          );
        },
      ),
    );
  }
}
