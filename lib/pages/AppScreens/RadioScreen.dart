// ignore_for_file: file_names

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harmony/constants/widgetExtensions.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../model/RadioModel.dart';

class RadioHS extends StatefulWidget {
  static String id = "RadioScreen";
  const RadioHS({super.key});

  @override
  State<RadioHS> createState() => _RadioHSState();
}

class _RadioHSState extends State<RadioHS> {
  int idx = 1;

  final screens = [
    const RadioHS(),
  ];

  List<MyRadio>? radios;
  late MyRadio _selectedradio;
  bool _isPlaying = false;

  final audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    fetchRadios();

    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.playing) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      setState(() {});
    });
  }

  fetchRadios() async {
    final radiojson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radiojson).radios;
    // print(radios);
    setState(() {});
  }

  void playMusic(String url) {
    audioPlayer.play(UrlSource(url));
    _selectedradio = radios!.firstWhere((element) => element.url == url);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Radio",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ).h(100).p16(),
          radios != null
              ? Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 110,
                      ),
                      VxSwiper.builder(
                          itemCount: radios!.length,
                          aspectRatio: 0.73,
                          itemBuilder: (context, index) {
                            final rad = radios![index];
                            return VxBox(
                                    child: ZStack([
                              Positioned(
                                top: 5.0,
                                right: 5.0,
                                child: VxBox(
                                  child: rad.category.text.uppercase.white
                                      .make()
                                      .px16(),
                                )
                                    .height(40)
                                    .black
                                    .alignCenter
                                    .withRounded(value: 30.0)
                                    .make(),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: VStack(
                                  [
                                    rad.name.text.xl3.white.bold.make(),
                                    20.heightBox,
                                    rad.tagline.text.sm.white.semiBold.make(),
                                  ],
                                  crossAlignment: CrossAxisAlignment.center,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: [
                                  const Icon(
                                    CupertinoIcons.play_circle,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  20.heightBox,
                                  "Double Tap to play".text.gray300.make()
                                ].vStack(),
                              ),
                            ]))
                                .clip(Clip.antiAlias)
                                .bgImage(
                                  DecorationImage(
                                      image: NetworkImage(rad.image),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.4),
                                          BlendMode.darken)),
                                )
                                .border()
                                .withRounded(value: 20.0)
                                .make()
                                .onInkDoubleTap(() {
                              playMusic(rad.url);
                            }).p16();
                          }).centered(),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: [
              if (_isPlaying)
                SizedBox(
                  width: 200,
                  height: 50,
                  child: FittedBox(
                      fit: BoxFit.fill,
                      child:
                          Image.asset("assets/orange-music-wave-doodle.gif")),
                ),
              Icon(
                _isPlaying ? CupertinoIcons.stop_circle : null,
                color: Colors.orange,
                size: 50.0,
              ).onInkTap(() {
                if (_isPlaying) {
                  audioPlayer.stop();
                } else {
                  audioPlayer.play(UrlSource(_selectedradio.url));
                  playMusic(_selectedradio.url);
                }
              }).padding(8),
            ].vStack(),
          ),
        ],
      ),
    );
  }
}
