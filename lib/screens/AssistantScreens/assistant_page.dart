// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:harmony/api_key.dart';
import 'package:harmony/screens/AssistantScreens/models/config/gemini_config.dart';
import 'package:harmony/screens/AssistantScreens/models/config/gemini_safety_settings.dart';
import 'package:harmony/screens/AssistantScreens/models/gemini/gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:rxdart/rxdart.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const TabBar(
                tabs: [
                  Tab(text: "Text Only"),
                  Tab(text: "Text with Image"),
                ],
              ),
              centerTitle: true,
            ),
            body: TabBarView(
              children: [TextOnly(user: 'User'), TextWithImage(user: 'User')],
            )));
  }
}

// ------------------------------ Text Only ------------------------------

// ignore: must_be_immutable
class TextOnly extends StatefulWidget {
  TextOnly({super.key, required this.user});
  String user;

  @override
  State<TextOnly> createState() => _TextOnlyState();
}

class _TextOnlyState extends State<TextOnly> {
  bool loading = false;
  List textChat = [];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;

  final FlutterTts flutterTts = FlutterTts();

  Timer? _speechTimer;

  var _speechStream = BehaviorSubject<String>();

  late final gemini;

  final safety1 = SafetySettings(
      category: SafetyCategory.HARM_CATEGORY_DANGEROUS_CONTENT,
      threshold: SafetyThreshold.BLOCK_ONLY_HIGH);

  final config = GenerationConfig(
      temperature: 0.5,
      maxOutputTokens: 100,
      topP: 1.0,
      topK: 40,
      stopSequences: []);

  @override
  void initState() {
    _initTts();
    gemini = GoogleGemini(
        apiKey: apiGeminiKey, safetySettings: [safety1], config: config);
    super.initState();
    // Lời chào từ Gemini
    textChat.add({
      "role": "Gemini",
      "text":
          "Xin chào! Tôi ở đây để giúp bạn có trải nghiệm âm nhạc tuyệt vời.",
    });
    _speak(textChat[0]['text']);
  }

  Future _initTts() async {
    await flutterTts.setLanguage("vi-VN");
  }

  @override
  void dispose() {
    _speechStream.close();
    _speechToText.stop();
    super.dispose();
  }

  Future _speak(String text) async {
    await flutterTts.speak(text);
  }

  void fromText({required String query, required String user}) {
    setState(() {
      loading = true;
      textChat.add({
        "role": user,
        "text": query,
      });
      _textController.clear();
    });
    scrollToTheEnd();

    gemini.generateFromText(query).then((value) {
      setState(() {
        loading = false;
        textChat.add({
          "role": "Gemini",
          "text": value.text,
        });
      });
      scrollToTheEnd();
      _speak(value.text);
      _startListening();
    }).catchError((error, stackTrace) {
      setState(() {
        loading = false;
        textChat.add({
          "role": "Gemini",
          "text": error.toString(),
        });
      });
      scrollToTheEnd();
      _speak(error.toString());
    });
  }

  Future<void> _startListening() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (result) {
            _speechStream.add(result.recognizedWords);
            setState(() {
              _textController.text = result.recognizedWords;
            });

            if (_speechTimer != null) _speechTimer?.cancel();
            _speechTimer = Timer(const Duration(seconds: 2), () {
              if (_isListening) {
                _stopListening();
                fromText(query: _textController.text, user: widget.user);
              }
            });
          },
        );
      }
    } else {
      _stopListening();
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speechToText.stop();
    _textController.clear();

    _speechStream.add('');
    _speechStream.close();

    _speechStream = BehaviorSubject<String>();
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _controller,
            itemCount: textChat.length,
            padding: const EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) {
              return ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                  child: Text(textChat[index]["role"].substring(0, 1)),
                ),
                title: Text(textChat[index]["role"]),
                subtitle: Text(textChat[index]["text"]),
              );
            },
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              Expanded(
                child: StreamBuilder<String>(
                    stream: _speechStream,
                    builder: (context, snapshot) {
                      _textController.text = snapshot.data ?? '';
                      return TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: "Write a message",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none),
                          fillColor: Colors.transparent,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      );
                    }),
              ),
              IconButton(
                icon: _isListening
                    ? const Icon(Icons.mic)
                    : const Icon(Icons.mic_off),
                onPressed: () {
                  _startListening();
                },
              ),
              IconButton(
                icon: loading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.send),
                onPressed: () {
                  fromText(query: _textController.text, user: widget.user);
                },
              ),
            ],
          ),
        )
      ],
    ));
  }
}

// ------------------------------ Text with Image ------------------------------

// ignore: must_be_immutable
class TextWithImage extends StatefulWidget {
  TextWithImage({super.key, required this.user});
  String user;

  @override
  State<TextWithImage> createState() => _TextWithImageState();
}

class _TextWithImageState extends State<TextWithImage> {
  bool loading = false;
  List textAndImageChat = [];
  List textWithImageChat = [];
  File? imageFile;

  final ImagePicker picker = ImagePicker();

  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  late final gemini;

  final safety1 = SafetySettings(
      category: SafetyCategory.HARM_CATEGORY_DANGEROUS_CONTENT,
      threshold: SafetyThreshold.BLOCK_ONLY_HIGH);

  final config = GenerationConfig(
      temperature: 0.5,
      maxOutputTokens: 100,
      topP: 1.0,
      topK: 40,
      stopSequences: []);

  @override
  void initState() {
    gemini =
        GoogleGemini(apiKey: apiKey, safetySettings: [safety1], config: config);
    super.initState();
  }

  void fromTextAndImage(
      {required String query, required String user, required File image}) {
    setState(() {
      loading = true;
      textAndImageChat.add({
        "role": user,
        "text": query,
        "image": image,
      });
      _textController.clear();
      imageFile = null;
    });
    scrollToTheEnd();

    gemini.generateFromTextAndImages(query: query, image: image).then((value) {
      setState(() {
        loading = false;
        textAndImageChat
            .add({"role": "Gemini", "text": value.text, "image": ""});
      });
      scrollToTheEnd();
    }).catchError((error, stackTrace) {
      setState(() {
        loading = false;
        textAndImageChat
            .add({"role": "Gemini", "text": error.toString(), "image": ""});
      });
      scrollToTheEnd();
    });
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: textAndImageChat.length,
              padding: const EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                return ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    child:
                        Text(textAndImageChat[index]["role"].substring(0, 1)),
                  ),
                  title: Text(textAndImageChat[index]["role"]),
                  subtitle: Text(textAndImageChat[index]["text"]),
                  trailing: textAndImageChat[index]["image"] == ""
                      ? null
                      : Image.file(
                          textAndImageChat[index]["image"],
                          width: 90,
                        ),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Write a message",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none),
                      fillColor: Colors.transparent,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_a_photo),
                  onPressed: () async {
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      imageFile = image != null ? File(image.path) : null;
                    });
                  },
                ),
                IconButton(
                  icon: loading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.send),
                  onPressed: () {
                    if (imageFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please select an image")));
                      return;
                    }
                    fromTextAndImage(
                        query: _textController.text,
                        user: widget.user,
                        image: imageFile!);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: imageFile != null
          ? Container(
              margin: const EdgeInsets.only(bottom: 80),
              height: 150,
              child: Image.file(imageFile ?? File("")),
            )
          : null,
    );
  }
}
