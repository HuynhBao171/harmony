// ignore_for_file: file_names, use_key_in_widget_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harmony/main.dart';
import 'package:harmony/screens/OnboardingScreen.dart';
import 'package:harmony/widgets/bluetoothDialog.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/buttons.dart';
import '../BottomNavbar.dart';

BluetoothDevice? connectedDevice;

class Dashboard extends StatefulWidget {
  static String id = "Dashboard";
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseAuth _auth = getIt<FirebaseAuth>();
  FlutterSecureStorage storage = getIt<FlutterSecureStorage>();
  String username = "User";
  String email = "";
  String photoUrl = "";
  bool loader = false;

  Future<void> getDetails() async {
    String? userDataString = await storage.read(key: 'currentUser');
    // logger.i("User Data String: $userDataString");
    if (userDataString != null) {
      // logger.i("userDataString not null");
      Map<String, dynamic> userData = jsonDecode(userDataString);
      // logger.i("UserData: $userData");
      username = userData['username'] ?? 'Error Fetching Username';
      photoUrl = userData['photoUrl'] ?? 'Error Fetching Photo URL';
    } else {
      username = 'Error Fetching Username';
      photoUrl = 'Error Fetching Photo URL';
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
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const GoBackButton(
                        padding: EdgeInsets.all(0),
                      ),
                      GestureDetector(
                        onDoubleTap: () async {
                          if (connectedDevice != null) {
                            setState(() {
                              connectedDevice!.disconnect();
                              connectedDevice = null;
                            });
                          }
                        },
                        child: Text(
                          connectedDevice?.name ?? 'No device connected',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final device = await showDialog<BluetoothDevice>(
                            context: context,
                            builder: (context) {
                              return BleScanner(
                                  connectedDevice: connectedDevice);
                            },
                          );
                          if (device != null) {
                            setState(() {
                              connectedDevice = device;
                            });
                          }
                        },
                        child: Icon(
                          connectedDevice != null
                              ? Icons.bluetooth_connected
                              : Icons.bluetooth_disabled,
                          color: connectedDevice != null
                              ? Colors.blue
                              : Colors.grey,
                          size: 42,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    FutureBuilder(
                      future: getDetails(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (photoUrl != "") {
                          return SizedBox(
                            child: Image.network(photoUrl),
                          );
                        } else {
                          return SizedBox(
                            child: Image.asset("assets/images/icon/user.png"),
                          );
                        }
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
                    Text(email,
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
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool("loggedIn", false);
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            OnboardingScreen.id,
                            ModalRoute.withName(BottomNavbar.id));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // button background color
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.black87), // button text color
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                horizontal: 60,
                                vertical: 13)), // button padding
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(fontSize: 16)), // button text style
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8))), // button shape
                      ),
                      child: Text("Sign Out",
                          style: GoogleFonts.outfit(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 28.0,
                            ),
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.3,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
