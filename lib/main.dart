import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:harmony/core/api_client.dart';
import 'package:harmony/pages/OnboardingScreen.dart';
import 'package:logger/logger.dart';
import 'firebase_options.dart';

import 'package:harmony/pages/AppScreens/Dashboard.dart';
import 'package:harmony/pages/AppScreens/HomeScreen.dart';
import 'package:harmony/pages/AppScreens/RadioScreen.dart';
import 'package:harmony/pages/AppScreens/RecommendationScreen.dart';
import 'package:harmony/pages/AppScreens/SearchScreen.dart';
import 'package:harmony/pages/AuthenticationScreens/AuthenticationScreen.dart';
import 'package:harmony/pages/BottomNavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/theme.dart';

late bool isLoggedIn;
ApiClient apiClient = ApiClient();
SharedPreferences? prefs;
var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 70,
      colors: true,
      printEmojis: true,
      printTime: false),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();
  isLoggedIn = prefs?.getBool('loggedIn') ?? false;
  runApp(const Harmony());

// Example copywith in freezed
  // final video = Video();
  // video.copyWith(
  //     etag: "",
  //     items: [],
  //     kind: "",
  //     nextPageToken: "",
  //     pageInfo: PageInfo(),
  //     regionCode: "");
}

class Harmony extends StatelessWidget {
  const Harmony({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i('App started');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: (isLoggedIn) ? BottomNavbar.id : OnboardingScreen.id,
      routes: {
        OnboardingScreen.id: (context) => const OnboardingScreen(),
        AuthenticationScreen.id: (context) => const AuthenticationScreen(),
        BottomNavbar.id: (context) => BottomNavbar(),
        HomeScreen.id: (context) => const HomeScreen(),
        RecommendationScreen.id: (context) => const RecommendationScreen(),
        SearchScreen.id: (context) => SearchScreen(),
        RadioHS.id: (context) => const RadioHS(),
        Dashboard.id: (context) => Dashboard(),
      },
    );
  }
}
