class QuestionResult {
  final int questionId;
  final int score; // actual awarded score
  final int timeTaken; // seconds

  QuestionResult({required this.questionId, required this.score, required this.timeTaken});
}