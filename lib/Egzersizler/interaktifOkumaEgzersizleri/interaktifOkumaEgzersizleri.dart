import 'package:Hizlanio/Egzersizler.dart';
import 'package:Hizlanio/Egzersizler/interaktifOkumaEgzersizleri/TakistoskopHarf.dart';
import 'package:Hizlanio/Egzersizler/interaktifOkumaEgzersizleri/TakistoskopKelime.dart';
import 'package:Hizlanio/Egzersizler/interaktifOkumaEgzersizleri/TakistoskopRakam.dart';
import 'package:Hizlanio/Egzersizler/interaktifOkumaEgzersizleri/TekCift.dart';
import 'package:Hizlanio/Egzersizler/interaktifOkumaEgzersizleri/Yesilsay.dart';
import 'package:Hizlanio/main.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class interaktifOkumaEgzersizleri extends StatelessWidget {
  const interaktifOkumaEgzersizleri({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final sidePadding = screenWidth / 100;
    const maxWidth = 1280.0;
    final minButtonWidth = screenWidth / 8;
    final minButtonHeight = screenHeight / 16;
    const Color.fromARGB(255, 48, 73, 174);

    int crossAxisCount = screenWidth < 700
        ? 2
        : screenWidth < 900
            ? 3
            : screenWidth < 1200
                ? 4
                : 4;

    // Buton metinlerini ve yönlendirme işlemlerini içeren liste
    final List<Map<String, dynamic>> buttonList = [
      {
        "text": ["YEŞİL SİMGELERİ SAY", ""],
        "onPressed": () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const YesilSay()));
        }
      },
      {
        "text": ["Takistoskop", "RAKAM"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TakistoskopSayi()));
        }
      },
      {
        "text": ["Takistoskop", "HARF"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TakistoskopHarf()));
        }
      },
      {
        "text": ["Takistoskop", "KELİME"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TakistoskopKelime()));
        }
      },
      {
        "text": ["Tek Çiftleri Bul", ""],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TekleriCiftleriBul()));
        }
      },

      // Diğer butonlar için benzer yapı devam eder...
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/Arka Plan.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: sidePadding),
              child: Container(
                width: screenWidth > maxWidth
                    ? maxWidth
                    : screenWidth - 2 * sidePadding,
                padding: EdgeInsets.symmetric(horizontal: sidePadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: sidePadding),
                            child: Image.asset(
                              'images/Group 1774.png',
                              height: MediaQuery.of(context).size.height / 10,
                            ),
                          ),
                          Visibility(
                            visible: screenWidth > 600,
                            child: Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AnaSayfa(title: "title")));
                                    },
                                    child: Text("Anasayfa",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text("İletişim",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text("Premium",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.01),
                            child: DropdownButton<String>(
                              icon: const Icon(Icons.arrow_drop_down),
                              iconEnabledColor: Colors.white,
                              underline: const SizedBox(),
                              items: <String>['Giriş yap', 'Kayıt ol']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (_) {},
                              hint: Row(
                                children: [
                                  Text(
                                    "Giriş yap",
                                    style: TextStyle(
                                        fontSize:
                                            math.min(screenWidth / 25, 36),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight / 50),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: screenHeight / 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  SizedBox(height: screenHeight / 50),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: sidePadding, right: sidePadding),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.arrow_back),
                                          iconSize: screenWidth * 0.05,
                                          disabledColor: Colors.white,
                                          color: Colors.white,
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Egzersizler()),
                                            );
                                          },
                                        ),
                                        Text(
                                          "İNTERAKTİF OKUMA EGZERSİZLERİ",
                                          style: TextStyle(
                                            fontSize:
                                                math.min(screenWidth / 25, 36),
                                            color: Colors.white,
                                            fontFamily: 'CustomFont',
                                          ),
                                        ),
                                        SizedBox(width: screenWidth / 100)
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight / 50),
                                ],
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: sidePadding,
                                        vertical: sidePadding),
                                    child: GridView.count(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: screenWidth / 40,
                                      mainAxisSpacing: screenHeight / 40,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      children: List.generate(buttonList.length,
                                          (index) {
                                        return MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: ElevatedButton(
                                            onPressed: buttonList[index]
                                                ["onPressed"],
                                            style: ButtonStyle(
                                              minimumSize:
                                                  MaterialStateProperty.all(
                                                Size(minButtonWidth,
                                                    minButtonHeight),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.hovered)) {
                                                    return Colors.blueAccent
                                                        .withOpacity(0.5);
                                                  }
                                                  return Colors.blue
                                                      .withOpacity(0.5);
                                                },
                                              ),
                                              side: MaterialStateProperty
                                                  .resolveWith<BorderSide>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.hovered)) {
                                                    return const BorderSide(
                                                      color: Colors.white,
                                                      width: 2,
                                                    );
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
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  buttonList[index]["text"][0],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          minButtonHeight / 4,
                                                      fontFamily: 'CustomFont'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  buttonList[index]["text"][1],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          minButtonHeight / 4,
                                                      fontFamily: 'CustomFont'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 1'),
      ),
      body: const Center(
        child: Text('Page 1 Content'),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 2'),
      ),
      body: const Center(
        child: Text('Page 2 Content'),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 3'),
      ),
      body: const Center(
        child: Text('Page 3 Content'),
      ),
    );
  }
}

// Diğer Page sınıfları için benzer yapı devam eder...
