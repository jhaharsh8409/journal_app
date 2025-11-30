import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:journal/api/global_data.dart';
import 'package:journal/screens/auth_login.dart';
import 'package:journal/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';


class splash_screen extends StatelessWidget {
  const splash_screen({super.key});
  @override
  build(BuildContext context) {
    _navigate() async{
      final SharedPreferences prefs =  await SharedPreferences.getInstance();
      bool logged = await prefs.getBool('logged') ??false;
      global_data.username = prefs.getString('selected_user');
      global_data.userId = prefs.getString('selected_user_id');

      await Future.delayed(Duration(seconds: 2)).then(
        (value) => logged
            ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home_page()))
            : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => auth_login()))
      );
    }

    _navigate();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Center(
                child: Image.asset("assets/icon/icon.png", height: 200, width: 200),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
