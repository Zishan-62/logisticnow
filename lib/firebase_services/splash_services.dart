import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logisticsnow_assignment/ui/auth/login_screen.dart';
import 'package:logisticsnow_assignment/ui/homepage.dart';



class SplashServices{

  void isLogin(BuildContext context){

    final auth = FirebaseAuth.instance;

    final user =  auth.currentUser ;

    if(user != null){
      Timer(const Duration(seconds: 3),
              ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()
              ))
      );
    }else {
      Timer(const Duration(seconds: 3),
              ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()))
      );
    }


  }
}