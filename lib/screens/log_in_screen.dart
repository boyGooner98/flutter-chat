import 'package:flutter/material.dart';
import 'package:flutter_6_chat/widgets/tabs_navigator.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:loading/loading.dart';

//TODAY IS DAY 1 OF BUILDING A CHAT APP

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final passwordFocusNode = FocusNode();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool loading = false;
  Future<void> logInUsingEmailPassword(BuildContext context) async {
    setState(() {
      loading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).loginUser(emailController.text, passwordController.text);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => TabsNavigator(),
        ),
        (route) => false,
      );
    } catch (err) {
      setState(() {
        loading = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Form(
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontFamily: 'moderno-bold', fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration:
                        BoxDecoration(color: Colors.blue[200].withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: TextFormField(
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.orange),
                        decoration: InputDecoration(
                            hintText: 'Enter your Email',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                            icon: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                            border: InputBorder.none),
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(passwordFocusNode);
                        },
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration:
                        BoxDecoration(color: Colors.blue[200].withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: TextFormField(
                        style: TextStyle(color: Colors.orange),
                        focusNode: passwordFocusNode,
                        decoration: InputDecoration(
                            hintText: 'Enter your password',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                            icon: Icon(
                              Icons.lock_outline,
                              color: Colors.white,
                            ),
                            border: InputBorder.none),
                        controller: passwordController,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  loading
                      ? Center(
                          child: Loading(
                          indicator: BallPulseIndicator(),
                          color: Colors.green,
                          size: 50,
                        ))
                      : InkWell(
                          onTap: () => logInUsingEmailPassword(context),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.06,
                            child: Center(
                              child: Text(
                                'Enter',
                                style: TextStyle(fontFamily: 'moderno-bold', fontSize: 20),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: Center(
                        child: Text(
                          'Log In Using OTP',
                          style: TextStyle(fontFamily: 'moderno-bold', fontSize: 20),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
