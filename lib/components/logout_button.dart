
import 'package:flutter/material.dart';
import 'package:journal/screens/auth_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/colors.dart';
import '../utils/icons.dart';

class logout_button extends StatelessWidget {
  const logout_button({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()async{
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('logged');
        prefs.remove('selected_user');
        prefs.remove('selected_user_id');
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => auth_login()), (route) => false);

      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: ColorHelper.colors[9]),
                bottom: BorderSide(color: ColorHelper.colors[9])
            )
        ),
        child: Row(
          children: [
            Icon(IconHelper.icons[7],color: ColorHelper.colors[1],),
            SizedBox(width: 10,),
            Text("Logout")
          ],
        ),
      ),
    );
  }
}
