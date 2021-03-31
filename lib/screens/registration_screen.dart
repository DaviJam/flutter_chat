import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool _showSpinner = false;
  String email;
  String password;
  bool emptyPassword = false;

  Future addNewUser(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                textAlign: TextAlign.center,
                obscureText: true,
                style: TextStyle(color: Colors.black),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                  errorText:
                      (emptyPassword == true) ? "Enter a valid password" : null,
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              CustomButton(
                text: 'Register',
                onPressed: () async {
                  setState(() {
                    _showSpinner = true;
                  });
                  try {
                    final newUser = await addNewUser(email, password);
                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                      _showSpinner = false;
                    }
                  } catch (e) {
                    print(e);
                  }
                  setState(() {
                    (password == null)
                        ? emptyPassword = true
                        : emptyPassword = false;
                  });
                  print(email);
                  print(password);
                },
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
