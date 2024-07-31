import 'dart:async';
import 'dart:math';
import 'package:Hizlanio/hizTesti/OkumaMetni.dart';
import 'package:Hizlanio/hizTesti/metinlervesorular.dart';
import 'package:flutter/material.dart';
import 'OkumaMetni.dart';
import "package:Hizlanio/hizTesti/hizTesti.dart";

class HizTesti extends StatefulWidget {
  const HizTesti({Key? key}) : super(key: key);

  @override
  _HizTestiState createState() => _HizTestiState();
}

class _HizTestiState extends State<HizTesti> {
  double _sliderValue = 0.0;
  late Timer _timer;
  int counter = 3;
  bool showText = false;
  bool showQuestions = false;
  Stopwatch stopwatch = Stopwatch();
  Metin? selectedMetin;
  int currentQuestionIndex = 0;
  List<int> userAnswers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showCountdownPopup());
  }

  void showCountdownPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (counter == 3) {
              _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                if (counter == 1) {
                  setState(() {
                    counter--;
                  });
                  Future.delayed(Duration(seconds: 1), () {
                    Navigator.of(context).pop();
                    setState(() {
                      showText = true;
                      stopwatch.start();
                      selectedMetin =
                          metinler[Random().nextInt(metinler.length)];
                    });
                  });
                } else {
                  setState(() {
                    counter--;
                  });
                }
              });
            }
            return AlertDialog(
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              content: Container(
                height: MediaQuery.of(context).size.height / 6,
                child: Center(
                  child: Text(
                    counter > 0 ? '$counter' : 'Başla!',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      setState(() {});
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  void showReadingSpeedPopup(int readingSpeed, int comprehensionScore) {
    String message;
    if (readingSpeed >= 450) {
      message = "Çok hızlı okuyorsunuz!";
    } else if (readingSpeed >= 200) {
      message = "Ortalama bir hızda okuyorsunuz.";
    } else {
      message =
          "Daha hızlı okuma yapmalısınız bunun için hemen çalışmaya başlayalım.";
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Okuma Hızınız ve Anlama Yüzdeniz"),
          content: Text(
              "Dakikada $readingSpeed kelime okudunuz.\n\n$message\n\nAnlama yüzdeniz: %$comprehensionScore"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text("Tamam"),
            ),
          ],
        );
      },
    );
  }

  void showComprehensionTestPrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Metni Okumayı Tamamladınız"),
          content: Text("Şimdi sıra anlama testini çözmede."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  showQuestions = true;
                  currentQuestionIndex = 0;
                  userAnswers.clear();
                });
              },
              child: Text("Anlama Testine Geç"),
            ),
          ],
        );
      },
    );
  }

  void finishReading() {
    stopwatch.stop();
    setState(() {
      showText = false;
    });
    showComprehensionTestPrompt();
  }

  void submitAnswers() {
    int correctAnswers = 0;
    for (int i = 0; i < selectedMetin!.questions.length; i++) {
      if (userAnswers[i] == selectedMetin!.questions[i].correctAnswerIndex) {
        correctAnswers++;
      }
    }
    int comprehensionScore =
        ((correctAnswers / selectedMetin!.questions.length) * 100).round();
    int readingTimeInSeconds = stopwatch.elapsed.inSeconds;
    int wordCount = selectedMetin!.content.split(' ').length;
    int readingSpeed = (wordCount / (readingTimeInSeconds / 60)).round();
    showReadingSpeedPopup(readingSpeed, comprehensionScore);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final sidePadding = screenWidth / 100;
    Color pageColor = Color(0xFFD5B59C);

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
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sidePadding * 2,
                vertical: sidePadding * 2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (showText)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: pageColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    selectedMetin!.content,
                                    style: TextStyle(
                                      fontSize: screenHeight / 35,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: finishReading,
                                child: Text("Okumayı Bitir"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else if (showQuestions)
                    Expanded(
                      child: Center(
                        child: Container(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.8,
                          decoration: BoxDecoration(
                            color: pageColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(sidePadding * 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    selectedMetin!.questions.length,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          currentQuestionIndex = index;
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: currentQuestionIndex == index
                                              ? Colors.blue
                                              : (userAnswers.length > index &&
                                                      userAnswers[index] == -1)
                                                  ? Colors
                                                      .orange // Boş bırakılan sorunun turuncu renkte işaretlenmesi
                                                  : Colors.white,
                                        ),
                                        child: Text(
                                          (index + 1).toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: currentQuestionIndex ==
                                                        index ||
                                                    (userAnswers.length >
                                                            index &&
                                                        userAnswers[index] ==
                                                            -1)
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: sidePadding),
                                Text(
                                  "Soru : ${currentQuestionIndex + 1}/${selectedMetin!.questions.length}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: sidePadding),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text(
                                          selectedMetin!
                                              .questions[currentQuestionIndex]
                                              .question,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: min(screenWidth / 20, 24),
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: sidePadding),
                                        Column(
                                          children: selectedMetin!
                                              .questions[currentQuestionIndex]
                                              .options
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int idx = entry.key;
                                            String text = entry.value;
                                            bool isSelected = userAnswers
                                                        .length >
                                                    currentQuestionIndex &&
                                                userAnswers[
                                                        currentQuestionIndex] ==
                                                    idx;
                                            String optionLabel =
                                                String.fromCharCode(
                                                    65 + idx); // A, B, C, D

                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  // Kullanıcı bir sonraki soruya geçtiğinde veya soruya cevap verdiğinde userAnswers listesini güncelle
                                                  while (userAnswers.length <=
                                                      currentQuestionIndex) {
                                                    userAnswers.add(-1);
                                                  }
                                                  userAnswers[
                                                          currentQuestionIndex] =
                                                      isSelected ? -1 : idx;
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                padding: EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: isSelected
                                                      ? Colors.blue
                                                      : Colors.transparent,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      optionLabel + ") ",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: min(
                                                            screenWidth / 20,
                                                            18),
                                                        color: isSelected
                                                            ? Colors.black
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        text,
                                                        style: TextStyle(
                                                          fontSize: min(
                                                              screenWidth / 20,
                                                              18),
                                                          color: isSelected
                                                              ? Colors.black
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: sidePadding),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: currentQuestionIndex > 0
                                            ? () {
                                                setState(() {
                                                  currentQuestionIndex--;
                                                });
                                              }
                                            : null,
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          "",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 16),
                                          backgroundColor:
                                              currentQuestionIndex > 0
                                                  ? Colors.blue
                                                  : Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Expanded(
                                      child: Center(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              // Kullanıcı tüm soruları cevapladıysa submitAnswers fonksiyonunu çağır
                                              while (userAnswers.length <
                                                  selectedMetin!
                                                      .questions.length) {
                                                userAnswers.add(-1);
                                              }
                                              bool allQuestionsAnswered = true;
                                              List<int> unansweredQuestions =
                                                  [];

                                              for (int i = 0;
                                                  i <
                                                      selectedMetin!
                                                          .questions.length;
                                                  i++) {
                                                if (userAnswers[i] == -1) {
                                                  allQuestionsAnswered = false;
                                                  unansweredQuestions
                                                      .add(i + 1);
                                                }
                                              }

                                              if (!allQuestionsAnswered) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Text("Uyarı"),
                                                    content: Text(
                                                        "Lütfen tüm soruları cevaplayınız. Eksik sorular: ${unansweredQuestions.join(", ")}"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text("Tamam"),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                submitAnswers();
                                              }
                                            });
                                          },
                                          icon: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: (screenWidth / 50)
                                                .clamp(0.0, 20),
                                          ),
                                          label: Text(
                                            "Testi Bitir",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: (screenWidth / 50)
                                                  .clamp(0.0, 20),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 16),
                                            backgroundColor: Colors
                                                .green, // Text rengini beyaz yapar
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: currentQuestionIndex <
                                                selectedMetin!
                                                        .questions.length -
                                                    1
                                            ? () {
                                                setState(() {
                                                  currentQuestionIndex++;
                                                });
                                              }
                                            : null,
                                        icon: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                        label: Text("",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 16),
                                          backgroundColor:
                                              currentQuestionIndex <
                                                      selectedMetin!.questions
                                                              .length -
                                                          1
                                                  ? Colors.blue
                                                  : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
