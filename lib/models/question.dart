class Question {
  final int id;
  final String text;
  final int maxScore;
  final int timeLimit; // seconds

  Question({required this.id, required this.text, required this.maxScore, required this.timeLimit});

  factory Question.fromMap(Map<String, dynamic> m) => Question(
    id: m['id'] as int,
    text: m['text'] as String,
    maxScore: m['maxScore'] as int,
    timeLimit: m['timeLimit'] as int,
  );
}