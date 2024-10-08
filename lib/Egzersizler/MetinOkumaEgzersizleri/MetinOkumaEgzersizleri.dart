import 'package:Hizlanio/Egzersizler.dart';
import 'package:Hizlanio/Egzersizler/MetinOkumaEgzersizleri/Acilanmetin.dart';
import 'package:Hizlanio/Egzersizler/MetinOkumaEgzersizleri/BoyananKelimeler.dart';
import 'package:Hizlanio/Egzersizler/MetinOkumaEgzersizleri/Kirmizi.dart';
import 'package:Hizlanio/Egzersizler/MetinOkumaEgzersizleri/Ortadacikankelimeler.dart';
import 'package:Hizlanio/Egzersizler/MetinOkumaEgzersizleri/KaybolanKelimeler.dart';
import 'package:Hizlanio/Egzersizler/MetinOkumaEgzersizleri/RastgeleKelime.dart';
import 'package:Hizlanio/Egzersizler/MetinOkumaEgzersizleri/VurgulananKelimeler.dart';
import 'package:Hizlanio/main.dart';
import 'package:Hizlanio/widgets/CustomAppBar.dart';
import 'package:Hizlanio/widgets/custom_end_drawer.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class MetinOkumaEgzersizleri extends StatelessWidget {
  const MetinOkumaEgzersizleri({super.key});

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
        "text": ["AÇILAN KELİMELERİ OKU", ""],
        "onPressed": () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AcilanMetin()));
        }
      },
      {
        "text": ["BOYANAN KELİMELERİ OKU", ""],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BoyananKelimeler()));
        }
      },
      {
        "text": ["Kaybolan KELİMELERİ OKU", ""],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const KaybolanKelimeler()));
        }
      },
      {
        "text": ["Vurgulanan KELİMELERİ OKU", ""],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const VurgulananKelimeler()));
        }
      },
      {
        "text": ["Ortada Çıkan KELİMELERİ OKU", ""],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const OrtadaCikanKelime()));
        }
      },
      {
        "text": ["Rastgele Yerlerde Çıkan KELİMELERİ OKU", ""],
        "onPressed": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RastgeleCikanKelime()));
        }
      },
      {
        "text": ["Kırmızıya Odaklan Çıkan KELİMELERİ OKU", ""],
        "onPressed": () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Kirmizi()));
        }
      },
      // Diğer butonlar için benzer yapı devam eder...
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
                                          "METİN OKUMA EGZERSİZLERİ",
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
                                                    return Colors.orangeAccent
                                                        .withOpacity(0.5);
                                                  }
                                                  return Colors.orange
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
      ),],),
    );
  }
}



// Diğer Page sınıfları için benzer yapı devam eder...
