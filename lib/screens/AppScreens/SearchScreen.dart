// ignore_for_file: must_be_immutable, file_names

import 'dart:async';
import 'package:harmony/core/api_client.dart';
import 'package:harmony/main.dart';
import 'package:harmony/model/song.dart';
import 'package:harmony/utils/extensions/dartExtensions.dart';
import 'package:harmony/utils/functions/localStorage.dart';
import 'package:harmony/utils/network_utils.dart';
import 'package:harmony/utils/textStyles.dart';
import 'package:harmony/widgets/inputFields.dart';
import 'package:harmony/widgets/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

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
  bool showResults = false;
  List<Songs> recentSearches = [];
  List<Songs> searchResults = [];

  final _searchQueryController = StreamController<String>.broadcast();
  Stream<String> get _debouncedSearchQuery => _searchQueryController.stream
      .distinct()
      .debounceTime(const Duration(milliseconds: 500));

  final _scrollController = ScrollController();
  double _currentPosition = 0.0;
  int _loadMoreCount = 0;
  final List<DateTime> _loadTimes = [];
  bool _canLoadMore = true;
  String nextPageToken = '';
  late Map<String, dynamic> response;

  @override
  void initState() {
    super.initState();
    getRecentSearches();
    _debouncedSearchQuery.listen((query) {
      if (query.isNotEmpty) {
        showResults = true;
        searchYoutube(query);
      }
    });

    if (widget.searchQuery != null) {
      searchYoutube(widget.searchQuery!);
      setState(() {
        myController.text = widget.searchQuery!;
        showResults = true;
      });
    }
  }

  Timer? _debounceTimer;

  Future<void> searchAPICall(BuildContext context, String query) async {
    // Cancel the previous debounce timer if it exists to prevent extra calls
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel();
    }

    // Start a new debounce timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      //Make API call or do something
      if (query.isNotEmpty) {
        searchYoutube(query);
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchQueryController.close();
    saveRecentSearches();
    super.dispose();
  }

  Future<void> saveSearchResults(List<Songs> results) async {
    await saveList('searchResults', results);
  }

  Future<List<Songs>> getSearchResults() async {
    return getList('searchResults');
  }

  Future<void> saveRecentSearches() async {
    await saveList('recentSearches', recentSearches);
  }

  Future<void> getRecentSearches() async {
    List<Songs> searches = await getList('recentSearches');
    setState(() {
      recentSearches = searches;
    });
  }

  void searchYoutube(String query) async {
    logger.i('Searching for $query');
    if (await NetworkUtils.isConnected()) {
      logger.i('Connected to the internet');
      response = await apiClient.searchYoutube(query);
      var items = List<Map<String, dynamic>>.from(response['items']);
      List<Songs> results = items.map((item) => Songs.fromJson(item)).toList();
      saveSearchResults(results);
      setState(() {
        searchResults = results;
        nextPageToken = response['nextPageToken'];
      });
    } else {
      logger.i('Not connected to the internet');
      List<Songs> results = await getSearchResults();
      setState(() {
        searchResults = results;
      });
    }
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
                        onChanged: (query) {
                          _searchQueryController.sink.add(query!);
                          // searchAPICall(context, query!);
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
        child: (showResults)
            ? NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    _currentPosition = notification.metrics.pixels;
                    if (_currentPosition ==
                        notification.metrics.maxScrollExtent) {
                      _loadMoreData();
                    }
                  }
                  return false;
                },
                child: ListView(
                  children: [
                    ListView.builder(
                      controller: _scrollController,
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
                                  thumbnailUrl:
                                      searchResults[index].thumbnailUrl,
                                  title: searchResults[index].title.trimTitle(),
                                  channelTitle:
                                      searchResults[index].channelTitle,
                                ),
                              ),
                            )
                          },
                        );
                      },
                    ),
                    _showLoadMoreButton(),
                  ],
                ),
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

  void _loadMoreData() async {
    if (await NetworkUtils.isConnected() && _canLoadMore) {
      logger.i('Connected to the internet');
      response = await apiClient.searchYoutubeNextPage(
          myController.text, nextPageToken);

      var items = List<Map<String, dynamic>>.from(response['items']);
      List<Songs> moreResults =
          items.map((item) => Songs.fromJson(item)).toList();
      setState(() {
        searchResults.addAll(moreResults);
        _loadMoreCount++;
        _loadTimes.add(DateTime.now());
        nextPageToken = response['nextPageToken'];

        if (_loadTimes.length >= 5) {
          final lastLoadTime = _loadTimes.last;
          final timeDifference = lastLoadTime.difference(_loadTimes.first);
          if (timeDifference.inSeconds <= 10) {
            _canLoadMore = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'You have loaded more data too fast. Please use the "Load More" button to continue.',
                ),
              ),
            );
            _loadTimes.clear();
          }
        }
      });
    }
  }

  Widget _showLoadMoreButton() {
    if (_loadMoreCount >= 5) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            _canLoadMore = true;
            _loadMoreData();
            _loadMoreCount = 0;
          },
          child: const Text('Load More'),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
