import 'dart:math';
import 'package:Hizlanio/hizTesti/metinlervesorular.dart';
import 'package:flutter/material.dart';

Widget buildQuestionContainer({
  required BuildContext context,
  required Metin selectedMetin,
  required double screenWidth,
  required int currentQuestionIndex,
  required List<int> userAnswers,
  required Function(int) setCurrentQuestionIndex,
  required Function(List<int>) setUserAnswers,
  required VoidCallback submitAnswers,
}) {
  return SafeArea(
    child: Expanded(
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      selectedMetin.questions.length,
                      (index) => GestureDetector(
                        onTap: () {
                          setCurrentQuestionIndex(index);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5),
                            color: currentQuestionIndex == index
                                ? Colors.blue
                                : (userAnswers.length > index &&
                                        userAnswers[index] == -1)
                                    ? Colors.orange
                                    : Colors.white,
                          ),
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: currentQuestionIndex == index ||
                                      (userAnswers.length > index &&
                                          userAnswers[index] == -1)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Soru ${currentQuestionIndex + 1}/${selectedMetin.questions.length}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    selectedMetin.questions[currentQuestionIndex].question,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: min(screenWidth / 20, 24),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: selectedMetin
                        .questions[currentQuestionIndex].options
                        .asMap()
                        .entries
                        .map((entry) {
                      int idx = entry.key;
                      String text = entry.value;
                      bool isSelected =
                          userAnswers.length > currentQuestionIndex &&
                              userAnswers[currentQuestionIndex] == idx;
                      String optionLabel =
                          String.fromCharCode(65 + idx); // A, B, C, D

                      return GestureDetector(
                        onTap: () {
                          setUserAnswers(idx as List<int>);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                isSelected ? Colors.blue : Colors.transparent,
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$optionLabel) ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: min(screenWidth / 20, 18),
                                  color:
                                      isSelected ? Colors.white : Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  text,
                                  style: TextStyle(
                                    fontSize: min(screenWidth / 20, 18),
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: currentQuestionIndex > 0
                            ? () {
                                setCurrentQuestionIndex(
                                    currentQuestionIndex - 1);
                              }
                            : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("Önceki Soru"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          backgroundColor: currentQuestionIndex > 0
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          List<int> updatedUserAnswers =
                              List<int>.from(userAnswers);
                          while (updatedUserAnswers.length <
                              selectedMetin.questions.length) {
                            updatedUserAnswers.add(-1);
                          }
                          bool allQuestionsAnswered = true;
                          List<int> unansweredQuestions = [];

                          for (int i = 0;
                              i < selectedMetin.questions.length;
                              i++) {
                            if (updatedUserAnswers[i] == -1) {
                              allQuestionsAnswered = false;
                              unansweredQuestions.add(i + 1);
                            }
                          }

                          if (!allQuestionsAnswered) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Uyarı"),
                                content: Text(
                                    "Lütfen tüm soruları cevaplayınız. Eksik sorular: ${unansweredQuestions.join(", ")}"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Tamam"),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            submitAnswers();
                          }
                        },
                        icon: const Icon(Icons.check),
                        label: const Text("Testi Bitir"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          backgroundColor: Colors.green,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: currentQuestionIndex <
                                selectedMetin.questions.length - 1
                            ? () {
                                setCurrentQuestionIndex(
                                    currentQuestionIndex + 1);
                              }
                            : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Sonraki Soru"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          backgroundColor: currentQuestionIndex <
                                  selectedMetin.questions.length - 1
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
