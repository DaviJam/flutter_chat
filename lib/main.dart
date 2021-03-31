import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/loading_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  final Future<FirebaseApp> _init = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _init,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            print("Has error");
            return loading();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
                theme: ThemeData.dark().copyWith(
                  textTheme: TextTheme(
                    bodyText2: TextStyle(color: Colors.white),
                  ),
                ),
                home: WelcomeScreen(),
                initialRoute: WelcomeScreen.id,
                routes: {
                  ChatScreen.id: (context) => ChatScreen(),
                  LoginScreen.id: (context) => LoginScreen(),
                  RegistrationScreen.id: (context) => RegistrationScreen(),
                  WelcomeScreen.id: (context) => WelcomeScreen(),
                });
          }
          return loading();
        });
  }

  Widget loading() {
    return LoadingScreen();
  }
}
