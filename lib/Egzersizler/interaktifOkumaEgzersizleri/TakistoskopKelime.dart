import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class TakistoskopKelime extends StatefulWidget {
  const TakistoskopKelime({super.key});

  @override
  _TakistoskopKelimeState createState() => _TakistoskopKelimeState();
}

class _TakistoskopKelimeState extends State<TakistoskopKelime> {
  final Random _random = Random();
  final TextEditingController _textEditingController = TextEditingController();
  late int _currentQuestionIndex;
  final List<String> _words = [
    'ELMA',
    'ARMUT',
    'MÜZİK',
    'BİLGİSAYAR',
    'KALEM',
    'DEFTER',
    'KİTAP',
    'TELEFON',
    'KAMERA',
    'ÇANTA'
  ];
  String _currentWord = '';
  String _correctAnswer = '';
  int _correctAnswers = 0;
  int _incorrectAnswers = 0;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    setState(() {
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
      _incorrectAnswers = 0;
      _isGameOver = false;
    });
    _showNextWord();
  }

  void _showNextWord() {
    if (_currentQuestionIndex >= 10) {
      _isGameOver = true;
      _showResultsDialog();
      return;
    }

    setState(() {
      _currentWord = _words[_random.nextInt(_words.length)];
      _correctAnswer = _currentWord; // Save the correct answer
    });

    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        _currentWord = '';
      });
      _showInputDialog();
    });
  }

  void _checkAnswer() {
    String enteredWord = _textEditingController.text.trim().toUpperCase();

    if (enteredWord.isEmpty || enteredWord != _correctAnswer) {
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
              _showNextWord();
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
          title: const Text('Gördüğünüz kelimeyi girin'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Kelimeyi girin',
            ),
            textCapitalization: TextCapitalization.characters,
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TakistoskopKelime()));
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
    _showNextWord();
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
            child: Container(
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
                  if (_currentWord.isNotEmpty)
                    Text(
                      _currentWord,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
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
    home: TakistoskopKelime(),
  ));
}
