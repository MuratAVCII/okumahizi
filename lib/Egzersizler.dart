import 'package:Hizlanio/Egzersizler/GozEgzersizleri/GozEgzersizleri.dart';
import 'package:Hizlanio/Egzersizler/KelimeOkumaEgzersizleri/KelimeOkumaEgzersizleri.dart';
import 'package:Hizlanio/Egzersizler/MetinOkumaEgzersizleri/MetinOkumaEgzersizleri.dart';
import 'package:Hizlanio/Egzersizler/interaktifOkumaEgzersizleri/interaktifOkumaEgzersizleri.dart';
import 'package:Hizlanio/main.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:Hizlanio/widgets/CustomAppBar.dart';
import 'package:Hizlanio/widgets/custom_end_drawer.dart';

class Egzersizler extends StatelessWidget {
  const Egzersizler({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final rowHeight = screenHeight / 10;
    final sidePadding = screenWidth / 100;
    const maxWidth = 1280.0;
    // ignore: unused_local_variable
    Color buttonColor = const Color.fromARGB(255, 48, 73, 174);

    double getResponsiveTextSize() {
      if (screenWidth < 600) {
        return rowHeight * 0.15; // Küçük ekranlar için daha küçük metin boyutu
      } else {
        return rowHeight *
            0.2; // Daha büyük ekranlar için daha büyük metin boyutu
      }
    }

    double getResponsiveIconSize() {
      if (screenWidth < 600) {
        return rowHeight * 0.4; // Küçük ekranlar için daha küçük ikon boyutu
      } else {
        return rowHeight *
            0.5; // Daha büyük ekranlar için daha büyük ikon boyutu
      }
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/Arka Plan.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight / 10),
          child: Center(
            child: CustomAppBar(
              sidePadding: sidePadding,
              screenWidth: screenWidth,
              rowHeight: rowHeight,
              actions: const [],
            ),
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                                const AnaSayfa(title: "title")),
                                      );
                                    },
                                  ),
                                  Text(
                                    "EGZERSİZLER",
                                    style: TextStyle(
                                      fontSize: math.min(screenWidth / 25, 36),
                                      color: Colors.white,
                                      fontFamily: 'CustomFont',
                                    ),
                                  ),
                                  SizedBox(width: screenWidth / 50),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight / 50),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: sidePadding,
                                          right: sidePadding),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Gozegzersizleri()),
                                            );
                                            print(
                                                "GÖZ EGZERSİZLERİ Butonuna Basıldı");
                                          },
                                          style: ButtonStyle(
                                            minimumSize:
                                                MaterialStateProperty.all(Size(
                                                    double.infinity,
                                                    rowHeight)),
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
                                                  return const BorderSide(
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
                                                    BorderRadius.circular(16.0),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                Icons.energy_savings_leaf,
                                                color: Colors.white,
                                                size: getResponsiveIconSize(),
                                              ),
                                              SizedBox(
                                                  width: screenWidth / 100),
                                              Flexible(
                                                child: Text(
                                                  'GÖZ EGZERSİZLERİ',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        getResponsiveTextSize(),
                                                    fontFamily: 'CustomFont',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  width: screenWidth / 100),
                                              SizedBox(
                                                  width: screenWidth / 100),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight / 50),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: sidePadding,
                                          right: sidePadding),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            print(
                                                "Kelime OKUMA EGZERSİZLERİ Butonuna Basıldı");
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const KelimeOkumaEgzersizleri()),
                                            );
                                          },
                                          style: ButtonStyle(
                                            minimumSize:
                                                MaterialStateProperty.all(Size(
                                                    double.infinity,
                                                    rowHeight)),
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.hovered)) {
                                                  return Colors.redAccent;
                                                }
                                                return Colors.red;
                                              },
                                            ),
                                            side: MaterialStateProperty
                                                .resolveWith<BorderSide>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.hovered)) {
                                                  return const BorderSide(
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
                                                    BorderRadius.circular(16.0),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                Icons.energy_savings_leaf,
                                                color: Colors.white,
                                                size: getResponsiveIconSize(),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'KELİME OKUMA EGZERSİZLERİ',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        getResponsiveTextSize(),
                                                    fontFamily: 'CustomFont',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  width: screenWidth / 100),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight / 50),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: sidePadding,
                                          right: sidePadding),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            print(
                                                "Metin Okuma  EGZERSİZLERİ Butonuna Basıldı");
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MetinOkumaEgzersizleri()),
                                            );
                                          },
                                          style: ButtonStyle(
                                            minimumSize:
                                                MaterialStateProperty.all(Size(
                                                    double.infinity,
                                                    rowHeight)),
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.hovered)) {
                                                  return Colors.orangeAccent;
                                                }
                                                return Colors.orange;
                                              },
                                            ),
                                            side: MaterialStateProperty
                                                .resolveWith<BorderSide>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.hovered)) {
                                                  return const BorderSide(
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
                                                    BorderRadius.circular(16.0),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                Icons.energy_savings_leaf,
                                                color: Colors.white,
                                                size: getResponsiveIconSize(),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'METİN OKUMA EGZERSİZLERİ',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        getResponsiveTextSize(),
                                                    fontFamily: 'CustomFont',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  width: screenWidth / 100),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight / 50),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: sidePadding,
                                          right: sidePadding),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            print(
                                                "İNTERAKTİF EGZERSİZLER Butonuna Basıldı");
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const interaktifOkumaEgzersizleri()),
                                            );
                                          },
                                          style: ButtonStyle(
                                            minimumSize:
                                                MaterialStateProperty.all(Size(
                                                    double.infinity,
                                                    rowHeight)),
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.hovered)) {
                                                  return Colors.blueAccent;
                                                }
                                                return Colors.blue;
                                              },
                                            ),
                                            side: MaterialStateProperty
                                                .resolveWith<BorderSide>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.hovered)) {
                                                  return const BorderSide(
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
                                                    BorderRadius.circular(16.0),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                Icons.energy_savings_leaf,
                                                color: Colors.white,
                                                size: getResponsiveIconSize(),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'İNTERAKTİF EGZERSİZLER',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        getResponsiveTextSize(),
                                                    fontFamily: 'CustomFont',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  width: screenWidth / 100),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight / 50),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight / 25),
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
