// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:harmony/api_key.dart';
import 'package:harmony/constants/widgetExtensions.dart';
import 'package:harmony/main.dart';
import 'package:harmony/model/song.dart';
import 'package:harmony/pages/AppScreens/Dashboard.dart';
import 'package:harmony/pages/AppScreens/PlaylistScreen.dart';
import 'package:harmony/pages/AppScreens/RecommendationScreen.dart';
import 'package:harmony/model/API-Model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../components/playlistCard.dart';
import '../../constants/textStyles.dart';
import '../../components/inputFields.dart';
import '../BottomNavbar.dart';

class HomeScreen extends StatefulWidget {
  static String id = "HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController myController = TextEditingController();
  bool isactive1 = true;
  bool isactive2 = false;
  String username = "User";
  String photoUrl = "";
  bool loader = false;

  Future<void> getDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var name = user.displayName ?? username;
      int index = name.indexOf(" ");
      if (index != -1) name = name.substring(0, name.indexOf(" "));
      username = name;
      photoUrl = user.photoURL ?? photoUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: loader,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                    // color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FutureBuilder(
                              future: getDetails(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                return Text(
                                  "Hello $username",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.outfit(
                                    textStyle: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text("Let's Play Some Music !",
                                style: GoogleFonts.outfit(
                                    textStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ))),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Dashboard.id);
                              },
                              child: FutureBuilder(
                                future: getDetails(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  String photoUrl = snapshot.data ?? "";
                                  if (photoUrl != "") {
                                    return SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: Image.network(photoUrl),
                                    );
                                  } else {
                                    return SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: Image.asset(
                                          "assets/images/icon/user.png"),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SearchInputField(
                    myController: myController,
                    hintText: "What do you want to listen to?",
                    onSubmitted: (query) {
                      query = query?.trimLeft();
                      if (query != "") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavbar(
                              searchQuery: query,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RecommendationScreen.id);
                    },
                    child: Container(
                      height: 120,
                      width: width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color:
                              Colors.white, // set the border color with opacity
                          width: 1.0, // set the border width
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Visibility(
                            // maintainSize: true,
                            // maintainAnimation: true,
                            // maintainState: true,
                            visible: false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.more_horiz,
                                  size: 30,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Get recommendations based on your mood",
                                  style: GoogleFonts.outfit(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Tell us how are you feeling?",
                                  style: GoogleFonts.outfit(
                                    textStyle: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ),
                                const Visibility(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.navigate_next,
                                        size: 30,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).padding(8),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Daily Mix",
                    style: kPlaylistTileStyle,
                  ),
                  SizedBox(
                    height: 200,
                    width: width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: dailyMix.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            setState(() {
                              loader = true;
                            });
                            List<Songs> list =
                                await playlistsData(dailyMix[index].title);
                            setState(() {
                              loader = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlaylistScreen(
                                  title: dailyMix[index].title,
                                  songs: list,
                                ),
                              ),
                            );
                          },
                          child: PlaylistCard(
                            imageUrl: dailyMix[index].iconUrl,
                            text: dailyMix[index].title,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "All Time Best",
                    style: kPlaylistTileStyle,
                  ),
                  SizedBox(
                    height: 200,
                    width: width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: albums.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            setState(() {
                              loader = true;
                            });
                            List<Songs> list =
                                await playlistsData(albums[index].title);
                            setState(() {
                              loader = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlaylistScreen(
                                  title: albums[index].title,
                                  songs: list,
                                ),
                              ),
                            );
                          },
                          child: PlaylistCard(
                            imageUrl: albums[index].iconUrl,
                            text: albums[index].title,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<Songs>> playlistsData(String query) async {
  try {
    var url = "https://www.googleapis.com/youtube/v3/search"
        "?part=snippet"
        "&maxResults=10"
        "&q=$query"
        "&type=video"
        "&key=$apiKey";

    var response = await http.get(Uri.parse(url));

    decodedJson = jsonDecode(response.body);

    List<Songs> songs = (decodedJson['items'] as List).map((item) {
      return Songs.fromJsonString(jsonEncode(item));
    }).toList();

    print('Songs: $songs');

    return songs;
  } catch (e) {
    print('Error: $e');
    return [];
  }
}
