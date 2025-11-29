import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:journal/screens/home.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../api/auth_backend.dart';
import '../utils/colors.dart';

class user_dropdown extends StatefulWidget {
  const user_dropdown({super.key});

  @override
  State<user_dropdown> createState() => _user_dropdownState();
}

class _user_dropdownState extends State<user_dropdown> {
  final auth_backend auth = auth_backend();
  bool has_data = false;

  double height = 40;
  double width = 140;
  double br = 10;
  bool show_progress_indicator = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _fetch_users();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;
      setState(() {
        height = screenHeight * 0.05;
        width = screenWidth * 0.35;
        br = screenWidth * 0.025;
      });
      _initialized = true;
    }
  }

  _fetch_users() async {
    await auth.fetch_username();
    if (auth.js_data.isNotEmpty) {
      setState(() => has_data = true);
    }
  }

  _animate_button(bool loading) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    if (loading) {
      setState(() {
        height = screenHeight * 0.06;
        width = screenHeight * 0.06;
        br = screenHeight * 0.06;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          show_progress_indicator = true ;
        });
      });
    } else {
      // Restore animation
      setState(() {
        show_progress_indicator = false ;
        height = screenHeight * 0.05;
        width = screenWidth * 0.35;
        br = screenWidth * 0.025;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return has_data
        ? Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.06, bottom: screenHeight * 0.005),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Who is using the app ?",
              style: TextStyle(color: ColorHelper.colors[9], fontSize: screenWidth * 0.04),
            ),
          ),
        ),

        // ---------------- DROPDOWN ----------------
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorHelper.colors[9],
              border: BoxBorder.all(color: ColorHelper.colors[9]),
              borderRadius: BorderRadius.circular(screenWidth * 0.025),
            ),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: DropdownButton<String>(
                value: auth.selected_user,
                isExpanded: true,
                underline: const SizedBox(),
                hint: const Text("Please select a user"),
                onChanged: (String? newValue) {
                  setState(() {
                    auth.selected_user = newValue;
                  });
                },
                items: auth.js_data
                    .map<DropdownMenuItem<String>>((user) {
                  return DropdownMenuItem<String>(
                    value: user["name"],
                    child: Text(
                      user["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.04),

        // ---------------- SUBMIT BUTTON ----------------
        InkWell(
          onTap: () async {
            if (auth.state == true) return;

            if (auth.selected_user == null) {
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'On Snap!',
                  message: 'Please Select a user first !',
                  contentType: ContentType.failure,
                ),
              );

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);

              return;
            }

            // 1️⃣ Start loading
            setState(() => auth.state = true);
            _animate_button(true);

            // Wait for animation to finish
            await Future.delayed(const Duration(milliseconds: 300));

            // 2️⃣ Run server request
            await auth.fetch_user_details(auth.selected_user);

            // 3️⃣ Reverse animation
            setState(() => auth.state = false);
            _animate_button(false);

            // Wait for reverse animation
            await Future.delayed(const Duration(milliseconds: 300));

            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const home_page()), (route) => false);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: ColorHelper.colors[0],
              borderRadius: BorderRadius.circular(br),
            ),
            child: Center(
              child: auth.state
                  ? Padding(
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: show_progress_indicator
                  ? CircularProgressIndicator(
                  color: ColorHelper.theme_color,
                )
                    : const SizedBox()
              )
                  : Text(
                "Submit",
                maxLines: 1,
                style: TextStyle(
                  overflow: TextOverflow.fade,
                  color: ColorHelper.theme_color,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.04
                ),
              ),
            ),
          ),
        ),
      ],
    )
        : Padding(
      padding: EdgeInsets.all(screenWidth * 0.045),
      child: Shimmer(
        color: ColorHelper.colors[10],
        duration: const Duration(seconds: 1),
        interval: const Duration(seconds: 0),
        child: Container(
          height: screenHeight * 0.12,
          width: double.infinity,
          color: ColorHelper.colors[9],
        ),
      ),
    );
  }
}
