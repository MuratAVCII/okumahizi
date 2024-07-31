class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class Metin {
  final String content;
  final List<Question> questions;

  Metin({required this.content, required this.questions});
}

final List<Metin> metinler = [
  Metin(
    content: "Metin 1 Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    questions: [
      Question(
        question: "Metin 1 hakkında soru 1?",
        options: [
          "Seçenek 1" * 10,
          "Seçenek 2" * 3,
          "Seçenek 3" * 4,
          "Seçenek 4" * 5
        ],
        correctAnswerIndex: 0,
      ),
      Question(
        question: "Metin 1 hakkında soru 2?",
        options: [
          "Seçenek 1" * 10,
          "Seçenek 2" * 3,
          "Seçenek 3" * 4,
          "Seçenek 4" * 5
        ],
        correctAnswerIndex: 0,
      ),
      Question(
        question: "Metin 1 hakkında soru 3?",
        options: [
          "Seçenek 1" * 10,
          "Seçenek 2" * 3,
          "Seçenek 3" * 4,
          "Seçenek 4" * 5
        ],
        correctAnswerIndex: 0,
      ),
      Question(
        question: "Metin 1 hakkında soru 2?",
        options: [
          "Seçenek 1" * 10,
          "Seçenek 2" * 3,
          "Seçenek 3" * 4,
          "Seçenek 4"
        ],
        correctAnswerIndex: 0,
      ),
      // Diğer sorular
    ],
  ),
  Metin(
    content: "Metin 2 Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    questions: [
      Question(
        question: "Metin 2 hakkında soru 1?",
        options: [
          "Seçenek 1" * 10,
          "Seçenek 2" * 3,
          "Seçenek 3" * 4,
          "Seçenek 4"
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "Metin 2 hakkında soru 2?",
        options: [
          "Seçenek 1" * 10,
          "Seçenek 2" * 3,
          "Seçenek 3" * 4,
          "Seçenek 4"
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "Metin 2 hakkında soru 3?",
        options: [
          "Seçenek 1" * 10,
          "Seçenek 2" * 3,
          "Seçenek 3" * 4,
          "Seçenek 4"
        ],
        correctAnswerIndex: 1,
      ),
      // Diğer sorular
    ],
  ),
  Metin(
    content: "Metin 3 Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    questions: [
      Question(
        question: "Metin 3 hakkında soru 1?",
        options: [
          "Seçenek 1" * 10,
          "Seçenek 2" * 1,
          "Seçenek 3" * 4,
          "Seçenek 4" * 5
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "Metin 3 hakkında soru 1?",
        options: [
          "Seçenek 1" * 10,
          "Seçenek 2" * 1,
          "Seçenek 3" * 4,
          "Seçenek 4" * 5
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "Metin 3 hakkında soru 2?",
        options: [
          "Seçenek 1" * 10,
          "Seçenek 2" * 1,
          "Seçenek 3" * 4,
          "Seçenek 4" * 5
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "Metin 3 hakkında soru 3?",
        options: [
          "Seçenek 1" * 10,
          "Seçenek 2" * 1,
          "Seçenek 3" * 4,
          "Seçenek 4" * 5
        ],
        correctAnswerIndex: 1,
      ),
      // Diğer sorular
    ],
  ),
  Metin(
    content: "Metin 4 Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    questions: [
      Question(
        question: "Metin 4 hakkında soru 1?",
        options: [
          "Seçenek 1" * 10,
          "Seçenek 2" * 3,
          "Seçenek 3" * 4,
          "Seçenek 4"
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "Metin 4 hakkında soru 2?",
        options: [
          "Seçenek 1" * 10,
          "Seçenek 2" * 3,
          "Seçenek 3" * 4,
          "Seçenek 4"
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "Metin 4 hakkında soru 3?",
        options: [
          "Seçenek 1" * 10,
          "Seçenek 2" * 3,
          "Seçenek 3" * 4,
          "Seçenek 4"
        ],
        correctAnswerIndex: 1,
      ),
      // Diğer sorular
    ],
  ),
  // Diğer metinler ve sorular
];
