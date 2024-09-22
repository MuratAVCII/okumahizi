import 'package:Hizlanio/widgets/CustomAppBar.dart';
import 'package:Hizlanio/widgets/custom_end_drawer.dart';
import 'package:Hizlanio/widgets/full_screen_button.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class AkilliProgramOlusmus extends StatefulWidget {
  final int initialReadingSpeed; // Okuma hızı dışarıdan alınacak
  const AkilliProgramOlusmus(
      {super.key, required this.title, required this.initialReadingSpeed});

  final String title;

  @override
  State<AkilliProgramOlusmus> createState() => _AkilliProgramOlusmusState();
}

class _AkilliProgramOlusmusState extends State<AkilliProgramOlusmus> {
  int selectedDay = 1; // Seçilen gün numarası
  Set<int> completedDays = {}; // Tamamlanmış günler listesi

  @override
  Widget build(BuildContext context) {
    int initialReadingSpeed =
        widget.initialReadingSpeed; // Okuma hızı dışarıdan alınıyor
    int targetSpeed = (initialReadingSpeed * 1.5)
        as int; // Hedef okuma hızı, mevcut hızın 1.5 katı

    // Hedefe yaklaşma adımları
    double dailyIncrement = (targetSpeed - initialReadingSpeed) / 30;

    Color buttonColor = const Color.fromARGB(255, 48, 73, 174); // Buton rengi
    final screenHeight = MediaQuery.of(context).size.height; // Ekran yüksekliği
    final rowHeight = screenHeight / 10; // Satır yüksekliği
    final screenWidth = MediaQuery.of(context).size.width; // Ekran genişliği
    const maxWidth = 1280.0; // Maksimum genişlik
    final sidePadding = screenWidth / 100; // Yan boşluk

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/Arka Plan.png"), // Arka plan görseli
          fit: BoxFit.cover, // Görsel tam ekranı kaplayacak şekilde ayarlanıyor
        ),
      ),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(screenHeight / 10), // AppBar yüksekliği
              child: CustomAppBar(
                sidePadding: sidePadding, // Yan boşluk
                screenWidth: screenWidth, // Ekran genişliği
                rowHeight: rowHeight, // Satır yüksekliği
                actions: const [], // AppBar'daki aksiyonlar
              ),
            ),
            endDrawer:
                CustomEndDrawer(rowHeight: rowHeight), // End drawer ekleniyor
            body: SafeArea(
              child: Center(
                child: Container(
                  width: screenWidth > maxWidth
                      ? maxWidth
                      : screenWidth - 2 * sidePadding,
                  padding: EdgeInsets.symmetric(horizontal: sidePadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight / 50),

                      // Okuma Hızınız ve Hedefiniz
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black38, // Arka plan yarı transparan
                            borderRadius: BorderRadius.circular(
                                20.0), // Köşeleri yuvarlatılmış
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: screenHeight / 25), // Boşluk
                              Text(
                                "bİLGİYE HIZ VER", // Ana başlık
                                style: TextStyle(
                                  fontSize: math.min(screenWidth / 12,
                                      90), // Dinamik font boyutu
                                  color: Colors.white, // Yazı rengi
                                  fontFamily: 'CustomFont', // Özel font
                                ),
                              ),
                              Text(
                                "OKUMA HIZINIZI TEKNOLOJİ İLE BULUŞTURUN", // Alt başlık
                                style: TextStyle(
                                  fontSize: math.min(screenWidth / 30,
                                      30), // Dinamik font boyutu
                                  color: Colors.white, // Yazı rengi
                                  fontFamily: 'CustomFont', // Özel font
                                ),
                              ),
                              Text(
                                "HIZLI OKUMA PLATFORMU", // Tanımlama metni
                                style: TextStyle(
                                  fontSize: math.min(screenWidth / 40,
                                      20), // Dinamik font boyutu
                                  color: Colors.white, // Yazı rengi
                                  fontFamily: 'CustomFont', // Özel font
                                ),
                              ),
                              SizedBox(height: screenHeight / 50), // Boşluk
                              // Text Başlık
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0), // Yan boşluk
                                child: Text(
                                  "Yapay Zeka Destekli Akıllı Program", // Başlık metni
                                  textAlign:
                                      TextAlign.center, // Yazı ortalanıyor
                                  style: TextStyle(
                                    fontSize: math.min(screenWidth / 30,
                                        30), // Dinamik font boyutu
                                    color: Colors.blueAccent, // Yazı rengi
                                    fontFamily: "Arial", // Font tipi
                                    fontWeight: FontWeight.bold, // Kalın font
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight / 50), // Boşluk

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Okuma Hızınız: $initialReadingSpeed /dk",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "$initialReadingSpeed /dk", // Altında okuma hızının aynısı gösteriliyor
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Hedef: $targetSpeed /dk",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight / 50), // Boşluk
                              // Günler Butonları (30 adet)
                              Container(
                                height: screenHeight / 10,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 30,
                                  itemBuilder: (context, index) {
                                    int day = index + 1;
                                    bool isCompleted =
                                        completedDays.contains(day);
                                    double currentSpeed = initialReadingSpeed +
                                        (day - 1) * dailyIncrement;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (day == 1 ||
                                              completedDays.contains(day - 1)) {
                                            setState(() {
                                              selectedDay = day;
                                            });
                                          } else {
                                            _showIncompleteDayDialog(day - 1);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: selectedDay == day
                                                ? Colors.green
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Gün $day',
                                                style: TextStyle(
                                                  color: selectedDay == day
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Text(
                                                "${currentSpeed.toStringAsFixed(0)} /dk",
                                                style: TextStyle(
                                                  color: selectedDay == day
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight / 50),
                      // "X. Gün Çalışmasına Başla" Butonu
                      ElevatedButton(
                        onPressed: completedDays.contains(selectedDay - 1) ||
                                selectedDay == 1
                            ? () {
                                _showDayStartDialog();
                              }
                            : null,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors
                                    .blueAccent; // Hover durumunda mavi renk
                              }
                              return Colors.green; // Normal durumda yeşil renk
                            },
                          ),
                          side: MaterialStateProperty.resolveWith<BorderSide>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return const BorderSide(
                                    color: Colors.white,
                                    width: 2); // Beyaz kenarlık
                              }
                              return BorderSide.none; // Kenarlık yok
                            },
                          ),
                          elevation:
                              MaterialStateProperty.all(4), // Buton yüksekliği
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  16.0), // Buton köşeleri yuvarlatılıyor
                            ),
                          ),
                        ),
                        child: SizedBox(
                          height: screenHeight *
                              0.08, // Buton yüksekliği ayarlanıyor
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "$selectedDay. Gün Çalışmasına Başla",
                              style: const TextStyle(
                                color: Colors.white, // Yazı rengi
                                fontFamily: 'CustomFont', // Özel font
                                fontSize: 30, // Yazı boyutu
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight / 50), // Boşluk
                    ],
                  ),
                ),
              ),
            ),
          ),
          // FullScreenButton widget'ını sağ üst köşeye sabitle
          const Positioned(
            top: 100,
            right: 0,
            child: FullScreenButton(), // Full ekran butonu
          ),
        ],
      ),
    );
  }

  // Çalışmaya başlama diyaloğu
  void _showDayStartDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("$selectedDay. Gün Çalışmasına Başla"),
          content:
              const Text("Çalışmayı tamamladığınızda tamamla butonuna basın."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dialogu kapat
              },
              child: const Text("Geri"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  completedDays.add(
                      selectedDay); // Seçilen gün tamamlanmış olarak işaretlenir
                });
                Navigator.pop(context); // Dialogu kapat
              },
              child: const Text("Tamamla"),
            ),
          ],
        );
      },
    );
  }

  // Önceki gün tamamlanmadıysa uyarı diyaloğu
  void _showIncompleteDayDialog(int previousDay) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Uyarı"),
          content: Text(
              "Bir sonraki güne geçebilmek için $previousDay. günü tamamlamalısınız."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dialogu kapat
              },
              child: const Text("Geri"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedDay = previousDay; // Önceki güne yönlendirilir
                });
                Navigator.pop(context); // Dialogu kapat
              },
              child: Text("$previousDay. Güne Başla"),
            ),
          ],
        );
      },
    );
  }
}
