// Minimal scoring: sum raw scores for subtest (raw score = sum of question scores)
class ScoringService {
  int computeRawScore(List<int> questionScores) {
    return questionScores.fold(0, (a, b) => a + b);
  }
}