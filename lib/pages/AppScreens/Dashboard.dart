// ignore_for_file: file_names, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harmony/pages/OnboardingScreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/buttons.dart';
import '../BottomNavbar.dart';

class Dashboard extends StatefulWidget {
  static String id = "Dashboard";
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String username = "User";
  late String email;
  String photoUrl = "https://user-images.githubusercontent.com/58645688/235341154-ae99214b-c447-47e2-9c92-3f82abd7cdf9.png";
  bool loader = false;

  Future<void> getDetails() async{
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      username = user.displayName ?? username;
      photoUrl = user.photoURL ?? photoUrl;
      email = user.email ?? "Error Fetching Email";
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: loader,
        child: SafeArea(
          child: SizedBox(
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const GoBackButton(),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    FutureBuilder(
                      future: getDetails(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        return CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(photoUrl),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      username,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.outfit(
                        textStyle: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        email,
                        style: GoogleFonts.outfit(
                            textStyle: TextStyle(
                              fontSize: 13,
                              letterSpacing: 1,
                              color: Theme.of(context).colorScheme.secondary,
                    ))),
                    const SizedBox(
                      height: 50,
                    ),
                    TextButton(
                      onPressed: () async {
                        _auth.signOut();
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setBool("loggedIn", false);
                        Navigator.pushNamedAndRemoveUntil(context, OnboardingScreen.id, ModalRoute.withName(BottomNavbar.id));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // button background color
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black87), // button text color
                        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 60, vertical: 13)), // button padding
                        textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 16)), // button text style
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), // button shape
                      ),
                      child: Text(
                        "Sign Out",
                        style: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 28.0,
                          ),
                        )
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: height*0.3,
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
