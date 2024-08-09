import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class TekleriCiftleriBul extends StatefulWidget {
  const TekleriCiftleriBul({super.key});

  @override
  _TekleriCiftleriBulState createState() => _TekleriCiftleriBulState();
}

class _TekleriCiftleriBulState extends State<TekleriCiftleriBul> {
  double _workDuration = 1.0; // Default duration in minutes
  int? _remainingSeconds;
  int? _totalSeconds;
  Timer? _timer;
  bool _isGameOver = false;
  int _correctAnswers = 0;
  bool _isEvenRound = true; // To track whether it's an even or odd round
  final Random _random = Random();
  int _gridSize = 4; // Initial grid size
  List<List<int>>? _numbers; // Grid of numbers
  List<List<bool>>? _selected; // Grid of selected states
  bool _paused = false;
  bool _gameStarted = false; // To track whether the game has started

  @override
  void initState() {
    super.initState();
    _remainingSeconds = 0; // Initialize remaining seconds to 0
    // Showing settings dialog automatically when the page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSettingsDialog(context);
    });
  }

  // Function to show settings dialog
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // To prevent dialog from closing when tapping outside
      builder: (context) {
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
                      'Çalışma Sürenizi Seçin',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                        'Çalışma Süreniz : ${(_workDuration).toStringAsFixed(1)} Dakika'),
                    Slider(
                      value: _workDuration,
                      min: 0.5,
                      max: 5.0,
                      divisions: 9,
                      label: '${(_workDuration).toStringAsFixed(1)} Dakika',
                      onChanged: (value) {
                        setState(() {
                          _workDuration = value;
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
                            _startGame();
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

  // Function to start the game
  void _startGame() {
    setState(() {
      _gameStarted = true;
      _totalSeconds = (_workDuration * 60).toInt();
      _remainingSeconds = _totalSeconds;
      _correctAnswers = 0;
      _isGameOver = false;
      _paused = false;
      _gridSize = 4;
      _generateNumbers();
    });
    _startTimer();
  }

  // Function to start the timer
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_paused && _remainingSeconds! > 0) {
        setState(() {
          _remainingSeconds = _remainingSeconds! - 1;
        });
      } else if (_remainingSeconds! <= 0) {
        timer.cancel();
        _showGameOverDialog();
      }
    });
  }

  // Function to generate numbers for the grid
  void _generateNumbers() {
    _numbers =
        List.generate(_gridSize, (_) => List.generate(_gridSize, (_) => 0));
    _selected =
        List.generate(_gridSize, (_) => List.generate(_gridSize, (_) => false));

    List<int> correctIndices = [];
    while (correctIndices.length < 4) {
      int index = _random.nextInt(_gridSize * _gridSize);
      if (!correctIndices.contains(index)) {
        correctIndices.add(index);
      }
    }

    for (int i = 0; i < _gridSize; i++) {
      for (int j = 0; j < _gridSize; j++) {
        int number = 1000 + _random.nextInt(9000);
        if (_isEvenRound && correctIndices.contains(i * _gridSize + j)) {
          while (number % 2 != 0) {
            number = 1000 + _random.nextInt(9000);
          }
        } else if (!_isEvenRound &&
            correctIndices.contains(i * _gridSize + j)) {
          while (number % 2 == 0) {
            number = 1000 + _random.nextInt(9000);
          }
        } else {
          while (_isEvenRound ? number % 2 == 0 : number % 2 != 0) {
            number = 1000 + _random.nextInt(9000);
          }
        }
        _numbers![i][j] = number;
      }
    }
    setState(() {});
  }

  // Function to check the answer
  void _checkAnswer(int i, int j) {
    if (!_selected![i][j]) {
      setState(() {
        bool isCorrect =
            _isEvenRound ? _numbers![i][j] % 2 == 0 : _numbers![i][j] % 2 != 0;
        if (isCorrect) {
          _selected![i][j] = true;
          _correctAnswers++;
          if (_correctAnswers % 4 == 0) {
            _isEvenRound = !_isEvenRound;
            _gridSize++;
            _generateNumbers();
          }
        }
      });
    }
  }

  // Function to show game over dialog
  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Oyun Bitti'),
          content: Text(
              'Çalışma süreniz bitti. Doğru cevap sayınız: $_correctAnswers'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TekleriCiftleriBul()),
                );
              },
              child: const Text('Tekrar Oyna'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Çık'),
            ),
          ],
        );
      },
    );
  }

  // Function to show pause dialog
  void _showPauseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Oyun Durdu'),
          content: const Text(
              'Oyunu durdurdunuz. Çıkmak mı yoksa devam etmek mi istiyorsunuz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _paused = false;
                });
                _startTimer();
              },
              child: const Text('Devam Et'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isGameOver = true;
                });
                _showGameOverDialog();
              },
              child: const Text('Çık'),
            ),
          ],
        );
      },
    );
  }

  // Helper function to format duration
  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * 0.9;
    double containerHeight = MediaQuery.of(context).size.height * 0.9;
    double gridHeight = containerHeight * 0.8;
    double gridWidth = containerWidth * 0.8;
    double spacing = 4.0;

    double buttonHeight = (gridHeight - (_gridSize - 1) * spacing) / _gridSize;
    double buttonWidth = (gridWidth - (_gridSize - 1) * spacing) / _gridSize;
    double fontSize =
        max(buttonHeight * 0.4, 12.0); // Minimum font size is 12.0

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
              width: containerWidth,
              height: containerHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFD5B59C),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: _gameStarted
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          _formatDuration(
                              Duration(seconds: _remainingSeconds ?? 0)),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _isEvenRound
                              ? 'Çift Sayıları Bul'
                              : 'Tek Sayıları Bul',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Doğru Cevap Sayısı: $_correctAnswers',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: gridWidth,
                          height: gridHeight,
                          alignment: Alignment.center,
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _gridSize,
                              mainAxisSpacing: spacing,
                              crossAxisSpacing: spacing,
                              childAspectRatio: buttonWidth / buttonHeight,
                            ),
                            itemBuilder: (context, index) {
                              int row = index ~/ _gridSize;
                              int col = index % _gridSize;
                              return SizedBox(
                                width: buttonWidth,
                                height: buttonHeight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: ElevatedButton(
                                    onPressed: () => _checkAnswer(row, col),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: _selected?[row][col] ??
                                              false
                                          ? Colors.green
                                          : Colors
                                              .blue, // Set text color for selected button
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            12.0), // Oval kenar için
                                      ),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '${_numbers?[row][col] ?? ''}',
                                        style: TextStyle(fontSize: fontSize),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: _gridSize * _gridSize,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _paused = true;
                            });
                            _showPauseDialog(context);
                          },
                          child: const Text('Durdur'),
                        ),
                      ],
                    )
                  : Container(),
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
    home: TekleriCiftleriBul(),
  ));
}
