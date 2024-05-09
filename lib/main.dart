import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony/core/api_client.dart';
import 'package:harmony/screens/OnboardingScreen.dart';
import 'package:logger/logger.dart';
import 'firebase_options.dart';

import 'package:harmony/screens/AppScreens/Dashboard.dart';
import 'package:harmony/screens/AppScreens/HomeScreen.dart';
import 'package:harmony/screens/AppScreens/RadioScreen.dart';
import 'package:harmony/screens/AppScreens/RecommendationScreen.dart';
import 'package:harmony/screens/AppScreens/SearchScreen.dart';
import 'package:harmony/screens/AuthenticationScreens/AuthenticationScreen.dart';
import 'package:harmony/screens/BottomNavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/theme.dart';

final getIt = GetIt.instance;

setupGetIt() async {
  getIt.registerSingleton<ApiClient>(ApiClient());
  getIt.registerSingleton<Logger>(Logger(
    printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 70,
        colors: true,
        printEmojis: true,
        printTime: false),
  ));

  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
}

final Logger logger = getIt<Logger>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupGetIt();
  runApp(const Harmony());
}

class Harmony extends StatelessWidget {
  const Harmony({super.key});

  @override
  Widget build(BuildContext context) {
    final SharedPreferences prefs = getIt<SharedPreferences>();
    bool isLoggedIn = prefs.getBool('loggedIn') ?? false;
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
