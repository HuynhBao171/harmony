import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:harmony/api_key.dart';
import 'package:harmony/screens/AssistantScreens/models/config/gemini_config.dart';
import 'package:harmony/screens/AssistantScreens/models/config/gemini_safety_settings.dart';
import 'package:harmony/screens/AssistantScreens/models/gemini/gemini.dart';

// Function to run in the background isolate
void backgroundTask() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background
      onStart: onStart,
      // auto start service on device boot
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(),
  );
  service.startService();
}

final safety1 = SafetySettings(
    category: SafetyCategory.HARM_CATEGORY_DANGEROUS_CONTENT,
    threshold: SafetyThreshold.BLOCK_ONLY_HIGH);

final config = GenerationConfig(
    temperature: 0.5,
    maxOutputTokens: 100,
    topP: 1.0,
    topK: 40,
    stopSequences: []);

// Method called when the service starts
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();

  final FlutterTts flutterTts = FlutterTts();
  flutterTts.setLanguage("vi-VN");

  // Initialize Gemini API (replace with your actual initialization)
  final gemini = GoogleGemini(
      apiKey: apiGeminiKey, safetySettings: [safety1], config: config);

  // Listen for messages from the main isolate
  final ReceivePort receivePort = ReceivePort();
  IsolateNameServer.registerPortWithName(receivePort.sendPort, 'geminachat');
  receivePort.listen((message) async {
    if (message is String) {
      // Get response from Gemini
      final response = await gemini.generateFromText(message);
      // Speak the response
      await flutterTts.speak(response.text);
      // Send response back to main isolate
      IsolateNameServer.lookupPortByName('main')?.send(response.text);
    }
  });
}
