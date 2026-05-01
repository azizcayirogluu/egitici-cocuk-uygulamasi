import 'package:flutter/material.dart';
import 'package:floodfill_image/floodfill_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:egitici/widgets/custom_circle_button.dart';

class BoyamaGaleriSayfasi extends StatefulWidget {
  @override
  _BoyamaGaleriSayfasiState createState() => _BoyamaGaleriSayfasiState();
}

class _BoyamaGaleriSayfasiState extends State<BoyamaGaleriSayfasi> {
  final String jsonUrl =
      "https://raw.githubusercontent.com/azizcayirogluu/egitim-uygulamasi-media/main/resimler.json";

  List<String> resimler = [];
  bool yukleniyor = true;

  @override
  void initState() {
    super.initState();
    _resimleriGetir();
  }

  Future<void> _resimleriGetir() async {
    try {
      final response = await http
          .get(Uri.parse(jsonUrl))
          .timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          resimler = data.cast<String>();
          yukleniyor = false;
        });
      } else {
        throw Exception("Yüklenemedi");
      }
    } catch (e) {
      // Hata durumunda (veya internet yoksa) yedek liste:
      setState(() {
        yukleniyor = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Resim Seç 🎨",
          style: TextStyle(
            color: Colors.blueGrey.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade50,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blueGrey),
            onPressed: _resimleriGetir,
          ),
        ],
      ),
      body: yukleniyor
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: GridView.builder(
                padding: EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: resimler.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BoyamaEkrani(resimUrl: resimler[index]),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10),
                        ],
                        border: Border.all(
                          color: Colors.blue.shade100,
                          width: 4,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          resimler[index],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

// --- BOYAMA EKRANI ---
class BoyamaEkrani extends StatefulWidget {
  final String resimUrl;
  BoyamaEkrani({required this.resimUrl});

  @override
  _BoyamaEkraniState createState() => _BoyamaEkraniState();
}

class _BoyamaEkraniState extends State<BoyamaEkrani> {
  Color seciliRenk = Colors.red;
  late Key tuvalKey;

  final List<Color> renkler = [
    Colors.red, Colors.blue, Colors.green, Colors.yellow,
    Colors.orange, Colors.purple, Colors.pink, Colors.brown,
    Colors.white, // Silgi görevi görecek
    Colors.black, Colors.cyan, Colors.lime, Colors.indigo,
    Colors.teal, Colors.amber, Colors.deepOrange, Colors.deepPurple,
    Colors.lightBlue, Colors.lightGreen, Colors.grey,
  ];

  @override
  void initState() {
    super.initState();
    tuvalKey = UniqueKey();
  }

  void _ekraniTemizle() {
    setState(() {
      tuvalKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomCircleButton(
                        icon: Icons.close,
                        iconColor: Colors.red,
                        onTap: () => Navigator.pop(context),
                      ),
                      Text(
                        "Boyama Zamanı 🎨",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                      CustomCircleButton(
                        icon: Icons.refresh,
                        iconColor: Colors.blueGrey,
                        onTap: _ekraniTemizle,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      // Shadow kaldırıldı, alan genişletildi
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: FloodFillImage(
                        key: tuvalKey,
                        imageProvider: NetworkImage(widget.resimUrl),
                        fillColor: seciliRenk,
                        avoidColor: [Colors.black],
                        tolerance: 15,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 90,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: renkler.length,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index) {
                      bool seciliMi = seciliRenk == renkler[index];
                      bool isWhite = renkler[index] == Colors.white;

                      return GestureDetector(
                        onTap: () =>
                            setState(() => seciliRenk = renkler[index]),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: 55,
                          margin: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: seciliMi ? 0 : 10,
                          ),
                          decoration: BoxDecoration(
                            color: renkler[index],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isWhite
                                  ? Colors.grey.shade300
                                  : Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: renkler[index] == Colors.white
                                    ? Colors.black12
                                    : renkler[index].withOpacity(0.4),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: seciliMi
                              ? Icon(
                                  isWhite ? Icons.auto_fix_normal : Icons.brush,
                                  color: isWhite ? Colors.grey : Colors.white,
                                  size: 25,
                                )
                              : (isWhite
                                    ? Icon(
                                        Icons.auto_fix_normal,
                                        color: Colors.grey.shade300,
                                        size: 20,
                                      )
                                    : null),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
