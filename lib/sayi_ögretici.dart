import 'package:flutter/material.dart';
import 'package:egitici/services/tts_service.dart';
import 'dart:async';
import 'package:egitici/widgets/custom_circle_button.dart';

class SayiOgrenmeEkrani extends StatefulWidget {
  const SayiOgrenmeEkrani({super.key});

  @override
  _SayiOgrenmeEkraniState createState() => _SayiOgrenmeEkraniState();
}

class _SayiOgrenmeEkraniState extends State<SayiOgrenmeEkrani> {
  int _seciliSayi = 1;
  bool _tekrarOkuyor = false;
  Timer? _timer;

  final Map<int, Map<String, dynamic>> _sayiVerileri = {
    1: {
      "obj": Icons.star,
      "renk": Colors.orange,
      "metin": "BİR",
      "isim": "YILDIZ",
    },
    2: {
      "obj": Icons.pets,
      "renk": Colors.brown,
      "metin": "İKİ",
      "isim": "TAVŞAN",
    },
    3: {
      "obj": Icons.directions_bus,
      "renk": Colors.blue,
      "metin": "ÜÇ",
      "isim": "OTOBÜS",
    },
    4: {
      "obj": Icons.local_florist,
      "renk": Colors.pink,
      "metin": "DÖRT",
      "isim": "ÇİÇEK",
    },
    5: {
      "obj": Icons.wb_sunny,
      "renk": Colors.amber,
      "metin": "BEŞ",
      "isim": "GÜNEŞ",
    },
    6: {
      "obj": Icons.cake,
      "renk": Colors.purple,
      "metin": "ALTI",
      "isim": "PASTA",
    },
    7: {
      "obj": Icons.beach_access,
      "renk": Colors.teal,
      "metin": "YEDİ",
      "isim": "ŞEMSİYE",
    },
    8: {
      "obj": Icons.icecream,
      "renk": Colors.deepOrange,
      "metin": "SEKİZ",
      "isim": "DONDURMA",
    },
    9: {
      "obj": Icons.rocket,
      "renk": Colors.indigo,
      "metin": "DOKUZ",
      "isim": "ROKET",
    },
    10: {
      "obj": Icons.sports_soccer,
      "renk": Colors.red,
      "metin": "ON",
      "isim": "TOP",
    },
  };

  @override
  void initState() {
    super.initState();
    // ✅ AÇILIŞTA OTOMATİK OKU
    Future.delayed(Duration(milliseconds: 400), () {
      _konus(_sayiVerileri[_seciliSayi]!['metin']);
    });
  }

  Future<void> _konus(String metin) async {
    await TtsService().speak(metin);
  }

  void _tekrarBaslat() {
    if (_tekrarOkuyor) {
      _tekrarDurdur();
      return;
    }

    setState(() => _tekrarOkuyor = true);

    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _konus(_sayiVerileri[_seciliSayi]!['metin']);
    });
  }

  void _tekrarDurdur() {
    _timer?.cancel();
    TtsService().stop();
    setState(() => _tekrarOkuyor = false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    TtsService().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final veri = _sayiVerileri[_seciliSayi]!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _ustBar(),
              SizedBox(height: 10),
              _anaSayi(veri),
              _metin(veri),
              _grid(veri),
              _altBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ustBar() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomCircleButton(
            icon: Icons.home,
            iconColor: Colors.orange,
            shadowColor: Colors.orange.withOpacity(0.3),
            onTap: () => Navigator.pop(context),
          ),
          Text(
            "Sayı Ormanı 🌈",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              CustomCircleButton(
                icon: Icons.volume_up,
                iconColor: Colors.blue,
                shadowColor: Colors.blue.withOpacity(0.3),
                onTap: () => _konus(_sayiVerileri[_seciliSayi]!['metin']),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _anaSayi(Map veri) {
    double screenWidth = MediaQuery.of(context).size.width;
    double circleSize = screenWidth * 0.5 > 250 ? 250 : screenWidth * 0.5;

    return GestureDetector(
      onTap: () => _konus(veri['metin']),
      child: Container(
        width: circleSize,
        height: circleSize,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(circleSize * 0.15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: veri['renk'].withOpacity(0.15),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            _seciliSayi.toString(),
            style: TextStyle(
              fontSize: circleSize * 0.8,
              fontWeight: FontWeight.bold,
              color: veri['renk'],
            ),
          ),
        ),
      ),
    );
  }

  Widget _metin(Map veri) {
    return GestureDetector(
      onTap: () => _konus("${veri['metin']} ${veri['isim']}"),
      child: Column(
        children: [
          Text(
            veri['metin'],
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(veri['isim'], style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _grid(Map veri) {
    double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = screenWidth * 0.1 > 45 ? 45 : screenWidth * 0.1;

    return Expanded(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: List.generate(_seciliSayi, (i) {
          return Padding(
            padding: EdgeInsets.all(iconSize * 0.2),
            child: Icon(veri['obj'], size: iconSize, color: veri['renk']),
          );
        }),
      ),
    );
  }

  Widget _altBar() {
    double screenWidth = MediaQuery.of(context).size.width;
    double barHeight = screenWidth * 0.25 > 120 ? 120 : screenWidth * 0.25;
    double baseSize = screenWidth * 0.13 > 60 ? 60 : screenWidth * 0.13;

    return Container(
      height: barHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(10, (index) {
            int s = index + 1;
            bool secili = s == _seciliSayi;
            Color renk = _sayiVerileri[s]!['renk'];

            return GestureDetector(
              onTap: () {
                setState(() {
                  _seciliSayi = s;
                });
                _konus(_sayiVerileri[s]!['metin']);
              },
              child: Transform.scale(
                scale: secili ? 1.2 : 1.0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  width: baseSize,
                  height: baseSize,
                  decoration: BoxDecoration(
                    color: secili ? renk : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: renk.withOpacity(0.3), blurRadius: 8),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "$s",
                      style: TextStyle(
                        fontSize: baseSize * 0.35,
                        fontWeight: FontWeight.bold,
                        color: secili ? Colors.white : renk,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
