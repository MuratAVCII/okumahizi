import 'package:Hizlanio/Egzersizler/GozEgzersizleri/GozEgzersizleri.dart';
import 'package:Hizlanio/Egzersizler/GozEgzersizleri/NesneTakipRandom.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class YesilSay extends StatefulWidget {
  const YesilSay({Key? key}) : super(key: key);

  @override
  _YesilSayState createState() => _YesilSayState();
}

class _YesilSayState extends State<YesilSay> {
  double _workDuration = 0.5; // in minutes
  double _workSpeed = 1.0; // 1x to 5x
  bool _isWorking = false;
  late int _remainingSeconds;
  late int _totalSeconds;
  Timer? _timer;
  Timer? _movementTimer;
  bool _paused = false;
  int _currentRow = 0;
  int _currentColumn = 0;
  final Random _random = Random();
  int _greenCount = 0;
  int _totalGreenCount = 0;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Show settings dialog automatically when the page is opened
    Future.microtask(() => _showSettingsDialog(context));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final gridWidth = screenWidth * 0.7; // %70 of screen width
    final gridHeight = screenHeight * 0.7; // %70 of screen height
    final cellWidth = gridWidth / 4; // 4x4 grid width
    final cellHeight = gridHeight / 4; // 4x4 grid height

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
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFD5B59C),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: screenHeight * 0.02,
                            bottom: screenHeight * 0.02),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_isWorking) ...[
                              Text(
                                _formatDuration(
                                    Duration(seconds: _remainingSeconds)),
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: gridWidth,
                                height: gridHeight,
                                child: CustomPaint(
                                  painter: GridPainter(
                                      _currentRow,
                                      _currentColumn,
                                      cellWidth,
                                      cellHeight,
                                      _random.nextDouble() < 0.1, () {
                                    _totalGreenCount++;
                                  }),
                                ),
                              ),
                            ],
                            if (_isWorking) ...[
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _paused = true;
                                  });
                                  _showPauseDialog(context);
                                },
                                child: Text('Durdur'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
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
                Center(
                  child: Text(
                    'Bu oyunda, rastgele çıkan kırmızı ve yeşil noktaları gözlerinizle takip etmeniz gerekmektedir.',
                    textAlign: TextAlign.center,
                  ),
                ),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    String formatDuration(double value) {
                      final int totalSeconds = (value * 60).toInt();
                      final int minutes = totalSeconds ~/ 60;
                      final int seconds = totalSeconds % 60;
                      return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 16),
                        Text(
                            'Çalışma Süreniz : ${formatDuration(_workDuration)} Dakika'),
                        Slider(
                          value: _workDuration,
                          min: 0.5,
                          max: 5.0,
                          divisions: 9,
                          label: formatDuration(_workDuration),
                          onChanged: (value) {
                            setState(() {
                              _workDuration = value;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        Text(
                            'Çalışma Hızınız : ${_workSpeed.toStringAsFixed(1)}x'),
                        Slider(
                          value: _workSpeed,
                          min: 1.0,
                          max: 5.0,
                          divisions: 4,
                          label: _workSpeed.toStringAsFixed(1) + 'x',
                          onChanged: (value) {
                            setState(() {
                              _workSpeed = value;
                            });
                          },
                        ),
                      ],
                    );
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
                        _startWork();
                      },
                      child: Text('Çalışmaya Başla'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _startWork() {
    setState(() {
      _isWorking = true;
      _totalSeconds = (_workDuration * 60).toInt();
      _remainingSeconds = _totalSeconds;
      _totalGreenCount = 0;
      _startTimer();
      _startMovement();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_paused && _remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else if (_remainingSeconds <= 0) {
        timer.cancel();
        _stopMovement();
        _showAnswerDialog(context);
      }
    });
  }

  void _stopMovement() {
    _movementTimer?.cancel();
  }

  void _startMovement() {
    _movementTimer?.cancel();
    int movementSpeedMilliseconds = (1000 ~/ _workSpeed).toInt();
    _movementTimer = Timer.periodic(
        Duration(milliseconds: movementSpeedMilliseconds), (timer) {
      if (!_paused) {
        setState(() {
          _currentRow = _random.nextInt(4);
          _currentColumn = _random.nextInt(4);
        });
      }
    });
  }

  void _showPauseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
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
                  'Oyun Durdu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _isWorking = false;
                          _timer?.cancel();
                          _movementTimer?.cancel();
                        });
                        _showAnswerDialog(context);
                      },
                      child: Text('Çalışmayı Bitir'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _paused = false;
                        });
                        _startTimer();
                        _startMovement();
                      },
                      child: Text('Devam Et'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAnswerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Çalışma Bitti'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Kaç tane yeşil renk gördünüz?'),
              TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Rakam giriniz'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (int.tryParse(_textEditingController.text) ==
                    _totalGreenCount) {
                  _showResultDialog(context, true);
                } else {
                  _showResultDialog(context, false);
                }
              },
              child: Text('Gönder'),
            ),
          ],
        );
      },
    );
  }

  void _showResultDialog(BuildContext context, bool isCorrect) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isCorrect ? Colors.green : Colors.red,
          title: Text(isCorrect ? 'Doğru' : 'Yanlış'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isCorrect
                  ? 'Doğru sayıda yeşil renk gördünüz!'
                  : 'Yanlış sayıda yeşil renk gördünüz.'),
              if (!isCorrect)
                Text('Doğru Sayı: $_totalGreenCount',
                    style: TextStyle(color: Colors.white)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Gozegzersizleri()),
                );
              },
              child: Text('Çık'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => YesilSay()),
                );
                _restartWork();
              },
              child: Text('Tekrar Oyna'),
            ),
          ],
        );
      },
    );
  }

  void _restartWork() {
    setState(() {
      _isWorking = true;
      _totalSeconds = (_workDuration * 60).toInt();
      _remainingSeconds = _totalSeconds;
      _totalGreenCount = 0;
      _startTimer();
      _startMovement();
    });
  }

  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class GridPainter extends CustomPainter {
  final int row;
  final int column;
  final double cellWidth;
  final double cellHeight;
  final bool isGreen;
  final VoidCallback onGreen;

  GridPainter(this.row, this.column, this.cellWidth, this.cellHeight,
      this.isGreen, this.onGreen) {
    if (isGreen) {
      onGreen();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isGreen ? Colors.green : Colors.red
      ..style = PaintingStyle.fill;

    final cellOffset = Offset(column * cellWidth, row * cellHeight);

    // Draw the 4x4 grid
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        final offset = Offset(j * cellWidth, i * cellHeight);
        final rect = Rect.fromLTWH(offset.dx, offset.dy, cellWidth, cellHeight);
        final cellPaint = Paint()
          ..color = Colors.black26
          ..style = PaintingStyle.stroke;
        canvas.drawRect(rect, cellPaint);
      }
    }

    // Draw the red or green circle inside the selected cell
    final circleCenter = cellOffset + Offset(cellWidth / 2, cellHeight / 2);
    final circleRadius = min(cellWidth, cellHeight) / 4;
    canvas.drawCircle(circleCenter, circleRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: YesilSay(),
  ));
}
