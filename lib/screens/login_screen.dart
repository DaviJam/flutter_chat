import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool emptyPassword = false;
  bool wrongPassword = false;
  bool _showLoading = false;

  Future signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: this.email, password: this.password);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                obscureText: true,
                style: TextStyle(color: Colors.black),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                  errorText: (emptyPassword == true)
                      ? "Enter a valid password"
                      : (wrongPassword == true)
                          ? "Wrong password"
                          : null,
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              CustomButton(
                text: 'Log In',
                onPressed: () async {
                  setState(() {
                    _showLoading = true;
                  });

                  try {
                    setState(() {
                      if (password == null || password.isEmpty) {
                        emptyPassword = true;
                        print(kRED("is empty"));
                      } else {
                        emptyPassword = false;
                        wrongPassword = false;
                      }
                    });
                    final newUser = await signIn(email, password);
                    if (newUser != null) {
                      setState(() {
                        wrongPassword = false;
                      });
                      setState(() {
                        _showLoading = false;
                      });
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } catch (e) {
                    print(kRED(e.toString()));
                    if (e.code.toString() == 'wrong-password') {
                      print(kRED("Wrong password"));
                      setState(() {
                        wrongPassword = true;
                      });
                    }
                  }
                  print(kBLU(email));
                  print(kYEL(password));
                },
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
