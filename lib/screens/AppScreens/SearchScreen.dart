// ignore_for_file: must_be_immutable, file_names

import 'dart:convert';
import 'package:harmony/core/api_client.dart';
import 'package:harmony/main.dart';
import 'package:harmony/model/song.dart';
import 'package:harmony/utils/extensions/dartExtensions.dart';
import 'package:harmony/utils/network_utils.dart';
import 'package:harmony/utils/textStyles.dart';
import 'package:harmony/widgets/inputFields.dart';
import 'package:harmony/widgets/videoPlayer.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  static String id = "SearchScreen";

  String? searchQuery;
  SearchScreen({
    super.key,
    this.searchQuery,
  });
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController myController = TextEditingController();
  final ApiClient apiClient = getIt<ApiClient>();
  final SharedPreferences prefs = getIt<SharedPreferences>();
  bool showResults = false;
  bool fromHome = false;
  List<Songs> recentSearches = [];
  List<Songs> searchResults = [];

  @override
  void initState() {
    super.initState();
    getRecentSearches();
    if (widget.searchQuery != null) {
      searchYoutube(widget.searchQuery!);
      setState(() {
        myController.text = widget.searchQuery!;
        showResults = true;
        fromHome = true;
      });
    }
  }

  @override
  void dispose() async {
    saveRecentSearches();
    super.dispose();
  }

  Future<void> saveSearchResults(List<Songs> results) async {
    List<String> data = [];
    for (var result in results) {
      data.add(jsonEncode(result.toJson()));
    }
    prefs.setStringList('searchResults', data);
  }

  Future<List<Songs>> getSearchResults() async {
    List<String> data = prefs.getStringList('searchResults') ?? [];
    List<Songs> results = [];
    for (var item in data) {
      results.add(Songs.fromJson(jsonDecode(item)));
    }
    return results;
  }

  Future<void> saveRecentSearches() async {
    List<String> data = [];
    for (var search in recentSearches) {
      data.add(jsonEncode(search));
    }
    prefs.setStringList('recentSearches', data);
  }

  Future<void> getRecentSearches() async {
    List<String>? searches = prefs.getStringList('recentSearches');
    if (searches != null) {
      for (String search in searches) {
        // print(search);
        var json = jsonDecode(search);
        setState(() {
          recentSearches.add(Songs.fromJson(json));
        });
      }
    }
  }

  void searchYoutube(String query) async {
    logger.i('Searching for $query');
    if (await NetworkUtils.isConnected()) {
      logger.i('Connected to the internet');
      List<Songs> results = await apiClient.searchYoutube(query);
      saveSearchResults(results);
      setState(() {
        searchResults = results;
      });
    } else {
      logger.i('Not connected to the internet');
      List<Songs> results = await getSearchResults();
      setState(() {
        searchResults = results;
      });
    }
    // List<Songs> results = await apiClient.searchYoutube(query);
    //   saveSearchResults(results);
    //   setState(() {
    //     searchResults = results;
    //   });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: height * 0.18,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: height * 0.025,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (showResults)
                    MaterialButton(
                      shape: const CircleBorder(),
                      color: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.all(15.0),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                      onPressed: () {
                        (widget.searchQuery != null)
                            ? Navigator.pop(context)
                            : setState(() {
                                showResults = false;
                                myController.clear();
                              });
                      },
                    ),
                  SizedBox(
                    width: (showResults) ? width * 0.785 : width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 15),
                      child: SearchInputField(
                        myController: myController,
                        hintText: "What do you want to listen to?",
                        borderRadius: 5,
                        onSubmitted: (query) {
                          if (query != null) {
                            setState(() {
                              showResults = true;
                            });
                            searchYoutube(query);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 18.0),
                child: Text(
                  (showResults) ? "Search Results" : "Recently Played",
                  style: const TextStyle(
                    fontSize: 28.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        // decoration: kBoxDecoration,
        child: (showResults)
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.network(
                      searchResults[index].thumbnailUrl,
                      height: 120,
                    ),
                    title: Text(
                      searchResults[index].title.trimTitle(),
                      style: kMusicTitleStyle,
                    ),
                    subtitle: Text(
                      searchResults[index].channelTitle,
                      style: kMusicInfoStyle,
                    ),
                    trailing: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onTap: () => {
                      recentSearches.insert(
                        0,
                        Songs(
                          id: searchResults[index].id,
                          channelTitle: searchResults[index].channelTitle,
                          title: searchResults[index].title.trimTitle(),
                          thumbnailUrl: searchResults[index].thumbnailUrl,
                        ),
                      ),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(
                            videoId: searchResults[index].id,
                            thumbnailUrl: searchResults[index].thumbnailUrl,
                            title: searchResults[index].title.trimTitle(),
                            channelTitle: searchResults[index].channelTitle,
                          ),
                        ),
                      )
                    },
                  );
                },
              )
            : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.network(recentSearches[index].thumbnailUrl),
                    subtitle: Text(
                      recentSearches[index].channelTitle,
                      style: kMusicInfoStyle,
                    ),
                    title: Text(
                      recentSearches[index].title,
                      style: kMusicTitleStyle,
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          recentSearches.remove(recentSearches[index]);
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
                            videoId: recentSearches[index].id,
                            thumbnailUrl: recentSearches[index].thumbnailUrl,
                            title: recentSearches[index].title,
                            channelTitle: recentSearches[index].channelTitle,
                          ),
                        ),
                      )
                    },
                  );
                },
              ),
      ),
    );
  }
}
