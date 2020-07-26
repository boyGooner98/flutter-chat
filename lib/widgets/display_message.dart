import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class DisplayMessage extends StatelessWidget {
  final String userId;
  final String message;
  final List<Color> userColorList = [Colors.green, Colors.blue[600]];
  final List<Color> secondUserColorList = [Colors.pink, Colors.grey];
  DisplayMessage(this.userId, this.message);
  @override
  Widget build(BuildContext context) {
    final String currentUserId = Provider.of<Auth>(context).userId;
    final random = new Random();
    int colorIndex = random.nextInt(userColorList.length);
    return Wrap(
      direction: Axis.horizontal,
      alignment: currentUserId == userId ? WrapAlignment.end : WrapAlignment.start,
      children: <Widget>[
        currentUserId == userId
            ? Container(
                margin: const EdgeInsets.all(15),
                child: Material(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  color: userColorList[colorIndex],
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      message,
                      style: TextStyle(color: Colors.white,fontSize: 15),
                      maxLines: 10,
                    ),
                  ),
                ),
              )
            : Container(
                margin: const EdgeInsets.all(15),
                child: Material(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: secondUserColorList[colorIndex],
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      message,
                      style: TextStyle(color: Colors.white,fontSize: 15),
                      maxLines: 10,
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
