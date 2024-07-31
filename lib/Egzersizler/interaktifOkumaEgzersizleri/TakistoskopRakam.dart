import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class TakistoskopSayi extends StatefulWidget {
  @override
  _TakistoskopSayiState createState() => _TakistoskopSayiState();
}

class _TakistoskopSayiState extends State<TakistoskopSayi> {
  final Random _random = Random();
  final TextEditingController _textEditingController = TextEditingController();
  late int _currentQuestionIndex;
  List<int> _questionLengths = [];
  String _currentNumber = '';
  String _correctAnswer = '';
  int _correctAnswers = 0;
  int _incorrectAnswers = 0;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _showSettingsDialog(context));
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        double _difficulty = 1.0; // Default difficulty level: Kolay
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                constraints: BoxConstraints(maxWidth: 400),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Zorluk Seviyesini Seçin',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Slider(
                      value: _difficulty,
                      min: 1.0,
                      max: 3.0,
                      divisions: 2,
                      label: _difficulty == 1.0
                          ? 'Kolay'
                          : _difficulty == 2.0
                              ? 'Orta'
                              : 'Zor',
                      onChanged: (value) {
                        setState(() {
                          _difficulty = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('Geri Dön'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _startGame(_difficulty);
                          },
                          child: Text('Oyuna Başla'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _startGame(double difficulty) {
    setState(() {
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
      _incorrectAnswers = 0;
      _isGameOver = false;
      _questionLengths = _generateQuestionLengths(difficulty);
    });
    _showNextNumber();
  }

  List<int> _generateQuestionLengths(double difficulty) {
    // 10 questions regardless of difficulty
    if (difficulty == 1.0) {
      return List.generate(6, (_) => 2) + List.generate(4, (_) => 4);
    } else if (difficulty == 2.0) {
      return List.generate(4, (_) => 2) +
          List.generate(3, (_) => 4) +
          List.generate(3, (_) => 6);
    } else {
      return List.generate(3, (_) => 4) +
          List.generate(3, (_) => 6) +
          List.generate(4, (_) => 8);
    }
  }

  void _showNextNumber() {
    if (_currentQuestionIndex >= 10) {
      _isGameOver = true;
      _showResultsDialog();
      return;
    }

    setState(() {
      _currentNumber =
          _generateRandomNumber(_questionLengths[_currentQuestionIndex]);
      _correctAnswer = _currentNumber; // Save the correct answer
    });

    Timer(Duration(milliseconds: 300), () {
      setState(() {
        _currentNumber = '';
      });
      _showInputDialog();
    });
  }

  String _generateRandomNumber(int length) {
    return List.generate(length, (_) => _random.nextInt(10).toString()).join();
  }

  void _checkAnswer() {
    String enteredNumber = _textEditingController.text.trim();

    if (enteredNumber.isEmpty || enteredNumber != _correctAnswer) {
      _incorrectAnswers++;
      _showDialog(
          'Yanlış', Colors.red, 'Doğru Cevap: $_correctAnswer', 'Yanlış Cevap');
    } else {
      _correctAnswers++;
      _showDialog('Doğru', Colors.green, '', 'Doğru Cevap');
    }

    _textEditingController.clear();
  }

  void _showDialog(String title, Color color, String message, String result) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog dışında tıklanarak kapatılmasın
      builder: (context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
          if (_isGameOver) {
            _showResultsDialog();
          } else {
            Future.delayed(Duration(milliseconds: 1500), () {
              _currentQuestionIndex++;
              _showNextNumber();
            });
          }
        });

        return AlertDialog(
          backgroundColor: color,
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (result.isNotEmpty) Text(result),
              if (message.isNotEmpty) Text(message),
            ],
          ),
        );
      },
    );
  }

  void _showInputDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Gördüğünüz sayıyı girin'),
          content: TextField(
            controller: _textEditingController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Sayıyı girin',
            ),
            onSubmitted: (_) {
              Navigator.pop(context);
              _checkAnswer();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _checkAnswer();
              },
              child: Text('Gönder'),
            ),
          ],
        );
      },
    );
  }

  void _showResultsDialog() {
    double successRate = (_correctAnswers / 10) * 100;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Oyun Bitti'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Toplam Soru Sayısı: 10'),
              Text('Doğru Sayısı: $_correctAnswers'),
              Text('Yanlış Sayısı: $_incorrectAnswers'),
              Text('Başarı Oranı: ${successRate.toStringAsFixed(1)}%'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => TakistoskopSayi()));
              },
              child: Text('Tekrar Oyna'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Geri Dön'),
            ),
          ],
        );
      },
    );
  }

  void _restartGame() {
    setState(() {
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
      _incorrectAnswers = 0;
      _isGameOver = false;
    });
    _showSettingsDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/Arka Plan.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.9,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFFD5B59C),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_currentNumber.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentNumber.substring(
                                  0, _currentNumber.length ~/ 2),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                                width: 40), // Aradaki boşluğu artırmak için
                            Text(
                              _currentNumber
                                  .substring(_currentNumber.length ~/ 2),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TakistoskopSayi(),
  ));
}
