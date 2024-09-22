import 'package:Hizlanio/Akilli_program/akilli_program_hiz_testi.dart';
import 'package:Hizlanio/Egzersizler.dart'; // Egzersizler sayfasını import ediyor
import 'package:Hizlanio/girisyap.dart'; // Giriş yap sayfasını import ediyor
import 'package:Hizlanio/hizTesti/hizTesti.dart'; // Hız testi sayfasını import ediyor
import 'package:Hizlanio/iletisim.dart'; // İletişim sayfasını import ediyor
import 'package:Hizlanio/widgets/CustomAppBar.dart'; // Özel AppBar widget'ını import ediyor
import 'package:Hizlanio/widgets/custom_end_drawer.dart'; // Özel end drawer'ı import ediyor
import 'package:Hizlanio/widgets/full_screen_button.dart'; // FullScreenButton widget'ını import ediyor
import 'package:flutter/material.dart'; // Flutter'ın ana bileşenlerini import ediyor
import 'package:Hizlanio/Kayitol.dart'; // Kayıt ol sayfasını import ediyor
import 'dart:math'
    as math; // Math kütüphanesi, özellikle ekran boyutu hesaplamaları için kullanılıyor
import 'package:firebase_core/firebase_core.dart'; // Firebase'i başlatmak için gerekli kütüphane

// Uygulamanın ana fonksiyonu
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Flutter işlemlerini başlatmadan önce gerekli bağlamaları yapar
  try {
    await Firebase.initializeApp(); // Firebase başlatma işlemi
  } catch (e) {
    print(
        'Firebase başlatma hatası: $e'); // Firebase başlatma hatası durumunda konsola hata mesajı basılıyor
  }
  runApp(const MyApp()); // Uygulama başlatılıyor
}

// Uygulamanın ana widget'ı
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Debug banner'ını kaldırıyor
      title: 'Okuma Hizi', // Uygulama başlığı
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Renk teması
        useMaterial3: true, // Material 3 desteği
      ),
      home: const AkilliProgram(
          title: 'Ana Sayfa'), // Ana sayfa widget'ı yükleniyor
      routes: {
        '/iletisim': (context) =>
            const Iletisim(), // İletişim sayfası yönlendirmesi
        '/girisyap': (context) =>
            const Girisyap(), // Giriş yap sayfası yönlendirmesi
        '/kayitol': (context) =>
            const Kayitol(), // Kayıt ol sayfası yönlendirmesi
      },
    );
  }
}

// Ana sayfa Stateful widget
class AkilliProgram extends StatefulWidget {
  const AkilliProgram({super.key, required this.title});

  final String title;

  @override
  State<AkilliProgram> createState() =>
      _AkilliProgramState(); // State sınıfı oluşturuluyor
}

// Ana sayfa state sınıfı
class _AkilliProgramState extends State<AkilliProgram> {
  double _sliderValue = 10; // Yaş seçimi slider'ının başlangıç değeri

  @override
  Widget build(BuildContext context) {
    Color buttonColor = const Color.fromARGB(255, 48, 73, 174); // Buton rengi

    final screenHeight = MediaQuery.of(context).size.height; // Ekran yüksekliği
    final screenWidth = MediaQuery.of(context).size.width; // Ekran genişliği
    final rowHeight = screenHeight / 10; // Satır yüksekliği
    final rowSpacing = screenHeight / 200; // Satır arası boşluk
    final sidePadding = screenWidth / 100; // Yan boşluk
    const maxWidth = 1280.0; // Maksimum genişlik

    return Container(
      width: double.infinity, // Genişlik ekran boyutuna göre ayarlanıyor
      height: double.infinity, // Yükseklik ekran boyutuna göre ayarlanıyor
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/Arka Plan.png"), // Arka plan görseli
          fit: BoxFit.cover, // Görsel tam ekranı kaplayacak şekilde ayarlanıyor
        ),
      ),
      child: Stack(
        // Ekran üstüne widget'lar yerleştirilir
        children: [
          Scaffold(
            backgroundColor:
                Colors.transparent, // Scaffold arka planı transparan yapılıyor
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
              // Ekran alanına yerleşiyor
              child: Center(
                child: Container(
                  width: screenWidth > maxWidth
                      ? maxWidth // Ekran genişliği maks. genişlikten büyükse sabit genişlik
                      : screenWidth -
                          2 * sidePadding, // Aksi durumda ekran genişliği
                  padding: EdgeInsets.symmetric(
                      horizontal: sidePadding), // Yan padding
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight / 50), // Boşluk
                      // Orta Alan
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black38, // Arka plan yarı transparan
                            borderRadius: BorderRadius.circular(
                                20.0), // Köşeleri yuvarlatılmış
                          ),
                          child: SingleChildScrollView(
                            // Kaydırılabilir içerik
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Ortaya hizalanmış
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                // Text Açıklama
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0), // Yan boşluk
                                    child: Text(
                                      "OkumaHızı, okuma hızınızı artırmak ve okuduğunuzu daha hızlı kavramak için özel olarak tasarlanmış bir platformdur. HIZLANIO, kullanıcıların okuma becerilerini ölçmek, geliştirmek ve optimize etmek için güçlü bir araç seti sunar.", // Açıklama metni
                                      textAlign:
                                          TextAlign.center, // Yazı ortalanıyor
                                      style: TextStyle(
                                        fontSize: math.min(screenWidth / 40,
                                            20), // Dinamik font boyutu
                                        color: Colors.white, // Yazı rengi
                                        fontFamily: "Arial", // Font tipi
                                        fontWeight:
                                            FontWeight.bold, // Kalın font
                                      ),
                                    ),
                                  ),
                                ),
                                // Text Button
                                Center(
                                  child: TextButton(
                                    // Bilgi butonu
                                    onPressed:
                                        () {}, // Tıklanma olayı henüz tanımlanmamış
                                    child: Text(
                                      '"Hizlanio" hakkında daha fazla bilgi almak için burayı tıklayın.', // Buton metni
                                      style: TextStyle(
                                        fontWeight:
                                            FontWeight.bold, // Kalın font
                                        fontSize: math.min(screenWidth / 40,
                                            20), // Dinamik font boyutu
                                        color: Colors.orange, // Yazı rengi
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight / 50), // Boşluk
                      // Alt alan
                      SizedBox(
                        height: screenHeight / 10, // Alt alan yüksekliği
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceEvenly, // Eşit boşluklarla dağıtılmış butonlar
                          children: [
                            // Egzersizler Butonu
                            // Akıllı Program Butonu
                            Expanded(
                              child: MouseRegion(
                                // Akıllı Program butonuna tıklanabilir işaretçi efekti
                                cursor: SystemMouseCursors
                                    .click, // İşaretçi değişikliği
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Butona tıklandığında alt panel açılıyor
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          // Alt panel state yönetimi
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return Container(
                                              height: screenHeight /
                                                  3, // Alt panel yüksekliği
                                              decoration: const BoxDecoration(
                                                color: Colors
                                                    .green, // Alt panel arka planı
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(
                                                      20.0), // Yuvarlak üst köşeler
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceEvenly, // İçerik arası boşluklar
                                                children: [
                                                  const Spacer(), // Boşluk
                                                  Center(
                                                    child: Container(
                                                      width: screenWidth /
                                                          10, // Üstteki beyaz çizgi genişliği
                                                      height:
                                                          5, // Beyaz çizgi yüksekliği
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .white, // Çizgi rengi
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                4), // Çizgi köşeleri yuvarlatılıyor
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Doğru ölçüm yapabilmek için yaşınızı belirtmeniz gerekiyor.", // Alt panel metni
                                                    style: TextStyle(
                                                      color: Colors
                                                          .white, // Yazı rengi
                                                      fontSize: math.min(
                                                          screenHeight / 40,
                                                          36), // Dinamik font boyutu
                                                    ),
                                                    textAlign: TextAlign
                                                        .center, // Yazı ortalanıyor
                                                  ),
                                                  SliderTheme(
                                                    // Yaş seçimi slider teması
                                                    data:
                                                        SliderTheme.of(context)
                                                            .copyWith(
                                                      valueIndicatorTextStyle:
                                                          const TextStyle(
                                                        color: Colors
                                                            .green, // Etiket yazı rengi
                                                      ),
                                                      valueIndicatorColor: Colors
                                                          .blue, // Etiket arka plan rengi
                                                    ),
                                                    child: Slider(
                                                      // Yaş slider'ı
                                                      value:
                                                          _sliderValue, // Slider'ın mevcut değeri
                                                      min: 10, // Minimum yaş
                                                      max: 20, // Maksimum yaş
                                                      divisions: 10, // Bölümler
                                                      label: _sliderValue
                                                                  .round() >
                                                              19
                                                          ? "20+" // 20'den büyükse "20+" göster
                                                          : _sliderValue
                                                              .round()
                                                              .toString(), // Diğer durumlarda yaş göster
                                                      activeColor: Colors
                                                          .white, // Aktif slider rengi
                                                      inactiveColor: Colors
                                                          .white, // Pasif slider rengi
                                                      onChanged:
                                                          (double value) {
                                                        setState(() {
                                                          _sliderValue =
                                                              value; // Slider değeri güncelleniyor
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Text(
                                                    'Yaşınız: ${_sliderValue.round() > 19 ? "20+" : _sliderValue.round()}', // Yaş gösterimi
                                                    style: TextStyle(
                                                      fontSize: screenHeight /
                                                          30, // Dinamik font boyutu
                                                      color: Colors
                                                          .white, // Yazı rengi
                                                    ),
                                                  ),
                                                  const Spacer(), // Boşluk
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // "Hız ölçümüne başla" butonu
                                                      Navigator.pop(
                                                          context); // Alt paneli kapatıyor
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AkilliProgramHizTesti(), // Hız testi sayfasına yönlendirme
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                      "Hız ölçümüne başla", // Buton metni
                                                      style: TextStyle(
                                                          color: Colors
                                                              .green), // Yazı rengi
                                                    ),
                                                  ),
                                                  const Spacer(), // Boşluk
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  style: ButtonStyle(
                                    // Buton stil ayarları
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered)) {
                                          return Colors
                                              .blueAccent; // Hover durumunda mavi renk
                                        }
                                        return buttonColor; // Normal durumda varsayılan renk
                                      },
                                    ),
                                    side: MaterialStateProperty.resolveWith<
                                        BorderSide>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered)) {
                                          return const BorderSide(
                                              color: Colors.white,
                                              width:
                                                  2); // Hover durumunda beyaz kenarlık
                                        }
                                        return BorderSide
                                            .none; // Normal durumda kenarlık yok
                                      },
                                    ),
                                    elevation: MaterialStateProperty.all(
                                        4), // Buton yüksekliği
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
                                    child: const Center(
                                      child: FittedBox(
                                        // İç metni ölçeklendiriyor
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Akıllı Program Oluşturmaya Başla', // Buton metni
                                          textAlign: TextAlign
                                              .center, // Yazı ortalanıyor
                                          style: TextStyle(
                                            color: Colors.white, // Yazı rengi
                                            fontFamily:
                                                'CustomFont', // Özel font
                                            fontSize: 30, // Yazı boyutu
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
}
