import 'package:flutter/material.dart';
import 'package:egitici/services/tts_service.dart';
import 'package:egitici/widgets/custom_circle_button.dart';

class MatchItem {
  final String isim;
  final String emoji;
  final Color renk;
  bool eslestiMi;

  MatchItem({
    required this.isim,
    required this.emoji,
    required this.renk,
    this.eslestiMi = false,
  });
}

class EslestirmeEkrani extends StatefulWidget {
  @override
  _EslestirmeEkraniState createState() => _EslestirmeEkraniState();
}

class _EslestirmeEkraniState extends State<EslestirmeEkrani> {
  late List<MatchItem> hedefler;
  late List<MatchItem> secenekler;

  final List<MatchItem> tumOgeler = [
    // Kırmızı
    MatchItem(isim: "Kırmızı", emoji: "🍎", renk: Colors.red),
    MatchItem(isim: "Kırmızı", emoji: "🚗", renk: Colors.red),
    MatchItem(isim: "Kırmızı", emoji: "🍓", renk: Colors.red),
    MatchItem(isim: "Kırmızı", emoji: "🐞", renk: Colors.red),
    // Sarı
    MatchItem(isim: "Sarı", emoji: "🍋", renk: Colors.yellow.shade700),
    MatchItem(isim: "Sarı", emoji: "🌞", renk: Colors.yellow.shade700),
    MatchItem(isim: "Sarı", emoji: "🌻", renk: Colors.yellow.shade700),
    MatchItem(isim: "Sarı", emoji: "🐥", renk: Colors.yellow.shade700),
    // Yeşil
    MatchItem(isim: "Yeşil", emoji: "🐸", renk: Colors.green),
    MatchItem(isim: "Yeşil", emoji: "🐢", renk: Colors.green),
    MatchItem(isim: "Yeşil", emoji: "🌲", renk: Colors.green),
    MatchItem(isim: "Yeşil", emoji: "🍏", renk: Colors.green),
    // Mavi
    MatchItem(isim: "Mavi", emoji: "🐋", renk: Colors.blue),
    MatchItem(isim: "Mavi", emoji: "💧", renk: Colors.blue),
    MatchItem(isim: "Mavi", emoji: "🦋", renk: Colors.blue),
    MatchItem(isim: "Mavi", emoji: "👖", renk: Colors.blue),
    // Turuncu
    MatchItem(isim: "Turuncu", emoji: "🦊", renk: Colors.orange),
    MatchItem(isim: "Turuncu", emoji: "🏀", renk: Colors.orange),
    MatchItem(isim: "Turuncu", emoji: "🥕", renk: Colors.orange),
    MatchItem(isim: "Turuncu", emoji: "🍊", renk: Colors.orange),
    // Mor
    MatchItem(isim: "Mor", emoji: "🍇", renk: Colors.purple),
    MatchItem(isim: "Mor", emoji: "🍆", renk: Colors.purple),
    MatchItem(isim: "Mor", emoji: "👾", renk: Colors.purple),
    MatchItem(isim: "Mor", emoji: "☂️", renk: Colors.purple),
    // Pembe
    MatchItem(isim: "Pembe", emoji: "🌸", renk: Colors.pink),
    MatchItem(isim: "Pembe", emoji: "🐷", renk: Colors.pink),
    MatchItem(isim: "Pembe", emoji: "🎀", renk: Colors.pink),
    MatchItem(isim: "Pembe", emoji: "🦩", renk: Colors.pink),
    // Kahverengi
    MatchItem(isim: "Kahverengi", emoji: "🐻", renk: Colors.brown),
    MatchItem(isim: "Kahverengi", emoji: "🍩", renk: Colors.brown),
    MatchItem(isim: "Kahverengi", emoji: "🪵", renk: Colors.brown),
    MatchItem(isim: "Kahverengi", emoji: "🥔", renk: Colors.brown),
    // Siyah
    MatchItem(isim: "Siyah", emoji: "🕷️", renk: Colors.black),
    MatchItem(isim: "Siyah", emoji: "🎱", renk: Colors.black),
    MatchItem(isim: "Siyah", emoji: "🦍", renk: Colors.black),
    MatchItem(isim: "Siyah", emoji: "🎩", renk: Colors.black),
    // Gri
    MatchItem(isim: "Gri", emoji: "🐘", renk: Colors.grey),
    MatchItem(isim: "Gri", emoji: "🐺", renk: Colors.grey),
    MatchItem(isim: "Gri", emoji: "⚙️", renk: Colors.grey),
    MatchItem(isim: "Gri", emoji: "🐭", renk: Colors.grey),
  ];

  @override
  void initState() {
    super.initState();
    _oyunuBaslat();
  }

  void _oyunuBaslat() {
    // Benzersiz renklere göre gruplama
    Map<String, List<MatchItem>> gruplar = {};
    for (var oge in tumOgeler) {
      if (!gruplar.containsKey(oge.isim)) {
        gruplar[oge.isim] = [];
      }
      gruplar[oge.isim]!.add(oge);
    }

    // 4 farklı renk seçimi
    var renkIsimleri = gruplar.keys.toList()..shuffle();
    var secilenRenkler = renkIsimleri.take(4).toList();

    List<MatchItem> kopyalar = [];
    for (var renk in secilenRenkler) {
      var liste = gruplar[renk]!;
      liste.shuffle();
      var secilenOge = liste.first; // O renkten rastgele bir emoji seç
      
      kopyalar.add(MatchItem(
        isim: secilenOge.isim,
        emoji: secilenOge.emoji,
        renk: secilenOge.renk,
      ));
    }

    hedefler = List.from(kopyalar);
    secenekler = List.from(kopyalar)..shuffle(); // Renkleri karıştır

    setState(() {});
  }

  bool get _oyunBittiMi {
    return hedefler.every((oge) => oge.eslestiMi);
  }

  Future<void> _tebrikEt() async {
    await TtsService().speak("Harika! Hepsini buldun.");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: Text("Tebrikler! 🎉", textAlign: TextAlign.center, style: TextStyle(fontSize: 30, color: Colors.green)),
        content: Text("Tüm renkleri doğru eşleştirdin!", textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            onPressed: () {
              Navigator.pop(context);
              _oyunuBaslat();
            },
            child: Text("Tekrar Oyna", style: TextStyle(fontSize: 20, color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemSize = screenWidth > 600 ? 120 : screenWidth * 0.22;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Üst Bar
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCircleButton(icon: Icons.arrow_back, onTap: () => Navigator.pop(context)),
                  Text("Eşleştirme 🧩", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800)),
                  CustomCircleButton(icon: Icons.refresh, onTap: _oyunuBaslat),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            Text(
              "Renkleri doğru nesnelere sürükle!",
              style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

            // Oyun Alanı
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // SÜRÜKLENECEK RENKLER
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: secenekler.map((secenek) {
                      return Draggable<String>(
                        data: secenek.isim,
                        childWhenDragging: Container(
                          width: itemSize,
                          height: itemSize,
                          decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
                        ),
                        feedback: Material(
                          color: Colors.transparent,
                          child: Container(
                            width: itemSize * 1.1,
                            height: itemSize * 1.1,
                            decoration: BoxDecoration(
                              color: secenek.renk.withOpacity(0.8),
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                            ),
                          ),
                        ),
                        child: secenek.eslestiMi
                            ? Container(
                                width: itemSize,
                                height: itemSize,
                              )
                            : Container(
                                width: itemSize,
                                height: itemSize,
                                decoration: BoxDecoration(
                                  color: secenek.renk,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: secenek.renk.withOpacity(0.5), blurRadius: 8, offset: Offset(0, 4))],
                                ),
                              ),
                      );
                    }).toList(),
                  ),

                  // HEDEFLER (EMOJİLER)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: hedefler.map((hedef) {
                      return DragTarget<String>(
                        builder: (context, incoming, rejected) {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: itemSize,
                            height: itemSize,
                            decoration: BoxDecoration(
                              color: hedef.eslestiMi ? hedef.renk.withOpacity(0.2) : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: incoming.isNotEmpty ? hedef.renk : Colors.grey.shade300,
                                width: incoming.isNotEmpty ? 4 : 2,
                              ),
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                            ),
                            child: Center(
                              child: Text(
                                hedef.emoji,
                                style: TextStyle(fontSize: itemSize * 0.5),
                              ),
                            ),
                          );
                        },
                        onWillAccept: (data) => data == hedef.isim && !hedef.eslestiMi,
                        onAccept: (data) {
                          setState(() {
                            hedef.eslestiMi = true;
                            // Seçenek listesindeki eşini de bulup gizleyelim
                            secenekler.firstWhere((s) => s.isim == hedef.isim).eslestiMi = true;
                          });
                          
                          if (_oyunBittiMi) {
                            _tebrikEt();
                          } else {
                            TtsService().speak("Aferin");
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
