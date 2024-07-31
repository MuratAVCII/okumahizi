import 'package:Hizlanio/girisyap.dart';
import 'package:Hizlanio/widgets/CustomAppBar.dart';
import 'package:Hizlanio/widgets/CustomEndDrawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main.dart';
import 'dart:math' as math;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';

class Iletisim extends StatefulWidget {
  const Iletisim({Key? key}) : super(key: key);

  @override
  _IletisimState createState() => _IletisimState();
}

class _IletisimState extends State<Iletisim> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _surname = '';
  String _email = '';
  String _phone = '';
  String _userType = 'Öğrenci';
  String _subject = '';
  String _message = '';
  int _messageLength = 0;

  Future<void> _sendEmail() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Burada e-posta gönderme işlemini gerçekleştirin.
      // Örneğin, bir e-posta gönderme API'sini çağırabilirsiniz.

      // E-posta gönderme işleminin başarılı olduğunu varsayalım:
      bool emailSent = true;

      if (emailSent) {
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('İletildi')),
          content: Text(
              'Mesajınız başarıyla gönderildi. En kısa sürede sizlere geri dönüş yapılacaktır.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dialogu kapat
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AnaSayfa(title: "title")),
                );
              },
              child: Text('Anasayfaya Dön'),
            ),
          ],
        );
      },
    );
  }

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
    final maxWidth = 1280.0;

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
      decoration: BoxDecoration(
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
              actions: [],
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
                          child: Form(
                            key: _formKey,
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
                                        icon: Icon(Icons.arrow_back),
                                        iconSize: screenWidth * 0.05,
                                        disabledColor: Colors.white,
                                        color: Colors.white,
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AnaSayfa(
                                                          title: "title")));
                                        },
                                      ),
                                      Text(
                                        "İLETİŞİM",
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
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.all(screenWidth / 50),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'Ad',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              style: TextStyle(
                                                  color: Colors.white),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Lütfen adınızı girin';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _name = value!;
                                              },
                                            ),
                                          ),
                                          SizedBox(width: screenWidth / 50),
                                          Expanded(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'Soyad',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              style: TextStyle(
                                                  color: Colors.white),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Lütfen soyadınızı girin';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _surname = value!;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight / 50),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'E-Posta',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              style: TextStyle(
                                                  color: Colors.white),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              validator: (value) {
                                                if (!EmailValidator.validate(
                                                    value!)) {
                                                  return 'Yanlış bir e-posta adresi belirttiniz';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _email = value!;
                                              },
                                            ),
                                          ),
                                          SizedBox(width: screenWidth / 50),
                                          Expanded(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'Telefon Numarası',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              style: TextStyle(
                                                  color: Colors.white),
                                              keyboardType: TextInputType.phone,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                _PhoneNumberFormatter(),
                                              ],
                                              validator: (value) {
                                                // Burada telefon numarasının formatını kontrol ediyoruz
                                                String pattern =
                                                    r'^\(0\d{3}\) \d{3}-\d{2}-\d{2}$';
                                                RegExp regExp = RegExp(pattern);
                                                if (!regExp.hasMatch(value!)) {
                                                  return 'Geçerli bir telefon numarası girin';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _phone = value!;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight / 50),
                                      DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Kullanıcı Türü',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        dropdownColor: Colors.black,
                                        style: TextStyle(color: Colors.white),
                                        value: _userType,
                                        items: ['Öğrenci', 'Öğretmen']
                                            .map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value,
                                                style: TextStyle(
                                                    color: Colors.grey)),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _userType = newValue!;
                                          });
                                        },
                                      ),
                                      SizedBox(height: screenHeight / 50),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Konu',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
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
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Lütfen konuyu girin';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _subject = value!;
                                        },
                                      ),
                                      SizedBox(height: screenHeight / 50),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText:
                                              'Belirtmek istediğiniz metni yazınız',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          counterStyle: TextStyle(
                                              color: Colors
                                                  .white), // Karakter sayacı stilini belirler
                                        ),
                                        style: TextStyle(color: Colors.white),
                                        maxLines: null,
                                        maxLength: 1000,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Lütfen mesajınızı girin';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            _messageLength = value.length;
                                          });
                                        },
                                        onSaved: (value) {
                                          _message = value!;
                                        },
                                      ),
                                      SizedBox(height: screenHeight / 50),
                                      ElevatedButton(
                                        onPressed: _sendEmail,
                                        child: Text('Mesajımı İlet'),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
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

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (text.length > 11) {
      text = text.substring(0, 11);
    }

    String formattedText = '';

    if (text.length >= 1) {
      formattedText += '(0';
    }
    if (text.length >= 4) {
      formattedText += text.substring(1, 4) + ') ';
    } else if (text.length > 1) {
      formattedText += text.substring(1);
    }
    if (text.length >= 7) {
      formattedText += text.substring(4, 7);
    } else if (text.length > 4) {
      formattedText += text.substring(4);
    }
    if (text.length >= 9) {
      formattedText += '-' + text.substring(7, 9);
    } else if (text.length > 7) {
      formattedText += '-' + text.substring(7);
    }
    if (text.length >= 11) {
      formattedText += '-' + text.substring(9, 11);
    } else if (text.length > 9) {
      formattedText += '-' + text.substring(9);
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Iletisim(),
  ));
}
