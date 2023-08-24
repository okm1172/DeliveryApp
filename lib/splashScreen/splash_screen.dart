import 'dart:async';

import 'package:flutter/material.dart';

import '../assist/assist_methods.dart';
import '../global/global.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer() {
    Timer(Duration(seconds: 3),() async {
      if(await firebaseAuth.currentUser != null){
        //현재 user가 있는 상태라면, user의 정보들을 알아내는 부분
        firebaseAuth.currentUser != null ? AssistMethods.readCurrentOnlineUserInfo() : null;
        Navigator.push(context,MaterialPageRoute(builder: (c) => LoginScreen()));
      }
      else{
        Navigator.push(context,MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    },);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Trip',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        )
      )
    );
  }
}
