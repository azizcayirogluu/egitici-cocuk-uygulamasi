import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'acilis_ekrani.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AudioPlayer.global.setAudioContext(
    const AudioContext(
      android: AudioContextAndroid(
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.gain,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: [
          AVAudioSessionOptions.mixWithOthers,
          AVAudioSessionOptions.defaultToSpeaker,
        ],
      ),
    ),
  );

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: AcilisEkrani(),
    );
  }
}
