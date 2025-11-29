import 'package:flutter/material.dart';
import 'package:journal/components/user_dropdown.dart';
import 'package:journal/utils/colors.dart';
import 'package:journal/utils/icons.dart';
import 'package:lottie/lottie.dart';

class auth_login extends StatelessWidget {
  const auth_login({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: Lottie.asset('lib/assets/Welcome.json', height: screenHeight * 0.4),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  child: Row(
                    children: [
                      Icon(IconHelper.icons[0], color: ColorHelper.colors[9], size: screenWidth * 0.08,),
                      SizedBox(width: screenWidth * 0.03),
                      Text("Welcome Back",style: TextStyle(fontSize: screenWidth * 0.06,color: ColorHelper.text_color),)
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                ),

                user_dropdown()
              ],
            ),
          ),
        )
      );
  }
}
