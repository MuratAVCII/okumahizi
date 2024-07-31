import 'package:Hizlanio/Egzersizler.dart';
import 'package:Hizlanio/girisyap.dart';
import 'package:Hizlanio/hizTesti/hizTesti.dart';
import 'package:Hizlanio/iletisim.dart';
import 'package:Hizlanio/widgets/CustomAppBar.dart';
import 'package:Hizlanio/widgets/CustomEndDrawer.dart';
import 'package:Hizlanio/widgets/full_screen_button.dart'; // Import FullScreenButton
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Hizlanio/Kayitol.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase başlatma hatası: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hızlanio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AnaSayfa(title: 'Ana Sayfa'),
      routes: {
        '/iletisim': (context) => Iletisim(),
        '/girisyap': (context) => Girisyap(),
        '/kayitol': (context) => Kayitol(),
      },
    );
  }
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key, required this.title});

  final String title;

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  double _sliderValue = 10;

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Color.fromARGB(255, 48, 73, 174);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final rowHeight = screenHeight / 10;
    final rowSpacing = screenHeight / 200;
    final sidePadding = screenWidth / 100;
    final maxWidth = 1280.0;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/Arka Plan.png"),
          // Arka plan görseli
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor:
                Colors.transparent, // Scaffold arka planını transparan yap
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(screenHeight / 10),
              child: CustomAppBar(
                sidePadding: sidePadding,
                screenWidth: screenWidth,
                rowHeight: rowHeight,
                actions: [],
              ),
            ),
            endDrawer: CustomEndDrawer(rowHeight: rowHeight),
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
                      // Orta Alan
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(height: screenHeight / 25), // Boşluk
                                Text(
                                  "bİLGİYE HIZ VER",
                                  style: TextStyle(
                                    fontSize: math.min(screenWidth / 12, 90),
                                    color: Colors.white,
                                    fontFamily: 'CustomFont',
                                  ),
                                ),
                                Text(
                                  "OKUMA HIZINIZI TEKNOLOJİ İLE BULUŞTURUN",
                                  style: TextStyle(
                                    fontSize: math.min(screenWidth / 30, 30),
                                    color: Colors.white,
                                    fontFamily: 'CustomFont',
                                  ),
                                ),
                                Text(
                                  "HIZLI OKUMA PLATFORMU",
                                  style: TextStyle(
                                    fontSize: math.min(screenWidth / 40, 20),
                                    color: Colors.white,
                                    fontFamily: 'CustomFont',
                                  ),
                                ),
                                SizedBox(height: screenHeight / 50),
                                // Hız testi Butonu
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: LayoutBuilder(
                                    builder: (BuildContext context,
                                        BoxConstraints constraints) {
                                      double buttonWidth =
                                          constraints.maxWidth < 100
                                              ? 100
                                              : constraints.maxWidth * 0.25;

                                      return IntrinsicWidth(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: buttonWidth,
                                            maxWidth: buttonWidth,
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                    builder: (BuildContext
                                                            context,
                                                        StateSetter setState) {
                                                      return Container(
                                                        height:
                                                            screenHeight / 3,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    20.0),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Spacer(),
                                                            Center(
                                                              child: Container(
                                                                width:
                                                                    screenWidth /
                                                                        10,
                                                                height: 5,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              "Doğru ölçüm yapabilmek için yaşınızı belirtmeniz gerekiyor.",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: math.min(
                                                                    screenHeight /
                                                                        40,
                                                                    36),
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            SliderTheme(
                                                              data: SliderTheme
                                                                      .of(context)
                                                                  .copyWith(
                                                                valueIndicatorTextStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .green, // Aktif etiketin (label) yazı rengi
                                                                ),
                                                                valueIndicatorColor:
                                                                    Colors
                                                                        .blue, // Aktif etiketin arka plan rengi
                                                              ),
                                                              child: Slider(
                                                                value:
                                                                    _sliderValue,
                                                                min: 10,
                                                                max: 20,
                                                                divisions: 10,
                                                                label: _sliderValue
                                                                            .round() >
                                                                        19
                                                                    ? "20+"
                                                                    : _sliderValue
                                                                        .round()
                                                                        .toString(),
                                                                activeColor:
                                                                    Colors
                                                                        .white,
                                                                inactiveColor:
                                                                    Colors
                                                                        .white,
                                                                onChanged:
                                                                    (double
                                                                        value) {
                                                                  setState(() {
                                                                    _sliderValue =
                                                                        value;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            Text(
                                                              'Yaşınız: ${_sliderValue.round() > 19 ? "20+" : _sliderValue.round()}',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    screenHeight /
                                                                        30,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            HizTesti(),
                                                                  ),
                                                                );
                                                              },
                                                              child: Text(
                                                                "Hız ölçümüne başla",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            // Hız Testi Butonu
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.hovered)) {
                                                    return Colors.greenAccent;
                                                  }
                                                  return Colors.green;
                                                },
                                              ),
                                              side: MaterialStateProperty
                                                  .resolveWith<BorderSide>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.hovered)) {
                                                    return BorderSide(
                                                        color: Colors.white,
                                                        width: 2);
                                                  }
                                                  return BorderSide.none;
                                                },
                                              ),
                                              elevation:
                                                  MaterialStateProperty.all(4),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                ),
                                              ),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      screenHeight * 0.02),
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  'HIZ TESTİ',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 30,
                                                    fontFamily: 'CustomFont',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: screenHeight / 50),
                                // Text Başlık
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    "Hızlı Okuma ve Anlama Becerilerinizi Geliştirin !",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: math.min(screenWidth / 30, 30),
                                      color: Colors.blueAccent,
                                      fontFamily: "Arial",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight / 50), // Boşluk
                                // Text Açıklama
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Text(
                                      "HIZLANIO, okuma hızınızı artırmak ve okuduğunuzu daha hızlı kavramak için özel olarak tasarlanmış bir platformdur. HIZLANIO, kullanıcıların okuma becerilerini ölçmek, geliştirmek ve optimize etmek için güçlü bir araç seti sunar.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            math.min(screenWidth / 40, 20),
                                        color: Colors.white,
                                        fontFamily: "Arial",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                // Text Button
                                Center(
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      '"Hizlanio" hakkında daha fazla bilgi almak için burayı tıklayın.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            math.min(screenWidth / 40, 20),
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight / 50),
                      // Alt alan
                      Container(
                        height: screenHeight / 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Egzersizler Butonu
                            Expanded(
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Egzersizler()),
                                    );
                                    print("Egzersizler Butonuna Basıldı");
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered)) {
                                          return Colors.blueAccent;
                                        }
                                        return buttonColor;
                                      },
                                    ),
                                    side: MaterialStateProperty.resolveWith<
                                        BorderSide>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered)) {
                                          return BorderSide(
                                              color: Colors.white, width: 2);
                                        }
                                        return BorderSide.none;
                                      },
                                    ),
                                    elevation: MaterialStateProperty.all(4),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                    ),
                                  ),
                                  child: SizedBox(
                                    height: screenHeight * 0.08,
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'EGZERSİZLER',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontFamily: 'CustomFont',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                width:
                                    sidePadding * 2), // Butonlar arası boşluk
                            // Akıllı Program Butonu
                            Expanded(
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Akıllı Program butonuna basıldığında yapılacak işlemler
                                    print("Akıllı Program Butonuna Basıldı");
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered)) {
                                          return Colors.blueAccent;
                                        }
                                        return buttonColor;
                                      },
                                    ),
                                    side: MaterialStateProperty.resolveWith<
                                        BorderSide>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered)) {
                                          return BorderSide(
                                              color: Colors.white, width: 2);
                                        }
                                        return BorderSide.none;
                                      },
                                    ),
                                    elevation: MaterialStateProperty.all(4),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                    ),
                                  ),
                                  child: SizedBox(
                                    height: screenHeight * 0.08,
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Akıllı Program',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'CustomFont',
                                            fontSize: 30,
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
                      SizedBox(height: screenHeight / 50),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // FullScreenButton widget'ını sağ üst köşeye sabitle
          Positioned(
            top: 100,
            right: 0,
            child: FullScreenButton(),
          ),
        ],
      ),
    );
  }
}
