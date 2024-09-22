import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class TakistoskopHarf extends StatefulWidget {
  const TakistoskopHarf({super.key});

  @override
  _TakistoskopHarfState createState() => _TakistoskopHarfState();
}

class _TakistoskopHarfState extends State<TakistoskopHarf> {
  final Random _random = Random();
  final TextEditingController _textEditingController = TextEditingController();
  late int _currentQuestionIndex;
  List<int> _questionLengths = [];
  String _currentString = '';
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
      barrierDismissible: false, // Dialog dışına tıklayınca kapanmayı engeller
      builder: (context) {
        double difficulty = 1.0; // Default difficulty level: Kolay
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Zorluk Seviyesini Seçin',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: difficulty,
                      min: 1.0,
                      max: 3.0,
                      divisions: 2,
                      label: difficulty == 1.0
                          ? 'Kolay'
                          : difficulty == 2.0
                              ? 'Orta'
                              : 'Zor',
                      onChanged: (value) {
                        setState(() {
                          difficulty = value;
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
                          child: const Text('Geri Dön'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _startGame(difficulty);
                          },
                          child: const Text('Oyuna Başla'),
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
    _showNextString();
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

  void _showNextString() {
    if (_currentQuestionIndex >= 10) {
      _isGameOver = true;
      _showResultsDialog();
      return;
    }

    setState(() {
      _currentString =
          _generateRandomString(_questionLengths[_currentQuestionIndex]);
      _correctAnswer = _currentString; // Save the correct answer
    });

    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _currentString = '';
      });
      _showInputDialog();
    });
  }

  String _generateRandomString(int length) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(
        length, (_) => letters[_random.nextInt(letters.length)]).join();
  }

  void _checkAnswer() {
    String enteredString = _textEditingController.text.trim().toUpperCase();

    if (enteredString.isEmpty || enteredString != _correctAnswer) {
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
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
          if (_isGameOver) {
            _showResultsDialog();
          } else {
            Future.delayed(const Duration(milliseconds: 1500), () {
              _currentQuestionIndex++;
              _showNextString();
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
          title: const Text('Gördüğünüz harfleri girin'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Harfleri girin',
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
              child: const Text('Gönder'),
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
          title: const Text('Oyun Bitti'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Toplam Soru Sayısı: 10'),
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
                    MaterialPageRoute(builder: (context) => const TakistoskopHarf()));
              },
              child: const Text('Tekrar Oyna'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Geri Dön'),
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
        decoration: const BoxDecoration(
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
                    color: const Color(0xFFD5B59C),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_currentString.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentString.substring(
                                  0, _currentString.length ~/ 2),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                                width: 40), // Aradaki boşluğu artırmak için
                            Text(
                              _currentString
                                  .substring(_currentString.length ~/ 2),
                              style: const TextStyle(
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
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TakistoskopHarf(),
  ));
}
