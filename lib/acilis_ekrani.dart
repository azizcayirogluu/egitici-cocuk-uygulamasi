import 'package:egitici/boyama_ekrani.dart';
import 'package:egitici/hayvan_ogretici.dart';
import 'package:egitici/mevsim_%C3%B6gretici.dart';
import 'package:egitici/renk_%C3%B6gretici.dart';
import 'package:egitici/sayi_%C3%B6gretici.dart';
import 'package:egitici/eslestirme_oyunu.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:egitici/widgets/custom_circle_button.dart';

class AcilisEkrani extends StatefulWidget {
  @override
  State<AcilisEkrani> createState() => _AcilisEkraniState();
}

class _AcilisEkraniState extends State<AcilisEkrani> {
  bool isSoundOn = true;
  final AudioPlayer _bgPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _muzikCal();
  }

  Future<void> _muzikCal() async {
    try {
      await _bgPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgPlayer.setVolume(0.1);
      await _bgPlayer.setSource(AssetSource("sounds/main.mp3"));
      await _bgPlayer.resume();
    } catch (e) {
      debugPrint("Müzik çalma hatası: $e");
    }
  }

  Future<void> _muzikToggle() async {
    setState(() {
      isSoundOn = !isSoundOn;
    });
    if (isSoundOn) {
      await _muzikCal();
    } else {
      await _bgPlayer.stop();
    }
  }

  @override
  void dispose() {
    _bgPlayer.dispose();
    super.dispose();
  }

  Future<void> _sayfayaGit(Widget sayfa) async {
    await _bgPlayer.stop();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => sayfa),
    );
    if (isSoundOn && mounted) _muzikCal();
  }

  void _ayarlariGoster() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              backgroundColor: Colors.white,
              child: Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(
                    color: Colors.purpleAccent.withOpacity(0.3),
                    width: 4,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Ayarlar ⚙️",
                      style: TextStyle(
                        fontFamily: 'BubblegumSans',
                        fontSize: 30,
                        color: Colors.purple.shade700,
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(
                        isSoundOn ? Icons.volume_up : Icons.volume_off,
                        color: Colors.redAccent,
                        size: 30,
                      ),
                      title: Text(
                        "Oyun Sesi",
                        style: TextStyle(
                          fontFamily: 'BubblegumSans',
                          fontSize: 20,
                        ),
                      ),
                      trailing: Switch(
                        value: isSoundOn,
                        activeColor: Colors.green,
                        onChanged: (value) async {
                          await _muzikToggle();
                          setDialogState(() {});
                        },
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: Colors.blueAccent,
                        size: 30,
                      ),
                      title: Text(
                        "Hakkımızda",
                        style: TextStyle(
                          fontFamily: 'BubblegumSans',
                          fontSize: 20,
                        ),
                      ),
                      onTap: () {
                        debugPrint("Hakkımızda tıklandı");
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        elevation: 5,
                      ),
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        "Tamam",
                        style: TextStyle(
                          fontFamily: 'BubblegumSans',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. ARKA PLAN
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/kid_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. KARTLAR (en altta)
          Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 25,
                  runSpacing: 25,
                  children: [
                    _devCocukKarti(
                      context,
                      "Mevsimler",
                      "🌤️",
                      Colors.orange,
                      () {
                        _sayfayaGit(MevsimOgrenmeEkrani());
                      },
                    ),
                    _devCocukKarti(
                      context,
                      "Sayılar",
                      "🔢",
                      Colors.blueAccent,
                      () {
                        _sayfayaGit(SayiOgrenmeEkrani());
                      },
                    ),
                    _devCocukKarti(context, "Renkler", "🎨", Colors.purple, () {
                      _sayfayaGit(RenkOgrenmeEkrani());
                    }),
                    _devCocukKarti(
                      context,
                      "Hayvanlar",
                      "🦁",
                      Colors.green,
                      () {
                        _sayfayaGit(HayvanOgrenmeEkrani());
                      },
                    ),
                    _devCocukKarti(context, "Boyama", "🎨", Colors.yellow, () {
                      _sayfayaGit(BoyamaGaleriSayfasi());
                    }),
                    _devCocukKarti(
                      context,
                      "Eşleştirme",
                      "🧩",
                      Colors.teal,
                      () {
                        _sayfayaGit(EslestirmeEkrani());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. ÜST PANEL — Stack'te EN ÜSTE alındı (kartların üzerinde)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Öğrenme Zamanı 🎈",
                      style: TextStyle(
                        fontFamily: 'BubblegumSans',
                        fontSize: 22,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CustomCircleButton(
                        icon: isSoundOn
                            ? Icons.volume_up_rounded
                            : Icons.volume_off_rounded,
                        iconColor: isSoundOn ? Colors.redAccent : Colors.grey,
                        onTap: _muzikToggle,
                      ),
                      SizedBox(width: 10),
                      CustomCircleButton(
                        icon: Icons.settings_rounded,
                        iconColor: Colors.purpleAccent,
                        onTap: _ayarlariGoster,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _devCocukKarti(
    BuildContext context,
    String baslik,
    String emoji,
    Color renk,
    VoidCallback onTap,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth > 600 ? 200 : screenWidth * 0.42;
    double cardHeight = cardWidth * 1.2;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: renk.withOpacity(0.3), width: 4),
          boxShadow: [
            BoxShadow(
              color: renk.withOpacity(0.5),
              offset: Offset(0, 10),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: renk.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: cardWidth * 0.35),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  baslik,
                  style: TextStyle(
                    fontFamily: 'BubblegumSans',
                    fontSize: cardWidth * 0.16,
                    fontWeight: FontWeight.bold,
                    color: renk,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
