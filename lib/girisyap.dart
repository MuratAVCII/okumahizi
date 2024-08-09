import 'package:Hizlanio/widgets/CustomAppBar.dart';
import 'package:Hizlanio/widgets/custom_end_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Kayitol.dart';
import 'main.dart';
import 'dart:math' as math;

class Girisyap extends StatelessWidget {
  const Girisyap({super.key});

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final rowHeight = screenHeight / 10;
    final sidePadding = screenWidth / 100;
    const maxWidth = 1280.0;

    double getResponsiveTextSize() {
      if (screenWidth < 600) {
        return rowHeight * 0.15; // Küçük ekranlar için daha küçük metin boyutu
      } else {
        return rowHeight *
            0.2; // Daha büyük ekranlar için daha büyük metin boyutu
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
        body: Container(
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
                                                    const AnaSayfa(
                                                        title: "title")));
                                      },
                                    ),
                                    Text(
                                      "GİRİŞ YAP",
                                      style: TextStyle(
                                          fontSize:
                                              math.min(screenWidth / 25, 36),
                                          color: Colors.white,
                                          fontFamily: 'CustomFont'),
                                    ),
                                    SizedBox(width: screenWidth / 50),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: EdgeInsets.all(screenWidth / 50),
                                child: Column(
                                  children: [
                                    const TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Kullanıcı Adı',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                      ),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(height: screenHeight / 50),
                                    const TextField(
                                      decoration: InputDecoration(
                                        labelText: 'E-Posta',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                      ),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(height: screenHeight / 50),
                                    const TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Şifre',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                      ),
                                      obscureText: true,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(height: screenHeight / 50),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Giriş yap butonuna basıldığında yapılacak işlemler
                                      },
                                      child: const Text('Giriş Yap'),
                                    ),
                                    SizedBox(height: screenHeight / 50),
                                    ElevatedButton(
                                      onPressed: () {
                                        signInWithGoogle();
                                      },
                                      child: const Text('Google ile Giriş Yap'),
                                    ),
                                    SizedBox(height: screenHeight / 50),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Kayitol()),
                                        );
                                      },
                                      child: const Text(
                                        'Hesabınız yok mu? Kayıt Ol',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer()
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
      ),
    );
  }
}
