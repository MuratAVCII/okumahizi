import 'package:Hizlanio/Egzersizler.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/Buyuyenaltigen.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/Buyuyenbesgen.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/Buyuyendortgen.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/Buyuyensekizgen.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/Buyuyenucgen.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/Buyuyenyedigen.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/EightPoint.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/FivePoint.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/FiveStar.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/FourPoint.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/HeptaGram.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/Hexagram.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/NesneTakip.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/NesneTakipRandom.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/SevenPoint.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/SixPoint.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/TrheePoint.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/TwoPointVertical.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/TwoPointHorizontal.dart';
import 'package:Hizlanio/main.dart';
import 'package:Hizlanio/widgets/CustomAppBar.dart';
import 'package:Hizlanio/widgets/custom_end_drawer.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Gozegzersizleri extends StatelessWidget {
  const Gozegzersizleri({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final sidePadding = screenWidth / 100;
    const maxWidth = 1280.0;
    final minButtonWidth = screenWidth / 8;
    final minButtonHeight = screenHeight / 16;
    final rowHeight = screenHeight / 10;

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
        "text": ["Nesne Takip", "[Düzenli]"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NesneTakip()));
        }
      },
      {
        "text": ["Nesne Takip", "[Rastgele]"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NesneTakipRandom()));
        }
      },
      {
        "text": ["NOKTAYI TAKİP ET", "(ÇİZGİ YATAY)"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TwoPointHorizontal()));
        }
      },
      {
        "text": ["NOKTAYI TAKİP ET", "(ÇİZGİ DİKEY)"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TwoPointVertical()));
        }
      },
      {
        "text": ["NOKTAYI TAKİP ET", "ÜÇGEN"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ThreePoint()));
        }
      },
      {
        "text": ["NOKTAYI TAKİP ET", "KARE"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FourPoint()));
        }
      },
      {
        "text": ["NOKTAYI TAKİP ET", "DÜZGÜN BEŞGEN"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FivePoint()));
        }
      },
      {
        "text": ["NOKTAYI TAKİP ET", "DÜZGÜN ALTIGEN"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SixPoint()));
        }
      },
      {
        "text": ["NOKTAYI TAKİP ET", "DÜZGÜN YEDİGEN"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SevenPoint()));
        }
      },
      {
        "text": ["NOKTAYI TAKİP ET", "DÜZGÜN SEKİZGEN"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const EightPoint()));
        }
      },
      {
        "text": ["NOKTAYI TAKİP ET", "Pentegram"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FiveStar()));
        }
      },
      {
        "text": ["NOKTAYI TAKİP ET", "Hexagram"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HexaGram()));
        }
      },
      {
        "text": ["NOKTAYI TAKİP ET", "Heptagram"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HeptaGram()));
        }
      },
      {
        "text": ["BÜYÜYEN ŞEKİLLER", "ÜÇGEN"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Buyuyenucgen()));
        }
      },
      {
        "text": ["BÜYÜYEN ŞEKİLLER", "DÖRTGEN"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Buyuyendortgen()));
        }
      },
      {
        "text": ["BÜYÜYEN ŞEKİLLER", "BEŞGEN"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Buyuyenbesgen()));
        }
      },
      {
        "text": ["BÜYÜYEN ŞEKİLLER", "ALTIGEN"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Buyuyenaltigen()));
        }
      },
      {
        "text": ["BÜYÜYEN ŞEKİLLER", "YEDİGEN"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Buyuyenyedigen()));
        }
      },
      {
        "text": ["BÜYÜYEN ŞEKİLLER", "SEKİZGEN"],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Buyuyensekizgen()));
        }
      },
    ];

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/Arka Plan.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(screenHeight / 10),
              child: CustomAppBar(
                sidePadding: sidePadding,
                screenWidth: screenWidth,
                rowHeight: rowHeight,
                actions: const [],
              ),
            ),
            endDrawer: CustomEndDrawer(rowHeight: rowHeight),
            body: SafeArea(
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
                                              "GÖZ EGZERSİZLERİ",
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
                                                        return Colors.greenAccent
                                                            .withOpacity(0.5);
                                                      }
                                                      return Colors.green
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
                                                      maxLines: 1,
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
        ],
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
