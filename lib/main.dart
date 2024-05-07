import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:harmony/model/pageinfo/pageinfo.dart';
import 'package:harmony/model/video/video.dart';
import 'package:harmony/pages/OnboardingScreen.dart';
import 'firebase_options.dart';

import 'package:harmony/pages/AppScreens/Dashboard.dart';
import 'package:harmony/pages/AppScreens/HomeScreen.dart';
import 'package:harmony/pages/AppScreens/RadioScreen.dart';
import 'package:harmony/pages/AppScreens/RecommendationScreen.dart';
import 'package:harmony/pages/AppScreens/SearchScreen.dart';
import 'package:harmony/pages/AuthenticationScreens/AuthenticationScreen.dart';
import 'package:harmony/pages/BottomNavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/theme.dart';

late bool isLoggedIn;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isLoggedIn = prefs.getBool('loggedIn') ?? false;
  runApp(const Harmony());

// Example copywith in freezed
  final video = Video();
  video.copyWith(
      etag: "",
      items: [],
      kind: "",
      nextPageToken: "",
      pageInfo: PageInfo(),
      regionCode: "");
}

class Harmony extends StatelessWidget {
  const Harmony({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // initialRoute: OnboardingScreen.id,
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
