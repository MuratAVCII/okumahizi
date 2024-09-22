import 'package:Hizlanio/Egzersizler/MetinOkumaEgzersizleri/MetinOkumaEgzersizleri.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MaterialApp(home: BoyananKelimeler()));
}

class BoyananKelimeler extends StatefulWidget {
  const BoyananKelimeler({super.key});

  @override
  _BoyananKelimelerState createState() => _BoyananKelimelerState();
}

class _BoyananKelimelerState extends State<BoyananKelimeler> {
  String _selectedText = 'Örnek Metin 1';
  int _wordCount = 1;
  int _speedMultiplier = 1;
  double _fontSize = 16;

  final List<String> _texts = [
    'Örnek Metin 1',
    'Örnek Metin 2',
    'Örnek Metin 3',
    'Gümüş Nehir'
  ];
  final Map<String, String> _textContents = {
    'Gümüş Nehir':
        "Ali Bey, köylülerin fikrini almak için bir toplantı düzenledi. Toplantıda herkes düşüncelerini dile getirdi. Bazıları, madencilerin teklif ettiği paranın köyü daha da geliştirebileceğini savunurken, diğerleri nehrin bozulabileceği endişesiyle bu fikre karşı çıktı. Tartışmalar uzun sürdü ve sonunda karar vermek zorlaştı. Dede Kerim, toplantının sonunda söz aldı ve herkesin dikkatini çekti. Bu nehir, bizim atalarımızdan miras kalan en değerli hazinemizdir, dedi. Onu korumak, bizim görevimizdir. Altın geçicidir, fakat nehrimiz ebedidir. Dede Kerim'in bu sözleri köylüler üzerinde derin bir etki bıraktı ve nihayetinde madencilerin teklifini reddetmeye karar verdiler. Madenciler, köylülerin kararına saygı duyarak köyden ayrıldılar. Ancak, onların gidişiyle birlikte köydeki huzur bozulmamıştı. Aksine, köylüler nehirlerini korudukları için gurur duyuyorlardı. Bu olay, köy halkını birbirine daha da kenetledi ve köydeki birlik ve beraberlik duygusunu güçlendirdi. Günler geçtikçe, köylüler hayatlarına kaldıkları yerden devam ettiler. Her akşam, Dede Kerim'in etrafında toplanan çocuklar, onun anlattığı yeni hikayelerle büyülendiler. Dede Kerim, bu olaydan dersler çıkartarak çocuklara nehrin ve doğanın değerini anlattı. Çocuklar, nehrin sadece bir su kaynağı olmadığını, aynı zamanda köylerinin ruhu olduğunu öğrendiler. Bir yaz sabahı, köyde olağanüstü bir olay meydana geldi. Nehirdeki suyun rengi aniden değişti ve parlak bir maviye dönüştü. Bu durum, köylüler arasında büyük bir merak uyandırdı. Nehrin bu değişimi, köyde uzun süredir görülmeyen bir balık türünün geri dönmesine neden oldu. Balıklar, nehrin temizliğini ve doğallığını yeniden kazanmasından dolayı geri dönmüşlerdi. Bu, köylüler için bir mucize olarak kabul edildi ve nehrin kutsallığına olan inançlarını daha da pekiştirdi.",
    'Örnek Metin 1': 'Bu örnek metin birinci metindir. ' * 100,
    'Örnek Metin 2': 'Bu örnek metin ikinci metindir. ' * 100,
    'Örnek Metin 3': 'Bu örnek metin üçüncü metindir. ' * 100,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSettingsDialog(); // Uygulama başlarken ayarlar penceresi otomatik olarak açılır
    });
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
      ), // Boş bir konteynır, çünkü başlangıçta ayarlar penceresi otomatik açılacak
    );
  }

  // Ayarlar penceresini gösteren metod
  void _showSettingsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog dışına tıklayınca kapanmayı engeller
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false; // Geri tuşuna basıldığında ayarlar penceresi kapanmasın
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                child: Container(
                  width: 400,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                          'Bu oyunda, vurgulanan kelimeleri belirli bir hızda okuyacaksınız.'),
                      const SizedBox(height: 16),
                      DropdownButton<String>(
                        value: _selectedText,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedText = newValue!;
                          });
                        },
                        items: _texts
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Text('Kelime Sayısı: $_wordCount'),
                      Slider(
                        value: _wordCount.toDouble(),
                        min: 1,
                        max: 6,
                        divisions: 5,
                        label: _wordCount.toString(),
                        onChanged: (double newValue) {
                          setState(() {
                            _wordCount = newValue.toInt();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text('Çalışma Hızınız: ${_speedMultiplier.toString()}x'),
                      Slider(
                        value: _speedMultiplier.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: 'x${_speedMultiplier.toString()}',
                        onChanged: (double newValue) {
                          setState(() {
                            _speedMultiplier = newValue.toInt();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text('Punto: ${_fontSize.toInt()}'),
                      Slider(
                        value: _fontSize,
                        min: 16,
                        max: 36,
                        divisions: 20,
                        label: _fontSize.toString(),
                        onChanged: (double newValue) {
                          setState(() {
                            _fontSize = newValue;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MetinOkumaEgzersizleri())),
                            child: const Text('Geri Dön'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _startWork();
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
          ),
        );
      },
    );
  }

  // Oyun sayfasını başlatan metod
  void _startWork() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
          text: _textContents[_selectedText]!,
          speedMultiplier: _speedMultiplier,
          fontSize: _fontSize,
          wordCount: _wordCount,
        ),
      ),
    ).then((_) {
      _showSettingsDialog(); // Oyun sayfasından geri dönüldüğünde ayarlar penceresi tekrar açılır
    });
  }
}

class GamePage extends StatefulWidget {
  final String text;
  final int speedMultiplier;
  final double fontSize;
  final int wordCount;

  const GamePage({super.key, 
    required this.text,
    required this.speedMultiplier,
    required this.fontSize,
    required this.wordCount,
  });

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<String> _words;
  late Timer _timer;
  int _currentWordIndex = 0;
  int _wordsToHighlight = 0;
  double _containerHeight = 0;
  List<String> _currentChunk = [];
  int _currentChunkStartIndex = 0;
  final bool _isPaused = false;
  late Timer _backgroundTimer;
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _words = widget.text.split(' '); // Metni kelimelere bölme
    _wordsToHighlight = widget.wordCount; // Ayarlarda belirtilen kelime sayısı
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _containerHeight = MediaQuery.of(context).size.height *
            0.70; // Konteynır yüksekliğini %70 olarak ayarla
        _prepareNextChunk(); // Metni parçalara ayır
        _startHighlighting(); // Metin vurgulamayı başlat
        _startBackgroundTimer(); // Arkaplan zamanlayıcısını başlat
      });
    });
  }

  void _startBackgroundTimer() {
    _backgroundTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime += const Duration(seconds: 1);
      });
    });
  }

  void _stopBackgroundTimer() {
    _backgroundTimer.cancel();
  }

  void _showPauseDialog() {
    _timer.cancel();
    _stopBackgroundTimer();
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog dışına tıklayınca kapanmayı engeller
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Oyun Durdu'),
          content: const Text('Çalışmayı bitir veya devam et.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resumeGame();
              },
              child: const Text('Devam Et'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showSummaryDialog();
              },
              child: const Text('Çalışmayı Bitir'),
            ),
          ],
        );
      },
    );
  }

  void _resumeGame() {
    _startHighlighting();
    _startBackgroundTimer();
  }

  void _showSummaryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog dışına tıklayınca kapanmayı engeller
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Çalışma Tamamlandı'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Toplam çalışma süreniz: ${_elapsedTime.inSeconds} saniye'),
              Text('Çalışma metniniz: ${widget.text.length} karakter'),
              Text('Kelime sayısı: ${widget.wordCount}'),
              Text('Çalışma hızı: ${widget.speedMultiplier}x'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BoyananKelimeler()));
              },
              child: const Text('Tekrar Oyna'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Çıkış Yap'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Timer'ı iptal et
    _backgroundTimer.cancel(); // Arkaplan zamanlayıcısını iptal et
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> spans = [];
    for (int i = 0; i < _currentChunk.length; i++) {
      int globalIndex = _currentChunkStartIndex + i;
      spans.add(TextSpan(
        text: '${_currentChunk[i]} ',
        style: TextStyle(
          fontSize: widget.fontSize,
          color: globalIndex < _currentWordIndex
              ? Colors.red
              : Colors.black.withOpacity(0.3), // Kelimeleri kırmızıya döndür
        ),
      ));
    }

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
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(MediaQuery.of(context).size.height / 30),
              decoration: BoxDecoration(
                color: const Color(0xFFD5B59C),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(children: spans),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showPauseDialog();
                    },
                    child: const Text('Durdur'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Metni parçalara ayıran metod
  void _prepareNextChunk() {
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    _currentChunk = [];
    StringBuffer currentPageText = StringBuffer();

    for (int i = _currentChunkStartIndex; i < _words.length; i++) {
      String word = _words[i];
      currentPageText.write('$word ');
      textPainter.text = TextSpan(
        text: currentPageText.toString(),
        style: TextStyle(fontSize: widget.fontSize),
      );
      textPainter.layout(maxWidth: MediaQuery.of(context).size.width * 0.90);

      if (textPainter.size.height > _containerHeight * 0.95) {
        break;
      }
      _currentChunk.add(word);
    }
  }

  // Metin vurgulamayı başlatan metod
  void _startHighlighting() {
    int duration = (1000 / widget.speedMultiplier)
        .round(); // Hız çarpanına göre süreyi ayarla
    _timer = Timer.periodic(Duration(milliseconds: duration), (timer) {
      setState(() {
        _currentWordIndex +=
            _wordsToHighlight; // Vurgulanacak kelime sayısını artır
        if (_currentWordIndex >= _words.length) {
          _timer.cancel(); // Metnin sonuna gelindiğinde timer'ı durdur
          _showSummaryDialog(); // Metnin sonuna gelindiğinde çalışma tamamlandı dialog'unu aç
        } else if (_currentWordIndex >=
            _currentChunkStartIndex + _currentChunk.length) {
          _currentChunkStartIndex =
              _currentWordIndex; // Mevcut parça bitince bir sonraki parçaya geç
          _prepareNextChunk(); // Yeni parçayı hazırla
        }
      });
    });
  }
}
