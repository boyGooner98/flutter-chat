import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_6_chat/screens/chat_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    print('inside the home screen');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = Provider.of<Auth>(context).userId;
    return StreamBuilder(
      stream: Firestore.instance.collection('$currentUserId').orderBy('lastUpdated', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data.documents;
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 2,
                child: Card(
                  elevation: 10,
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: <Widget>[
                          Text('Active Now'),
                          SizedBox(
                            height: 10,
                          ),
                          StreamBuilder(
                            stream: Firestore.instance.collection('active-users').snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final docs = snapshot.data.documents;
                              docs.removeWhere((document) {
                                if (currentUserId == document['id'] || document['isActive'] == false) {
                                  return true;
                                }
                                return false;
                              });
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.height * 0.10,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return StreamBuilder(
                                      stream: Firestore.instance.document('users/${docs[index]['id']}').snapshots(),
                                      builder: (context, snapshots) {
                                        if (snapshots.connectionState == ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        final document = snapshots.data;
                                        String name = document['userData']['name'].toString().split(" ")[0];
                                        return Row(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                CircleAvatar(
                                                    radius: 25,
                                                    child: CircleAvatar(
                                                      radius: 30,
                                                      backgroundImage: NetworkImage(document['userData']['imageUrl']),
                                                    )),
                                                Text(name),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  itemCount: docs.length,
                                ),
                              );
                            },
                          )
                        ],
                      )),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                flex: 8,
                child: Card(
                  elevation: 4,
                  child: Container(
                    child: ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) => StreamBuilder(
                        stream: Firestore.instance.document('users/${docs[index]['id']}').snapshots(),
                        builder: (context, snapshots) {
                          if (snapshots.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final docData = snapshots.data;
                          DateTime time = DateTime.parse(docs[index]['lastUpdated'].toDate().toString());
                          int days, hours, minutes;

                          hours = DateTime.now().hour - time.hour;
                          minutes = DateTime.now().minute - time.minute;
                          days = DateTime.now().day - time.day;
                          String formattedDate;
                          if (days >= 30 && days < 60) {
                            formattedDate = "it's been more than a month";
                          }
                          if (days > 60) {
                            formattedDate = "it's been more than ${days / 30} months";
                          } else if (days < 30 && days > 0) {
                            formattedDate = "last Seen $days days ago";
                          } else if (days == 0 && hours > 0) {
                            formattedDate = "last Seen $hours hours ago";
                          } else if (hours <= 0) {
                            formattedDate = "last seen $minutes minutes ago";
                          }

                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                      docData['userData']['id'],
                                      docData['userData']['name'],
                                      docData['userData']['number'],
                                      docData['userData']['imageUrl']),
                                )),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(docData['userData']['imageUrl']),
                                ),
                              ),
                              title: Text(docData['userData']['name']),
                              subtitle: Text(formattedDate),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
