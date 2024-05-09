// ignore_for_file: file_names

import 'dart:convert';
import 'package:harmony/api_key.dart';
import 'package:harmony/widgets/buttons.dart';
import 'package:harmony/model/song.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../widgets/inputFields.dart';
import '../../widgets/videoPlayer.dart';
import '../../utils/textStyles.dart';

class RecommendationScreen extends StatefulWidget {
  static String id = "RecommendationScreen";

  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  late List<Songs> recommendations = [];
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: loader,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Theme.of(context).colorScheme.primary,
          automaticallyImplyLeading: false,
          toolbarHeight: height * 0.28,
          elevation: 0,
          flexibleSpace: Padding(
            padding: EdgeInsets.fromLTRB(20, height * 0.04, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const GoBackButton(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 5),
                ),
                Text(
                  "Music Recommendation System",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.outfit(
                    textStyle: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SearchInputField(
                  hintText: "What's going on in your life ?",
                  onSubmitted: (query) {
                    query = query?.trimLeft();
                    if (query != "") {
                      setState(() {
                        loader = true;
                      });
                      postData(query!).then((results) {
                        if (results.isNotEmpty) {
                          recommendations = [];
                          for (var result in results) {
                            setState(() {
                              loader = false;
                              recommendations.add(result);
                            });
                          }
                        } else {
                          setState(() {
                            loader = false;
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Internal Error, Server might be down")));
                          });
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),

        body: SafeArea(
          child: Container(
            // height: double.infinity,
            child: (recommendations.isEmpty)
                ? null
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: recommendations.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading:
                            Image.network(recommendations[index].thumbnailUrl),
                        subtitle: Text(
                          recommendations[index].channelTitle,
                          style: kMusicInfoStyle,
                        ),
                        title: Text(
                          recommendations[index].title,
                          style: kMusicTitleStyle,
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              recommendations.remove(recommendations[index]);
                            });
                          },
                          child: const Icon(
                            Icons.close_sharp,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                videoId: recommendations[index].id,
                                thumbnailUrl:
                                    recommendations[index].thumbnailUrl,
                                title: recommendations[index].title,
                                channelTitle:
                                    recommendations[index].channelTitle,
                              ),
                            ),
                          )
                        },
                      );
                    },
                  ),
          ),
        ),

        // floatingActionButton: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     FloatingButton(
        //       backgroundColor: Colors.green,
        //       iconData: Icons.playlist_add,
        //       padding: EdgeInsets.only(left: 32.0),
        //       heroTag: "playlist",
        //       onPressed: (){},
        //     ),
        //     FloatingButton(
        //       backgroundColor: Theme.of(context).colorScheme.primary,
        //       iconData: Icons.play_arrow,
        //       padding: EdgeInsets.only(right: 0.0),
        //       heroTag: "play",
        //       onPressed: (){},
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

Future<List<Songs>> postData(String query) async {
  try {
    var url = "https://www.googleapis.com/youtube/v3/search"
        "?part=snippet"
        "&maxResults=10"
        "&q=$query"
        "&type=video"
        "&key=$apiKey";

    var response = await http.get(Uri.parse(url));

    var decodedJson = jsonDecode(response.body);

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
