import 'package:Hizlanio/Egzersizler/GozEgzersizleri/GozEgzersizleri.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class Buyuyenaltigen extends StatefulWidget {
  const Buyuyenaltigen({super.key});

  @override
  _BuyuyenaltigenState createState() => _BuyuyenaltigenState();
}

class _BuyuyenaltigenState extends State<Buyuyenaltigen> {
  double _workDuration = 0.5; // in minutes
  double _workSpeed = 1.0; // 1x to 5x
  bool _isWorking = false;
  late int _remainingSeconds;
  late int _totalSeconds;
  Timer? _timer;
  Timer? _sizeTimer;
  bool _paused = false;
  double _hexagonScale = 0.1; // initial scale

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
                                      screenHeight * 0.50 * _hexagonScale,
                                      screenHeight * 0.50 * _hexagonScale),
                                  painter: HexagonPainter(),
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
      _startTimer();
      _startSizeAnimation();
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
        _stopSizeAnimation();
        _showGameOverDialog(context);
      }
    });
  }

  void _stopSizeAnimation() {
    _sizeTimer?.cancel();
  }

  void _startSizeAnimation() {
    _sizeTimer?.cancel();
    int sizeSpeedMilliseconds = (1000 ~/ _workSpeed).toInt();
    List<double> sizeSteps = [
      0.1,
      0.2,
      0.3,
      0.4,
      0.5,
      0.6,
      0.7,
      0.8,
      0.9,
      1.0,
    ];
    int currentStep = 0;

    _sizeTimer =
        Timer.periodic(Duration(milliseconds: sizeSpeedMilliseconds), (timer) {
      if (!_paused) {
        setState(() {
          _hexagonScale = sizeSteps[currentStep];
          currentStep = (currentStep + 1) % sizeSteps.length;
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
                          _sizeTimer?.cancel();
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
                        _startSizeAnimation();
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
                    'Çalışma Bitti',
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
                        Navigator.pop(context);
                        Navigator.pop(context); // Go back to the previous page
                      },
                      child: const Text('Geri Dön'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Gozegzersizleri()),
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

class HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    double hexagonSize = size.width;
    Offset center = Offset(size.width / 2, size.height / 2);

    Path hexagonPath = Path();
    for (int i = 0; i < 6; i++) {
      double angle = (math.pi / 2 + i * 2 * math.pi / 6);
      if (i == 0) {
        hexagonPath.moveTo(center.dx + hexagonSize * math.cos(angle) / 2,
            center.dy - hexagonSize * math.sin(angle) / 2);
      } else {
        hexagonPath.lineTo(center.dx + hexagonSize * math.cos(angle) / 2,
            center.dy - hexagonSize * math.sin(angle) / 2);
      }
    }
    hexagonPath.close();

    canvas.drawPath(hexagonPath, paint);

    // Ortadaki sabit siyah nokta
    final dotPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 10.0, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

void main() {
  runApp(const MaterialApp(
    home: Buyuyenaltigen(),
  ));
}
