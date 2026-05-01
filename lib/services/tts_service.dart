import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  final FlutterTts _flutterTts = FlutterTts();
  bool _isReady = false;

  TtsService._internal() {
    _init();
  }

  Future<void> _init() async {
    try {
      await _flutterTts.setLanguage("tr-TR");
      await _flutterTts.setPitch(1.2);
      await _flutterTts.setSpeechRate(0.4);
      await _flutterTts.awaitSpeakCompletion(true);
    } catch (e) {
      print("TTS Init Hatası: $e");
    } finally {
      _isReady = true;
    }
  }

  Future<void> speak(String text) async {
    if (!_isReady) return;
    try {
      await _flutterTts.stop();
      await _flutterTts.speak(text);
    } catch (e) {
      print("TTS Konuşma Hatası: $e");
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
