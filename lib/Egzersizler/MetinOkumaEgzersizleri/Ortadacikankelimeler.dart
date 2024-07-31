import 'package:Hizlanio/Egzersizler/MetinOkumaEgzersizleri/MetinOkumaEgzersizleri.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class OrtadaCikanKelime extends StatefulWidget {
  const OrtadaCikanKelime({Key? key}) : super(key: key);

  @override
  _OrtadaCikanKelimeState createState() => _OrtadaCikanKelimeState();
}

class _OrtadaCikanKelimeState extends State<OrtadaCikanKelime> {
  double _workSpeed = 1.0;
  double _fontSize = 24.0;
  bool _isWorking = false;
  bool _paused = false;
  Timer? _timer;
  int _wordCount = 1;
  final List<String> _textEntries = [
    'Metin 1: Harika, kodu deneyip geri bildirimlerinizi paylaşabilirsiniz. Kodun açıklaması ve işlevleri hakkında sorularınız olursa veya eklememi istediğiniz başka özellikler varsa, lütfen bana bildirin. Kodun doğru çalışması ve isteklerinize uygun olup olmadığını kontrol etmek için geri bildirimlerinizi bekliyorum.' *
        50,
    'Metin 2: Flutter uygulama geliştirme sürecinde önemli olan şeyler arasında performans, kullanıcı deneyimi ve esneklik yer alır. Flutter, bu ihtiyaçları karşılamak için güçlü bir araçtır ve geniş bir widget yelpazesi sunar.' *
        50,
    // Diğer metinleri buraya ekleyin
  ];
  String? _selectedTextEntry;
  int _currentWordIndex = 0;
  DateTime? _startTime;
  Duration? _totalDuration;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _showSettingsDialog(context));
    _selectedTextEntry = _textEntries.first;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Container boyutlarını ekran genişliği ve yüksekliği oranına göre ayarlama
    final containerWidth = screenWidth * 0.9; // %90 genişlik
    final containerHeight = screenHeight * 0.9; // %90 yükseklik

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
            child: Container(
              width: containerWidth,
              height: containerHeight,
              padding: EdgeInsets.all(screenWidth / 30),
              decoration: BoxDecoration(
                color: Color(0xFFD5B59C),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_isWorking) ...[
                    Expanded(
                      child: Center(
                        child: Text(
                          _getCurrentWords(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _fontSize,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _paused = true;
                          _totalDuration =
                              DateTime.now().difference(_startTime!);
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
    );
  }

  String _getCurrentWords() {
    List<String> words = _selectedTextEntry!.split(' ');
    if (_currentWordIndex >= words.length) {
      return "";
    }
    return words.skip(_currentWordIndex).take(_wordCount).join(' ');
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
                    'Bu oyunda, ortada çıkan kelimeleri belirli bir hızda okuyacaksınız.',
                    textAlign: TextAlign.center,
                  ),
                ),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 16),
                        DropdownButton<String>(
                          hint: Text("Bir metin seçin"),
                          value: _selectedTextEntry,
                          items: _textEntries.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.split(':')[0]),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedTextEntry = newValue;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        Text('Kelime Sayısı: $_wordCount'),
                        Slider(
                          value: _wordCount.toDouble(),
                          min: 1,
                          max: 6,
                          divisions: 5,
                          label: _wordCount.toString(),
                          onChanged: (value) {
                            setState(() {
                              _wordCount = value.toInt();
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        Text(
                            'Çalışma Hızınız: ${_workSpeed.toStringAsFixed(1)}x'),
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
                        SizedBox(height: 16),
                        Text('Punto: ${_fontSize.toInt()}'),
                        Slider(
                          value: _fontSize,
                          min: 16.0,
                          max: 36.0,
                          divisions: 16,
                          label: _fontSize.toInt().toString(),
                          onChanged: (value) {
                            setState(() {
                              _fontSize = value;
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
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MetinOkumaEgzersizleri()));
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
    if (_selectedTextEntry == null) return;
    setState(() {
      _isWorking = true;
      _paused = false;
      _currentWordIndex = 0;
      _startTime = DateTime.now();
      _startTimer();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    int movementSpeedMilliseconds = (1000 ~/ _workSpeed).toInt();
    _timer = Timer.periodic(Duration(milliseconds: movementSpeedMilliseconds),
        (timer) {
      if (!_paused &&
          _currentWordIndex < _selectedTextEntry!.split(' ').length) {
        setState(() {
          _currentWordIndex += _wordCount;
        });
      } else if (_currentWordIndex >= _selectedTextEntry!.split(' ').length) {
        timer.cancel();
        _showCompletionDialog();
      }
    });
  }

  void _showPauseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Oyun Durdu'),
          content: Text('Çalışmayı bitir veya devam et?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showCompletionDialog();
              },
              child: Text('Çalışmayı Bitir'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resumeWork();
              },
              child: Text('Devam Et'),
            ),
          ],
        );
      },
    );
  }

  void _resumeWork() {
    setState(() {
      _paused = false;
    });
    _startTimer();
  }

  void _showCompletionDialog() {
    _totalDuration = DateTime.now().difference(_startTime!);
    double minutes = _totalDuration!.inMinutes +
        (_totalDuration!.inSeconds % 60) / 60.0; // Toplam dakika
    int totalWords = _selectedTextEntry!.split(' ').length;
    double wordsPerMinute = totalWords / minutes; // Dakika başına kelime sayısı

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Çalışma Bitti'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Toplam Okuma Süresi: ${_totalDuration!.inMinutes.toString().padLeft(2, '0')}:${(_totalDuration!.inSeconds % 60).toString().padLeft(2, '0')} Dakika'),
              Text('Çalışma Hızınız: ${_workSpeed.toStringAsFixed(1)}x'),
              Text('Açılan Kelime Sayısı: ${_currentWordIndex}')
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MetinOkumaEgzersizleri()));
                setState(() {
                  _isWorking = false;
                });
              },
              child: Text('Geri Dön'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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
      _isWorking = false;
    });
    _showSettingsDialog(context);
  }
}
