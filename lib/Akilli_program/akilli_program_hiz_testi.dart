import 'dart:async'; // Zamanlayıcı fonksiyonlar için gerekli kütüphane
import 'dart:math'; // Rastgele sayı üretimi için kullanılan kütüphane
import 'package:Hizlanio/Akilli_program/akilli_program_olusmus.dart';
import 'package:Hizlanio/hizTesti/metinlervesorular.dart'; // Metin ve soruların olduğu dosya
import 'package:flutter/material.dart'; // Flutter'ın ana yapısı ve bileşenleri

// Ana HizTesti StatefulWidget
class AkilliProgramHizTesti extends StatefulWidget {
  const AkilliProgramHizTesti({super.key});

  @override
  _AkilliProgramHizTestiState createState() =>
      _AkilliProgramHizTestiState(); // State sınıfı oluşturuluyor
}

class _AkilliProgramHizTestiState extends State<AkilliProgramHizTesti> {
  final double _sliderValue = 0.0; // Slider için kullanılacak başlangıç değeri
  late Timer _timer; // Geri sayım için kullanılacak Timer nesnesi
  int counter = 3; // Geri sayım başlangıç değeri (3 saniye)
  bool showText = false; // Metni göstermek için kullanılan flag
  bool showQuestions = false; // Soruları göstermek için kullanılan flag
  Stopwatch stopwatch = Stopwatch(); // Okuma süresi hesaplamak için kronometre
  Metin? selectedMetin; // Seçilen metni tutan değişken
  int currentQuestionIndex = 0; // Şu anki sorunun indeksi
  List<int> userAnswers = []; // Kullanıcının verdiği cevapları tutan liste

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showCountdownPopup());
    // Ekran oluşturulduktan sonra geri sayım popup'ını göster
  }

  // Geri sayım popup'ı gösteriliyor
  void showCountdownPopup() {
    showDialog(
      context: context,
      barrierDismissible: false, // Popup kapatılamaz
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (counter == 3) {
              // Geri sayım 3'ten başlıyor
              _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                if (counter == 1) {
                  // Geri sayım 1 olduğunda
                  setState(() {
                    counter--; // Counter 0 yapılıyor
                  });
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.of(context).pop(); // Popup kapanıyor
                    setState(() {
                      showText = true; // Metin gösterilmeye başlanıyor
                      stopwatch.start(); // Kronometre başlatılıyor
                      selectedMetin =
                          metinler[Random().nextInt(metinler.length)];
                      // Rastgele bir metin seçiliyor
                    });
                  });
                } else {
                  setState(() {
                    counter--; // Her saniyede counter bir azaltılıyor
                  });
                }
              });
            }
            return AlertDialog(
              backgroundColor: Colors.black87, // Arka plan rengi
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    20.0), // Popup köşeleri yuvarlatılıyor
              ),
              content: SizedBox(
                height: MediaQuery.of(context).size.height /
                    6, // Ekranın %6'sı kadar yükseklik veriliyor
                child: Center(
                  child: Text(
                    counter > 0
                        ? '$counter'
                        : 'Başla!', // Geri sayım veya "Başla!" yazısı gösteriliyor
                    style: const TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      setState(() {});
      if (_timer.isActive) {
        // Eğer geri sayım tamamlandıysa
        _timer.cancel(); // Zamanlayıcı iptal ediliyor
      }
    });
  }

  // Okuma hızı popup'ını gösteren fonksiyon
  void showReadingSpeedPopup(int readingSpeed, int comprehensionScore) {
    String message; // Okuma hızı mesajı için
    if (readingSpeed >= 450) {
      message = "Çok hızlı okuyorsunuz!"; // Eğer hız 450 üzerindeyse
    } else if (readingSpeed >= 200) {
      message =
          "Ortalama bir hızda okuyorsunuz."; // Eğer hız 200 ile 450 arasıysa
    } else {
      message =
          "Daha hızlı okuma yapmalısınız bunun için hemen çalışmaya başlayalım.";
      // Eğer hız 200'den düşükse
    }

    // Okuma hızı popup'ı
    showDialog(
      context: context,
      barrierDismissible: false, // Popup kapatılamaz
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Okuma Hızınız ve Anlama Yüzdeniz"),
          content: Text(
              "Dakikada $readingSpeed kelime okudunuz.\n\n$message\n\nAnlama yüzdeniz: %$comprehensionScore"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Popup kapanıyor
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AkilliProgramOlusmus(
                            title: "Oluşmuş",
                            initialReadingSpeed: readingSpeed)));
              },
              child: const Text("Akıllı Program Oluştur"),
            ),
          ],
        );
      },
    );
  }

  // Okuma tamamlandığında anlama testi popup'ı gösteriliyor
  void showComprehensionTestPrompt() {
    showDialog(
      context: context,
      barrierDismissible: false, // Popup kapatılamaz
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Metni Okumayı Tamamladınız"),
          content: const Text("Şimdi sıra anlama testini çözmede."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Popup kapanıyor
                setState(() {
                  showQuestions = true; // Sorular gösterilmeye başlanıyor
                  currentQuestionIndex = 0; // Soruların indexi sıfırlanıyor
                  userAnswers.clear(); // Kullanıcı cevapları temizleniyor
                });
              },
              child: const Text("Anlama Testine Geç"),
            ),
          ],
        );
      },
    );
  }

  // Okuma bitirildiğinde çağrılan fonksiyon
  void finishReading() {
    stopwatch.stop(); // Kronometre durduruluyor
    setState(() {
      showText = false; // Metin gizleniyor
    });
    showComprehensionTestPrompt(); // Anlama testi popup'ı gösteriliyor
  }

  // Cevaplar gönderildiğinde doğru/yanlış hesaplanıyor
  void submitAnswers() {
    int correctAnswers = 0; // Doğru cevap sayısı
    for (int i = 0; i < selectedMetin!.questions.length; i++) {
      if (userAnswers[i] == selectedMetin!.questions[i].correctAnswerIndex) {
        correctAnswers++; // Kullanıcının verdiği cevap doğruysa artırılıyor
      }
    }
    int comprehensionScore =
        ((correctAnswers / selectedMetin!.questions.length) * 100).round();
    // Anlama yüzdesi hesaplanıyor
    int readingTimeInSeconds =
        stopwatch.elapsed.inSeconds; // Okuma süresi alınıyor
    int wordCount = selectedMetin!.content.split(' ').length; // Kelime sayısı
    int readingSpeed = (wordCount / (readingTimeInSeconds / 60)).round();
    // Dakikada okunan kelime sayısı
    showReadingSpeedPopup(
        readingSpeed, comprehensionScore); // Popup gösteriliyor
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height; // Ekran yüksekliği
    final screenWidth = MediaQuery.of(context).size.width; // Ekran genişliği
    final sidePadding = screenWidth / 100; // Ekranın %1'i kadar yan boşluk
    Color pageColor = const Color(0xFFD5B59C); // Sayfa arka plan rengi

    return Scaffold(
      body: Container(
        width: double.infinity, // Konteyner genişliği
        height: double.infinity, // Konteyner yüksekliği
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/Arka Plan.png"), // Arka plan resmi
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sidePadding * 2, // Yan padding
                vertical: sidePadding * 2, // Dikey padding
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (showText) // Eğer metin gösteriliyorsa
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16.0), // Kenar boşlukları
                        decoration: BoxDecoration(
                          color: pageColor, // Arka plan rengi
                          borderRadius:
                              BorderRadius.circular(20.0), // Köşeleri yuvarlat
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0), // İç boşluklar
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    selectedMetin!.content, // Seçilen metin
                                    style: TextStyle(
                                      fontSize:
                                          screenHeight / 35, // Yazı boyutu
                                      color: Colors.black, // Yazı rengi
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed:
                                    finishReading, // Okumayı bitir butonu
                                child: const Text("Okumayı Bitir"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else if (showQuestions) // Eğer sorular gösteriliyorsa
                    Expanded(
                      child: Center(
                        child: Container(
                          margin:
                              const EdgeInsets.all(16.0), // Kenar boşlukları
                          decoration: BoxDecoration(
                            color: pageColor, // Arka plan rengi
                            borderRadius: BorderRadius.circular(
                                20.0), // Köşeleri yuvarlat
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.all(sidePadding * 2), // İç boşluk
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    selectedMetin!.questions
                                        .length, // Soru sayısı kadar buton oluşturuluyor
                                    (index) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          currentQuestionIndex =
                                              index; // Seçilen soru indexi
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4), // Kenar boşlukları
                                        padding: const EdgeInsets.all(
                                            8), // İç boşluklar
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.circular(
                                              5), // Buton köşeleri yuvarlatılıyor
                                          color: currentQuestionIndex == index
                                              ? Colors
                                                  .blue // Seçilen soru mavi renkte gösteriliyor
                                              : (userAnswers.length > index &&
                                                      userAnswers[index] == -1)
                                                  ? Colors
                                                      .orange // Cevapsız soru turuncu gösteriliyor
                                                  : Colors
                                                      .white, // Diğerleri beyaz
                                        ),
                                        child: Text(
                                          (index + 1)
                                              .toString(), // Soru numarası gösteriliyor
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: currentQuestionIndex ==
                                                        index ||
                                                    (userAnswers.length >
                                                            index &&
                                                        userAnswers[index] ==
                                                            -1)
                                                ? Colors
                                                    .white // Seçilen soru veya cevapsız sorular beyaz yazılıyor
                                                : Colors
                                                    .black, // Diğerleri siyah
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: sidePadding), // Boşluk
                                Text(
                                  "Soru : ${currentQuestionIndex + 1}/${selectedMetin!.questions.length}", // Şu anki soru numarası
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: sidePadding), // Boşluk
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text(
                                          selectedMetin!
                                              .questions[currentQuestionIndex]
                                              .question, // Şu anki soru
                                          textAlign: TextAlign
                                              .center, // Ortalanmış yazı
                                          style: TextStyle(
                                            fontSize: min(screenWidth / 20,
                                                24), // Yazı boyutu
                                            color: Colors.black, // Yazı rengi
                                          ),
                                        ),
                                        SizedBox(height: sidePadding), // Boşluk
                                        Column(
                                          children: selectedMetin!
                                              .questions[currentQuestionIndex]
                                              .options
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int idx = entry
                                                .key; // Seçeneklerin indexi
                                            String text =
                                                entry.value; // Seçeneğin metni
                                            bool isSelected = userAnswers
                                                        .length >
                                                    currentQuestionIndex &&
                                                userAnswers[
                                                        currentQuestionIndex] ==
                                                    idx;
                                            // Kullanıcı seçmiş mi kontrolü
                                            String optionLabel =
                                                String.fromCharCode(65 +
                                                    idx); // Seçenek A, B, C, D olarak gösteriliyor

                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  // Kullanıcı cevap verdiğinde userAnswers güncelleniyor
                                                  while (userAnswers.length <=
                                                      currentQuestionIndex) {
                                                    userAnswers.add(
                                                        -1); // Cevapsız ise -1
                                                  }
                                                  userAnswers[
                                                          currentQuestionIndex] =
                                                      isSelected ? -1 : idx;
                                                  // Seçili cevap değiştirilirse -1, aksi takdirde index atanıyor
                                                });
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical:
                                                            8), // Boşluklar
                                                padding: const EdgeInsets.all(
                                                    12), // İç boşluk
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Köşeleri yuvarlat
                                                  color: isSelected
                                                      ? Colors.blue
                                                      : Colors
                                                          .transparent, // Seçili ise mavi
                                                  border: Border.all(
                                                    color: Colors
                                                        .white, // Beyaz kenarlık
                                                  ),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "$optionLabel) ", // A, B, C, D yazısı
                                                      style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold, // Kalın yazı
                                                        fontSize: min(
                                                            screenWidth / 20,
                                                            18), // Yazı boyutu
                                                        color: isSelected
                                                            ? Colors.black
                                                            : Colors
                                                                .black, // Seçili ise siyah
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        text, // Seçenek metni
                                                        style: TextStyle(
                                                          fontSize: min(
                                                              screenWidth / 20,
                                                              18), // Yazı boyutu
                                                          color: isSelected
                                                              ? Colors.black
                                                              : Colors
                                                                  .black, // Siyah yazı
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: sidePadding), // Boşluk
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: currentQuestionIndex > 0
                                            ? () {
                                                setState(() {
                                                  currentQuestionIndex--; // Geri git butonu
                                                });
                                              }
                                            : null,
                                        icon: const Icon(
                                          Icons.arrow_back, // Geri buton ikonu
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          "", // Boş metin
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 16), // Buton boyutu
                                          backgroundColor:
                                              currentQuestionIndex > 0
                                                  ? Colors.blue
                                                  : Colors.grey,
                                          // Sorular varsa mavi, yoksa gri
                                        ),
                                      ),
                                    ),
                                    const Spacer(), // Araya boşluk koyar
                                    Expanded(
                                      child: Center(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              // Kullanıcı tüm soruları cevapladıysa submitAnswers fonksiyonunu çağır
                                              while (userAnswers.length <
                                                  selectedMetin!
                                                      .questions.length) {
                                                userAnswers.add(
                                                    -1); // Cevapsız sorular için -1 ekle
                                              }
                                              bool allQuestionsAnswered =
                                                  true; // Tüm sorular cevaplandı mı?
                                              List<int> unansweredQuestions =
                                                  []; // Cevapsız soruların listesi

                                              for (int i = 0;
                                                  i <
                                                      selectedMetin!
                                                          .questions.length;
                                                  i++) {
                                                if (userAnswers[i] == -1) {
                                                  allQuestionsAnswered =
                                                      false; // Eğer boş soru varsa false yap
                                                  unansweredQuestions.add(i +
                                                      1); // Boş soruları listeye ekle
                                                }
                                              }

                                              if (!allQuestionsAnswered) {
                                                // Eğer boş soru varsa uyarı göster
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: const Text("Uyarı"),
                                                    content: Text(
                                                        "Lütfen tüm soruları cevaplayınız. Eksik sorular: ${unansweredQuestions.join(", ")}"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Uyarı popup'ını kapat
                                                        },
                                                        child:
                                                            const Text("Tamam"),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                submitAnswers(); // Tüm sorular cevaplandıysa cevapları gönder
                                              }
                                            });
                                          },
                                          icon: Icon(
                                            Icons
                                                .check, // Testi bitir buton ikonu
                                            color: Colors.white,
                                            size: (screenWidth / 50)
                                                .clamp(0.0, 20), // Buton boyutu
                                          ),
                                          label: Text(
                                            "Testi Bitir", // Testi bitir metni
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: (screenWidth / 50)
                                                  .clamp(
                                                      0.0, 20), // Yazı boyutu
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16,
                                                horizontal: 16), // Buton boyutu
                                            backgroundColor: Colors
                                                .green, // Buton arka planı yeşil
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(), // Araya boşluk koyar
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: currentQuestionIndex <
                                                selectedMetin!
                                                        .questions.length -
                                                    1
                                            ? () {
                                                setState(() {
                                                  currentQuestionIndex++; // İleri git butonu
                                                });
                                              }
                                            : null,
                                        icon: const Icon(
                                          Icons
                                              .arrow_forward, // İleri buton ikonu
                                          color: Colors.white,
                                        ),
                                        label: const Text("",
                                            style: TextStyle(
                                                color:
                                                    Colors.white)), // Boş metin
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 16), // Buton boyutu
                                          backgroundColor:
                                              currentQuestionIndex <
                                                      selectedMetin!.questions
                                                              .length -
                                                          1
                                                  ? Colors.blue
                                                  : Colors.grey,
                                          // Sorular varsa mavi, yoksa gri
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
