import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import './screens/auth_screen.dart';
import './providers/auth_provider.dart';
import './screens/log_in_screen.dart';
import './screens/sign_up_screen.dart';
import './widgets/tabs_navigator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String user;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final prefData = json.decode(prefs.getString('userData')) as Map<String, Object>;
      user = prefData['userId'];
    }
    print(state);
    if (state == AppLifecycleState.resumed) {
      await Firestore.instance
          .document('active-users/$user')
          .setData({'id': user, 'lastActiveTime': Timestamp.now(), 'isActive': true});
    }
    if (state == AppLifecycleState.paused) {
      await Firestore.instance
          .document('active-users/$user')
          .setData({'id': user, 'lastActiveTime': Timestamp.now(), 'isActive': false});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          theme: ThemeData(
            accentColor: Colors.white,
            primaryColor: Colors.teal,
          ),
          title: 'Flutter Demo',
          home: AuthScreen(),
          routes: {
            '/tabs': (ctx) => TabsNavigator(),
            '/login': (ctx) => LogInScreen(),
            '/signup': (ctx) => SignUpScreen(),
          },
        ),
      ),
    );
  }
}
