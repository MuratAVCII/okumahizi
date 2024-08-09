import 'package:Hizlanio/Egzersizler/GozEgzersizleri/GozEgzersizleri.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class FiveStar extends StatefulWidget {
  const FiveStar({super.key});

  @override
  _FiveStarState createState() => _FiveStarState();
}

class _FiveStarState extends State<FiveStar> {
  double _workDuration = 0.5; // in minutes
  double _workSpeed = 1.0; // 1x to 5x
  bool _isWorking = false;
  double _rotation = 0.0;
  late int _remainingSeconds;
  late int _totalSeconds;
  Timer? _timer;
  Timer? _rotationTimer;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    // Show settings dialog automatically when the page is opened
    Future.microtask(() => _showSettingsDialog(context));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sidePadding = screenWidth / 100;
    final screenHeight = MediaQuery.of(context).size.height;
    Color pageColor = const Color(0xFFD5B59C);

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
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sidePadding * 2,
                vertical: sidePadding * 2,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: pageColor,
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
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                CustomPaint(
                                  size: Size(
                                      screenHeight * 0.50, screenHeight * 0.50),
                                  painter: PentagramPainter(
                                      _rotation, screenWidth, screenHeight),
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
                    'İki nokta takip çalışmasında, başınızı sabit tutup gözlerinizle kırmızı noktaları takip etmeniz gerekmektedir.',
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
      _rotation = 0.0;
      _startTimer();
      _startRotation();
    });
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
        _stopRotation();
        _showGameOverDialog(context);
      }
    });
  }

  void _stopRotation() {
    _rotationTimer?.cancel();
  }

  void _startRotation() {
    _rotationTimer?.cancel();
    int rotationSpeedMilliseconds = (1000 ~/ _workSpeed).toInt();
    int totalRotations = 5; // Toplam döngü sayısı
    int currentRotationCount = 0;
    bool isPositiveRotation = true; // İlk dönüş yönü (saat yönünde)

    _rotationTimer = Timer.periodic(
        Duration(milliseconds: rotationSpeedMilliseconds), (timer) {
      if (!_paused) {
        setState(() {
          if (isPositiveRotation) {
            _rotation += 2 * math.pi / 2.5; // 90 derece dönüş
          } else {
            _rotation -= 2 * math.pi / 2.5; // -90 derece dönüş
          }

          if (_rotation >= 2 * math.pi) {
            _rotation -= 2 * math.pi; // Döngüyü sıfırla
            currentRotationCount++;

            if (currentRotationCount >= totalRotations) {
              isPositiveRotation = !isPositiveRotation; // Yönü tersine çevir
              currentRotationCount = 0;
            }
          } else if (_rotation <= -2 * math.pi) {
            _rotation += 2 * math.pi; // Negatif döngüyü sıfırla
            currentRotationCount++;

            if (currentRotationCount >= totalRotations) {
              isPositiveRotation = !isPositiveRotation; // Yönü tersine çevir
              currentRotationCount = 0;
            }
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
                          _rotationTimer?.cancel();
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
                        _startRotation();
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
    String elapsedTime =
        _formatDuration(Duration(seconds: _totalSeconds - _remainingSeconds));

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400), // Max genişlik sınırı
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'Oyun Bitti',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Geçen Süre: $elapsedTime'),
                Text('Çalışma Hızı: ${_workSpeed.toStringAsFixed(1)}x'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Gozegzersizleri()),
                        ); // Go back to the previous page
                      },
                      child: const Text('Geri Dön'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const FiveStar()),
                        ); // Restart the game
                      },
                      child: const Text('Tekrar Oyna'),
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

class PentagramPainter extends CustomPainter {
  final double rotation;
  final double screenWidth;
  final double screenHeight;

  PentagramPainter(this.rotation, this.screenWidth, this.screenHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final redDotPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    double pentagonSize = size.width;
    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);

    Path pentagramPath = Path();
    for (int i = 0; i < 5; i++) {
      double angle = (math.pi / 2 + i * 4 * math.pi / 5);
      if (i == 0) {
        pentagramPath.moveTo(center.dx + pentagonSize * math.cos(angle) / 2,
            center.dy - pentagonSize * math.sin(angle) / 2);
      } else {
        pentagramPath.lineTo(center.dx + pentagonSize * math.cos(angle) / 2,
            center.dy - pentagonSize * math.sin(angle) / 2);
      }
    }
    pentagramPath.close();

    canvas.drawPath(pentagramPath, paint);

    final double dotRadius = screenHeight / 50;
    final Offset redDotPosition = Offset(
      center.dx + pentagonSize * math.cos(math.pi / 2) / 2,
      center.dy - pentagonSize * math.sin(math.pi / 2) / 2,
    );

    canvas.drawCircle(redDotPosition, dotRadius, redDotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

void main() {
  runApp(const MaterialApp(
    home: FiveStar(),
  ));
}
