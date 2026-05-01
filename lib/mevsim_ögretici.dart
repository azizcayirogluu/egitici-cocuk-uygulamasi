import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:egitici/widgets/custom_circle_button.dart';

class MevsimOgrenmeEkrani extends StatefulWidget {
  @override
  _MevsimOgrenmeEkraniState createState() =>
      _MevsimOgrenmeEkraniState();
}

class _MevsimOgrenmeEkraniState extends State<MevsimOgrenmeEkrani> {
  int _mevsimIndex = 0;

  final AudioPlayer _player = AudioPlayer();
  bool _sesAcik = true;

  final List<Map<String, dynamic>> _mevsimler = [
    {
      "isim": "İLKBAHAR",
      "emoji": "🌸",
      "renk": Colors.greenAccent,
      "mesaj": "Çiçekler açıyor, doğa uyanıyor!",
      "nesneler": ["🦋", "🌷", "🐝"],
      "altMesaj": "Kuş cıvıltılarını duyuyor musun?",
      "ses": "sounds/birds.mp3",
    },
    {
      "isim": "YAZ",
      "emoji": "☀️",
      "renk": Colors.yellowAccent,
      "mesaj": "Güneş parlıyor, dondurma vakti!",
      "nesneler": ["🍦", "🌊", "🍉"],
      "altMesaj": "Hadi denize gidelim!",
      "ses": "sounds/sea.mp3",
    },
    {
      "isim": "SONBAHAR",
      "emoji": "🍂",
      "renk": Colors.orangeAccent,
      "mesaj": "Yapraklar dökülüyor, rüzgar esiyor!",
      "nesneler": ["☔", "🍄", "🌬️"],
      "altMesaj": "Sararan yapraklar ne güzel!",
      "ses": "sounds/wind.mp3",
    },
    {
      "isim": "KIŞ",
      "emoji": "❄️",
      "renk": Colors.blueAccent,
      "mesaj": "Kar yağıyor, kalın giyinmelisin!",
      "nesneler": ["⛄", "🧤", "⛷️"],
      "altMesaj": "Kardan adam yapalım mı?",
      "ses": "sounds/rain.mp3",
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      _sesCal();
    });
  }

  Future<void> _sesCal() async {
    if (!_sesAcik) return;

    String dosya = _mevsimler[_mevsimIndex]["ses"];

    try {
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.loop);
      // AssetSource için assets/ eklemeye gerek yok, paket hallediyor
      await _player.setSource(AssetSource(dosya));
      await _player.resume();
    } catch (e) {
      print("Ses çalma hatası: $e");
    }
  }

  void _sonrakiMevsim() {
    setState(() {
      _mevsimIndex = (_mevsimIndex + 1) % _mevsimler.length;
    });
    _sesCal();
  }

  void _oncekiMevsim() {
    setState(() {
      _mevsimIndex =
          (_mevsimIndex - 1 + _mevsimler.length) % _mevsimler.length;
    });
    _sesCal();
  }

  void _sesToggle() {
    setState(() => _sesAcik = !_sesAcik);

    if (_sesAcik) {
      _sesCal();
    } else {
      _player.stop();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mevsim = _mevsimler[_mevsimIndex];

    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              mevsim['renk'].withOpacity(0.4),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _ustBar(),

              Spacer(),

              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: _anaKart(mevsim),
              ),

              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: (mevsim['nesneler'] as List<String>)
                    .map((e) => _baloncuk(e, mevsim['renk']))
                    .toList(),
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  mevsim['altMesaj'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22),
                ),
              ),

              Spacer(),

              _altButonlar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ustBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomCircleButton(icon: Icons.arrow_back, onTap: () => Navigator.pop(context)),
          Text("Mevsimler", style: TextStyle(fontSize: 26)),
          CustomCircleButton(
            icon: _sesAcik ? Icons.volume_up : Icons.volume_off,
            onTap: _sesToggle,
          ),
        ],
      ),
    );
  }

  Widget _anaKart(Map<String, dynamic> m) {
    double cardWidth = MediaQuery.of(context).size.width * 0.8;
    return Container(
      key: ValueKey(m["isim"]),
      width: cardWidth,
      padding: EdgeInsets.all(cardWidth * 0.08),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: m['renk'], width: 5),
        boxShadow: [
          BoxShadow(
            color: m['renk'].withOpacity(0.4),
            offset: Offset(0, 10),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(m['emoji'], style: TextStyle(fontSize: cardWidth * 0.3)),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(m['isim'],
                style: TextStyle(fontSize: cardWidth * 0.15, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 10),
          Text(m['mesaj'], textAlign: TextAlign.center, style: TextStyle(fontSize: cardWidth * 0.06)),
        ],
      ),
    );
  }

  Widget _baloncuk(String e, Color renk) {
    double screenWidth = MediaQuery.of(context).size.width;
    double size = screenWidth > 600 ? 45 : screenWidth * 0.09;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.all(size * 0.3),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: renk.withOpacity(0.3), blurRadius: 10)
        ],
      ),
      child: Text(e, style: TextStyle(fontSize: size)),
    );
  }



  Widget _altButonlar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: _oncekiMevsim,
            child: Text("Geri"),
          ),
          ElevatedButton(
            onPressed: _sonrakiMevsim,
            child: Text("İleri"),
          ),
        ],
      ),
    );
  }
}