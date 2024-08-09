import 'package:Hizlanio/Egzersizler/GozEgzersizleri/GozEgzersizleri.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TwoPointVertical extends StatefulWidget {
  const TwoPointVertical({super.key});

  @override
  _TwoPointVerticalState createState() => _TwoPointVerticalState();
}

class _TwoPointVerticalState extends State<TwoPointVertical> {
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
                                const Spacer(),
                                SizedBox(
                                  width: 50,
                                  height: screenHeight * 0.75,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 3,
                                        height: screenHeight * 0.75,
                                        color: Colors.black,
                                      ),
                                      Positioned(
                                        top: _rotation == 0
                                            ? 0
                                            : screenHeight * 0.75 -
                                                screenHeight / 30,
                                        child: Transform.rotate(
                                          angle: _rotation,
                                          child: Container(
                                            width: screenHeight / 30,
                                            height: screenHeight / 30,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const Spacer(),
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
            constraints: const BoxConstraints(maxWidth: 400), // Max genişlik sınırı
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
                        Navigator.pop(
                            context); // Navigate back to the previous page
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
    int rotationSpeedMilliseconds = (1000 / _workSpeed).toInt();
    _rotationTimer = Timer.periodic(
        Duration(milliseconds: rotationSpeedMilliseconds), (timer) {
      if (!_paused) {
        setState(() {
          _rotation += 3.141592653589793; // Rotate 180 degrees (pi radians)
          if (_rotation >= 2 * 3.141592653589793) {
            _rotation = 0.0;
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
            constraints: const BoxConstraints(maxWidth: 400), // Max genişlik sınırı
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Gozegzersizleri()),
                        ); // Go back to the previous page
                      },
                      child: const Text('Geri Dön'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TwoPointVertical()),
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
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rotationTimer?.cancel();
    super.dispose();
  }
}

void main() {
  runApp(const MaterialApp(
    home: TwoPointVertical(),
  ));
}
