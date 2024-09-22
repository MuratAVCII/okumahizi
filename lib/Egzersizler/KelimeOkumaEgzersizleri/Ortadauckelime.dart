import 'package:Hizlanio/Egzersizler/KelimeOkumaEgzersizleri/KelimeOkumaEgzersizleri.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class Ortadauckelime extends StatefulWidget {
  const Ortadauckelime({super.key});

  @override
  _OrtadauckelimeState createState() => _OrtadauckelimeState();
}

class _OrtadauckelimeState extends State<Ortadauckelime> {
  double _workDuration = 0.5; // in minutes
  double _workSpeed = 1.0; // 1x to 5x
  bool _isWorking = false;
  late int _remainingSeconds;
  late int _totalSeconds;
  Timer? _timer;
  Timer? _movementTimer;
  bool _paused = false;
  final Random _random = Random();
  final List<String> _words = [
    'Büyük Kahve Fincanı',
    'Hızlı Spor Araba',
    'Taze Meyve Sepeti',
    'Renkli Çiçek Buketi',
    'Yüksek Dağ Zirvesi',
    'Şehir Merkez Parkı',
    'Geniş Açık Alan',
    'Güzel Yaz Günü',
    'Tatlı Çikolata Kek',
    'Uygun Fiyatlı Ürün',
    'Güzel Bir Gün',
    'Sıcak Çikolata Bardak',
    'Renkli Boya Kalemleri',
    'Yüksek Ses Müzik',
    'Sakin Bir Akşam',
    'Yemek Masası Üstü',
    'Deniz Kenarı Kafe',
    'Göz Alıcı Elbise',
    'Zeytin Yağı Şişesi',
    'Güzel Kırmızı Gül',
    'Kış Tatili Planı',
    'Yeşil Bahçe Manzarası',
    'Huzurlu Orman Yolu',
    'Eğlenceli Doğa Yürüyüşü',
    'Ücretsiz Wi-Fi Ağı',
    'Serin Su Şişesi',
    'Sıcak Çay Fincanı',
    'Açık Hava Konserleri',
    'Küçük Oda Lambası',
    'Büyük Spor Salonu',
    'Keyifli Akşam Yemeği',
    'Üçgen Şapka Modeli',
    'Hızlı Yemek Restoranı',
    'Küçük Çocuk Oyuncakları',
    'Hafif Spor Egzersizleri',
    'Geniş Kafe Menüsü',
    'Yüksek Kalite Ürünler',
    'Güzel Deniz Manzarası',
    'Büyük Alışveriş Merkezi',
    'Küçük Elmas Taşları',
    'Çalışma Bilgisayar Masası',
    'Temiz Kış Karı',
    'Yüksek Katlı Bina',
    'Renkli Bahçe Çiçekleri',
    'Hareketli Şehir Caddesi',
    'Lezzetli Pizza Dilimi',
    'Kış Elbiseleri Koleksiyonu',
    'Eğlenceli Çocuk Parkı',
    'Sıcak Yaz Günü',
    'Yüksek Kalite Çanta'
  ]; // İki kelimeyi buraya ekleyin

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
                              Container(
                                child: CustomPaint(
                                  painter: WordPainter(
                                    _words[_random.nextInt(_words.length)],
                                  ),
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
      barrierDismissible: false, // Dialog dışına tıklayınca kapanmayı engeller
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
                    'Bu oyunda, rastgele yerlerde çıkan iki kelimeyi gözlerinizle takip etmeniz gerekmektedir.',
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
      _startMovement();
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
        setState(() {});
      }
    });
  }

  void _showPauseDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog dışına tıklayınca kapanmayı engeller
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
      barrierDismissible: false, // Dialog dışına tıklayınca kapanmayı engeller
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
                  'Çalışma Bitti',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Geçen Süre: $elapsedTime',
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const KelimeOkumaEgzersizleri()),
                        );
                      },
                      child: const Text('Geri Dön'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Ortadauckelime()),
                        );
                        _restartWork();
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

  void _restartWork() {
    setState(() {
      _isWorking = true;
      _totalSeconds = (_workDuration * 60).toInt();
      _remainingSeconds = _totalSeconds;
      _startTimer();
      _startMovement();
    });
  }

  String _formatDuration(Duration duration) {
    return duration.toString().split('.').first.padLeft(8, "0");
  }
}

class WordPainter extends CustomPainter {
  final String word;

  WordPainter(this.word);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final TextSpan span = TextSpan(
      style: const TextStyle(color: Colors.black, fontSize: 24.0),
      text: word,
    );

    final TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    tp.layout();
    tp.paint(
      canvas,
      Offset(
        size.width / 2 - tp.width / 2,
        size.height / 2 - tp.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
