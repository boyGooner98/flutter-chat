import 'package:flutter/material.dart';
import 'package:flutter_6_chat/widgets/tabs_navigator.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:loading/loading.dart';

//TODAY IS DAY 1 OF BUILDING A CHAT APP

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var _codeController = TextEditingController();
  var nameController = TextEditingController();

  bool loading = false;
  Future<void> saveFormUsingEmailPassword(BuildContext context) async {
    setState(() {
      loading = true;
    });
    await Provider.of<Auth>(context, listen: false)
        .registerUser(emailController.text, passwordController.text, nameController.text);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => TabsNavigator(),
      ),
      (route) => false,
    );
  }

  // Future _saveForm(BuildContext context) async {
  //   FirebaseAuth _auth = FirebaseAuth.instance;
  //   _auth.verifyPhoneNumber(
  //     phoneNumber: numberController.text,
  //     timeout: Duration(seconds: 60),
  //     verificationCompleted: (AuthCredential phoneAuthCredential) async {
  //       setState(() {
  //         loading = true;
  //       });
  //       AuthResult result = await _auth.signInWithCredential(phoneAuthCredential);
  //       setState(() {
  //         loading = false;
  //       });
  //       if (result.user != null) {
  //         await Firestore.instance.document('users/${result.user.uid}').setData({
  //           'userData': {
  //             'id': result.user.uid,
  //             'name': passwordController.text,
  //             'number': result.user.phoneNumber,
  //             'imageUrl':
  //                 'https://images.pexels.com/photos/2228586/pexels-photo-2228586.jpeg?cs=srgb&dl=woman-holding-white-book-2228586.jpg&fm=jpg',
  //           },
  //         });
  //         Provider.of<Auth>(context, listen: false).setValues(result.user.uid, result.user.phoneNumber);
  //         Navigator.of(context).pushAndRemoveUntil(
  //             MaterialPageRoute(
  //               builder: (context) => TabsNavigator(),
  //             ),
  //             (route) => false);
  //       } else {
  //         Scaffold.of(context).showSnackBar(SnackBar(
  //           content: Text('something went wrong'),
  //         ));
  //       }
  //     },
  //     verificationFailed: (AuthException authException) {
  //       print(authException.message);
  //     },
  //     codeSent: (String verificationId, [int forceResendingToken]) async {
  //       showDialog(
  //           context: context,
  //           barrierDismissible: false,
  //           builder: (context) => AlertDialog(
  //                 title: Text("Enter SMS Code"),
  //                 content: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: <Widget>[
  //                     TextField(
  //                       controller: _codeController,
  //                     ),
  //                   ],
  //                 ),
  //                 actions: <Widget>[
  //                   FlatButton(
  //                     child: Text("Done"),
  //                     textColor: Colors.white,
  //                     color: Colors.redAccent,
  //                     onPressed: () async {
  //                       final smsCode = _codeController.text.trim();
  //                       AuthCredential _credential =
  //                           PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);
  //                       setState(() {
  //                         loading = true;
  //                       });
  //                       AuthResult result = await _auth.signInWithCredential(_credential);
  //                       setState(() {
  //                         loading = false;
  //                       });
  //                       if (result.user != null) {
  //                         await Firestore.instance.document('users/${result.user.uid}').setData({
  //                           'userData': {
  //                             'id': result.user.uid,
  //                             'name': passwordController.text,
  //                             'number': result.user.phoneNumber,
  //                             'imageUrl':
  //                                 'https://images.pexels.com/photos/2228586/pexels-photo-2228586.jpeg?cs=srgb&dl=woman-holding-white-book-2228586.jpg&fm=jpg'
  //                           },
  //                         });
  //                         Provider.of<Auth>(context, listen: false).setValues(result.user.uid, result.user.phoneNumber);
  //                         Navigator.of(context).pushAndRemoveUntil(
  //                             MaterialPageRoute(
  //                               builder: (context) => TabsNavigator(),
  //                             ),
  //                             (route) => false);
  //                       } else {
  //                         Scaffold.of(context).showSnackBar(SnackBar(
  //                           content: Text('something went wrong'),
  //                         ));
  //                       }
  //                     },
  //                   )
  //                 ],
  //               ));
  //     },
  //     codeAutoRetrievalTimeout: null,
  //   );
  // }

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
                        style: TextStyle(color: Colors.orange),
                        decoration: InputDecoration(
                            hintText: 'Enter your Full Name',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                            icon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            border: InputBorder.none),
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(emailFocusNode);
                        },
                        controller: nameController,
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
                        cursorColor: Colors.white,
                        focusNode: emailFocusNode,
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
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
                        },
                        controller: passwordController,
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
                        focusNode: confirmPasswordFocusNode,
                        decoration: InputDecoration(
                            hintText: 'Re-Enter your Password',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                            icon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            border: InputBorder.none),
                        controller: confirmPasswordController,
                        textInputAction: TextInputAction.done,
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
                          onTap: () => saveFormUsingEmailPassword(context),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.06,
                            child: Center(
                              child: Text(
                                'Register',
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
