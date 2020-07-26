import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/users_screen.dart';

class TabsNavigator extends StatefulWidget {
  @override
  _TabsNavigatorState createState() => _TabsNavigatorState();
}

class _TabsNavigatorState extends State<TabsNavigator> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: 'Chats',
                    icon: Icon(Icons.chat,), 
                  ),
                  Tab(
                    text: 'Users',
                    icon: Icon(Icons.people),
                  ),
                  Tab(
                    text: 'Profile',
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              HomeScreen(),
              UsersScreen(),
              ProfileScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
