// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:harmony/core/api_client.dart';
import 'package:harmony/main.dart';
import 'package:harmony/screens/AppScreens/SearchScreen.dart';
import 'package:harmony/screens/AssistantScreens/assistant_page.dart';

import 'AppScreens/HomeScreen.dart';
import 'AppScreens/RadioScreen.dart';

// ignore: must_be_immutable
class BottomNavbar extends StatefulWidget {
  static String id = "BottomNavbar";

  late String? searchQuery;
  BottomNavbar({
    super.key,
    this.searchQuery,
  });
  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final PageController controller = PageController();
  int pageIndex = 0;
  final ApiClient apiClient = getIt<ApiClient>();
  // ignore: prefer_typing_uninitialized_variables
  late var screens;

  void setScreens(String? value) {
    screens = [
      const HomeScreen(),
      SearchScreen(
        searchQuery: value,
      ),
      const RadioHS(),
      const AssistantPage(),
    ];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await apiClient.getDetailsUser();
    });
    setScreens(widget.searchQuery);
    if (widget.searchQuery != null) {
      pageIndex = 1;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[pageIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // color: Colors.black,

          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: const Color(0xffB80454),
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              // tabBackgroundColor: Colors.grey[800]!,
              tabBackgroundColor: const Color(0xffB80454).withOpacity(0.15),
              color: Colors.white,
              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Search',
                ),
                GButton(
                  icon: Icons.radio_outlined,
                  text: 'Radio',
                ),
                GButton(
                  icon: Icons.chat_outlined,
                  text: 'Assistant',
                ),
              ],
              selectedIndex: pageIndex,
              onTabChange: (index) {
                setState(() {
                  pageIndex = index;
                  widget.searchQuery = null;
                  setScreens(null);
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
