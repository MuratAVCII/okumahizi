import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class NesneTakip extends StatefulWidget {
  const NesneTakip({super.key});

  @override
  _NesneTakipState createState() => _NesneTakipState();
}

class _NesneTakipState extends State<NesneTakip> {
  double _workDuration = 0.5; // in minutes
  double _workSpeed = 1.0; // 1x to 5x
  bool _isWorking = false;
  late int _remainingSeconds;
  late int _totalSeconds;
  Timer? _timer;
  Timer? _movementTimer;
  bool _paused = false;
  final List<int> _moveSequence = []; // Sequence for movement
  int _currentIndex = 0; // Index for current movement in sequence
  //final Random _random = Random();

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
        decoration: const BoxDecoration(
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
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5B59C),
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
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: gridWidth,
                                height: gridHeight,
                                child: CustomPaint(
                                  painter: GridPainter(
                                      _moveSequence[_currentIndex],
                                      cellWidth,
                                      cellHeight),
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
                                child: const Text('Durdur'),
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
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'Bu oyunda, kırmızı noktayı gözlerinizle takip etmeniz gerekmektedir.',
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
                        const SizedBox(height: 16),
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
                        const SizedBox(height: 16),
                        Text(
                            'Çalışma Hızınız : ${_workSpeed.toStringAsFixed(1)}x'),
                        Slider(
                          value: _workSpeed,
                          min: 1.0,
                          max: 5.0,
                          divisions: 4,
                          label: '${_workSpeed.toStringAsFixed(1)}x',
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
                      child: const Text('Geri Dön'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _startWork();
                      },
                      child: const Text('Çalışmaya Başla'),
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
      _generateMoveSequence();
      _startTimer();
      _startMovement();
    });
  }

  void _generateMoveSequence() {
    _moveSequence.clear();
    // Left to right
    for (int col = 0; col < 4; col++) {
      for (int row = 0; row < 4; row++) {
        _moveSequence.add(row * 4 + col);
      }
    }
    // Down
    for (int row = 1; row < 4; row++) {
      for (int col = 3; col >= 0; col--) {
        _moveSequence.add(row * 4 + col);
      }
    }
    // Right to left
    for (int col = 0; col < 4; col++) {
      for (int row = 3; row >= 0; row--) {
        _moveSequence.add(row * 4 + col);
      }
    }
    // Down
    for (int row = 1; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        _moveSequence.add(row * 4 + col);
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_paused && _remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else if (_remainingSeconds <= 0) {
        timer.cancel();
        _stopMovement();
        _showGameOverDialog(context);
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
          _currentIndex++;
          if (_currentIndex >= _moveSequence.length) {
            _currentIndex = 0;
          }
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
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Oyun Durdu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
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
                        _showGameOverDialog(context);
                      },
                      child: const Text('Çalışmayı Bitir'),
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
                      child: const Text('Devam Et'),
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

  void _showGameOverDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
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
                  'Çalışma Bitti!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Toplam Geçen Süre: ${_formatDuration(Duration(seconds: _totalSeconds))}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                Text(
                  'Çalışma Hızınız: ${_workSpeed.toStringAsFixed(1)}x',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _restartWork();
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _restartWork() {
    setState(() {
      _isWorking = true;
      _totalSeconds = (_workDuration * 60).toInt();
      _remainingSeconds = _totalSeconds;
      _currentIndex = 0;
      _startTimer();
      _startMovement();
    });
  }

  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _movementTimer?.cancel();
    super.dispose();
  }
}

class GridPainter extends CustomPainter {
  final int position;
  final double cellWidth;
  final double cellHeight;

  GridPainter(this.position, this.cellWidth, this.cellHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Calculate current row and column
    int row = position ~/ 4;
    int col = position % 4;

    final cellOffset = Offset(col * cellWidth, row * cellHeight);

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

    // Draw the red circle inside the selected cell
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
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NesneTakip(),
  ));
}
