import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:egitici/services/tts_service.dart';
import 'package:egitici/widgets/custom_circle_button.dart';

class RenkOgrenmeEkrani extends StatefulWidget {
  @override
  State<RenkOgrenmeEkrani> createState() => _RenkOgrenmeEkraniState();
}

class _RenkOgrenmeEkraniState extends State<RenkOgrenmeEkrani> {
  int _seciliIndex = 0;

  final List<Map<String, dynamic>> _renkVerileri = [
    {"isim": "KIRMIZI", "renk": Colors.red, "nesneler": ["🍎", "🚒", "🍓"], "mesaj": "Kırmızı elma çok lezzetli!"},
    {"isim": "MAVİ", "renk": Colors.blue, "nesneler": ["🌊", "🦋", "🐋"], "mesaj": "Mavi deniz serin!"},
    {"isim": "SARI", "renk": Colors.yellow.shade700, "nesneler": ["☀️", "🍋", "🐥"], "mesaj": "Sarı güneş bizi ısıtır!"},
    {"isim": "YEŞİL", "renk": Colors.green, "nesneler": ["🌳", "🐢", "🍏"], "mesaj": "Yeşil doğa harika!"},
    {"isim": "TURUNCU", "renk": Colors.orange, "nesneler": ["🦊", "🥕", "🏀"], "mesaj": "Turuncu çok enerjik!"},
    {"isim": "MOR", "renk": Colors.purple, "nesneler": ["🍇", "🍆", "🌂"], "mesaj": "Mor çok güzel bir renk!"},
    {"isim": "PEMBE", "renk": Colors.pinkAccent, "nesneler": ["🌸", "🍭", "🦩"], "mesaj": "Pembe çok tatlı!"},
    {"isim": "BEYAZ", "renk": Colors.grey.shade400, "nesneler": ["☁️", "⛄", "🥛"], "mesaj": "Beyaz çok temiz!"},
    {"isim": "SİYAH", "renk": Colors.black87, "nesneler": ["🐧", "🐼", "⚽"], "mesaj": "Siyah güçlü bir renk!"},
    {"isim": "KAHVERENGİ", "renk": Colors.brown, "nesneler": ["🐻", "🍫", "🪵"], "mesaj": "Kahverengi doğanın rengi!"},
  ];

  @override
  void initState() {
    super.initState();
    // Açılışta ilk rengi oku
    Future.delayed(Duration(milliseconds: 400), () {
      _konus(_renkVerileri[_seciliIndex]['isim']);
    });
  }

  Future<void> _konus(String text) async {
    await TtsService().speak(text);
  }

  void _renkSec(int index) {
    setState(() => _seciliIndex = index);
    HapticFeedback.lightImpact();
    _konus(_renkVerileri[index]['isim']);
  }

  @override
  void dispose() {
    TtsService().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final veri = _renkVerileri[_seciliIndex];
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth > 600 ? 500 : screenWidth * 0.85;

    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              veri['renk'].withOpacity(0.3),
              Colors.white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              // 🔝 ÜST BAR
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomCircleButton(icon: Icons.arrow_back_ios_new, onTap: () => Navigator.pop(context)),
                    Text("Renkleri Tanıyalım", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    CustomCircleButton(icon: Icons.volume_up, onTap: () => _konus(veri['isim'])),
                  ],
                ),
              ),

              Spacer(),

              // 🎨 ANA KART
              GestureDetector(
                onTap: () => _konus(veri['mesaj']),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  width: cardWidth,
                  padding: EdgeInsets.all(cardWidth * 0.08),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: veri['renk'].withOpacity(0.4),
                        offset: Offset(0, 15),
                        blurRadius: 0,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          veri['isim'],
                          style: TextStyle(
                            fontSize: cardWidth * 0.15,
                            fontWeight: FontWeight.bold,
                            color: veri['renk'],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // 🎈 EMOJİLER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: (veri['nesneler'] as List<String>).map((e) {
                          return TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: Duration(milliseconds: 500),
                            builder: (context, double val, child) {
                              return Transform.scale(
                                scale: val,
                                child: Text(e, style: TextStyle(fontSize: cardWidth * 0.18)),
                              );
                            },
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 20),

                      Text(
                        veri['mesaj'],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: cardWidth * 0.07, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
              ),

              Spacer(),

              // 🎯 ALT RENK SEÇİCİ
              SizedBox(
                height: screenWidth * 0.25 > 110 ? 110 : screenWidth * 0.25,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _renkVerileri.length,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  itemBuilder: (context, index) {
                    bool secili = index == _seciliIndex;
                    Color renk = _renkVerileri[index]['renk'];
                    double baseSize = screenWidth * 0.13 > 60 ? 60 : screenWidth * 0.13;
                    double selectedSize = baseSize * 1.25;

                    return GestureDetector(
                      onTap: () => _renkSec(index),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        width: secili ? selectedSize : baseSize,
                        height: secili ? selectedSize : baseSize,
                        decoration: BoxDecoration(
                          color: renk,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: secili ? 4 : 0),
                          boxShadow: [
                            BoxShadow(
                              color: renk.withOpacity(0.4),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: secili
                            ? Icon(Icons.check, color: Colors.white, size: 30)
                            : null,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }


}