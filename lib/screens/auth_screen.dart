import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Image(
                    width: double.infinity,
                    height: double.infinity,
                    image: AssetImage('assets/images/doctor.jpg'),
                    fit: BoxFit.cover,
                  )),
              InkWell(
                splashColor: Colors.black,
                onTap: () => Navigator.of(context).pushNamed('/login'),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue[900],
                  ),
                  child: Center(
                    child: Text(
                      'Log In',
                      style: TextStyle(
                          fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'moderno-bold'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () => Navigator.of(context).pushNamed('/signup'),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.blue[900]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'moderno-bold'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
