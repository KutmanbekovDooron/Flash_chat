import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat_project/components/rounded_button.dart';
import 'package:firebase_core/firebase_core.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = '/';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    Firebase.initializeApp();
    controller = AnimationController(vsync: this,duration: Duration(seconds: 3));

    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    animation = ColorTween(begin: Colors.red, end: Colors.blue).animate(controller);

    controller.reverse(from: 1);


    animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        controller.reverse(from: 1);
      }else if(status == AnimationStatus.dismissed){
        controller.forward();
      }
      print(status);
    });
    controller.addListener(() {
      setState(() {
        animation.value;
      });
    });

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts : [
                    TypewriterAnimatedText('Flash Chat',textStyle: TextStyle(
                      fontSize: 45.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                      speed: Duration(milliseconds: 500)
                    )
                  ],
                  // pause: Duration(seconds: 1),

                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(Colors.lightBlueAccent,(){
              Navigator.pushNamed(context, LoginScreen.id);},'Log In'),
            RoundedButton(Colors.blueAccent, () { Navigator.pushNamed(context, RegistrationScreen.id);},'Register')
          ],
        ),
      ),
    );
  }
}


