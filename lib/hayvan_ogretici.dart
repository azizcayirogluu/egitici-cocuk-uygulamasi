import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:egitici/widgets/custom_circle_button.dart';

class HayvanOgrenmeEkrani extends StatefulWidget {
  @override
  State<HayvanOgrenmeEkrani> createState() => _HayvanOgrenmeEkraniState();
}

class _HayvanOgrenmeEkraniState extends State<HayvanOgrenmeEkrani> {
  int _seciliIndex = 0;
  final AudioPlayer _player = AudioPlayer();

  final List<Map<String, dynamic>> _hayvanlar = [
    {"isim": "ASLAN", "emoji": "🦁", "renk": Colors.orange, "audio": "lion.mp3"},
    {"isim": "FİL", "emoji": "🐘", "renk": Colors.blueGrey, "audio": "elephant.mp3"},
    {"isim": "KÖPEK", "emoji": "🐶", "renk": Colors.brown, "audio": "dog.mp3"},
    {"isim": "KEDİ", "emoji": "🐱", "renk": Colors.pinkAccent, "audio": "cat.mp3"},
    {"isim": "İNEK", "emoji": "🐮", "renk": Colors.green, "audio": "cow.mp3"},
    {"isim": "AT", "emoji": "🐴", "renk": Colors.brown, "audio": "horse.mp3"},
    {"isim": "KOYUN", "emoji": "🐑", "renk": Colors.grey, "audio": "sheep.mp3"},
    {"isim": "KEÇİ", "emoji": "🐐", "renk": Colors.teal, "audio": "goat.mp3"},
    {"isim": "ÖRDEK", "emoji": "🦆", "renk": Colors.yellow, "audio": "duck.mp3"},
    {"isim": "TAVUK", "emoji": "🐔", "renk": Colors.orange, "audio": "chicken.mp3"},
    {"isim": "KURBAĞA", "emoji": "🐸", "renk": Colors.green, "audio": "frog.mp3"},
    {"isim": "MAYMUN", "emoji": "🐒", "renk": Colors.brown, "audio": "monkey.mp3"},
    {"isim": "AYI", "emoji": "🐻", "renk": Colors.brown, "audio": "bear.mp3"},
    {"isim": "KURT", "emoji": "🐺", "renk": Colors.grey, "audio": "wolf.mp3"},
    {"isim": "KAPLAN", "emoji": "🐯", "renk": Colors.deepOrange, "audio": "tiger.mp3"},
    {"isim": "BAYKUŞ", "emoji": "🦉", "renk": Colors.brown, "audio": "owl.mp3"},
    {"isim": "PAPAĞAN", "emoji": "🦜", "renk": Colors.green, "audio": "parrot.mp3"},
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _sesCal(String file) async {
    try {
      await _player.stop();
      await _player.play(AssetSource("sounds/$file"));
    } catch (e) {
      print("Ses çalma hatası: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hayvan = _hayvanlar[_seciliIndex];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            // ÜST BAR
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCircleButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  Text("Hayvanlar 🐾", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(width: 44), // Denge için boşluk
                ],
              ),
            ),

            // ANA KART
            Expanded(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double cardWidth = constraints.maxWidth > 400 ? 300 : constraints.maxWidth * 0.8;
                    return GestureDetector(
                      onTap: () => _sesCal(hayvan['audio']),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: cardWidth,
                        padding: EdgeInsets.all(cardWidth * 0.1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: hayvan['renk'].withOpacity(0.4),
                              blurRadius: 0,
                              offset: Offset(0, 15),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(hayvan['emoji'], style: TextStyle(fontSize: cardWidth * 0.35)),
                            ),
                            SizedBox(height: 10),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                hayvan['isim'],
                                style: TextStyle(fontSize: cardWidth * 0.12, fontWeight: FontWeight.bold, color: hayvan['renk']),
                              ),
                            ),
                            SizedBox(height: 10),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text("Dokun ve sesini dinle 🔊", style: TextStyle(fontSize: cardWidth * 0.06)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                ),
              ),
            ),

            // ALT SEÇİCİ
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _hayvanlar.length,
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (context, index) {
                  final h = _hayvanlar[index];
                  bool secili = index == _seciliIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _seciliIndex = index);
                      _sesCal(h['audio']);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.all(8),
                      width: secili ? 75 : 60,
                      height: secili ? 75 : 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: h['renk'], width: 3),
                      ),
                      child: Center(
                        child: Text(h['emoji'], style: TextStyle(fontSize: 30)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}