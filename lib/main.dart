
import 'package:flash_chat_project/screens/chat_screen.dart';
import 'package:flash_chat_project/screens/login_screen.dart';
import 'package:flash_chat_project/screens/registration_screen.dart';
import 'package:flash_chat_project/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: WelcomeScreen.id,
    routes:{
      WelcomeScreen.id : (context) => WelcomeScreen(),
      LoginScreen.id : (context) => LoginScreen(),
      RegistrationScreen.id :  (context) => RegistrationScreen(),
      ChatScreen.id : (context) => ChatScreen()
    }

  ));
}
