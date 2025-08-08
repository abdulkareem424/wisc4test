import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import '../models/question.dart';
import '../services/db_service.dart';

class QuestionScreen extends StatefulWidget {
  final String subtest;
  final Map<String, dynamic>? childMap;
  const QuestionScreen({super.key, required this.subtest, this.childMap});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<Question> questions = [];
  int idx = 0;
  int remaining = 0;
  Timer? _timer;
  int timeTakenForCurrent = 0; // seconds
  List<int> scores = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final raw = await rootBundle
          .loadString('assets/questions/${widget.subtest.toLowerCase()}.json');
      final arr = jsonDecode(raw) as List<dynamic>;
      questions =
          arr.map((e) => Question.fromMap(e as Map<String, dynamic>)).toList();
      if (questions.isNotEmpty) {
        setState(() {
          remaining = questions.first.timeLimit;
        });
        _startTimer();
      } else {
        setState(() {});
      }
    } catch (e) {
      print('Error loading questions: $e');
      setState(() {});
    }
  }

  void _startTimer() {
    _timer?.cancel();
    remaining = questions[idx].timeLimit;
    timeTakenForCurrent = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (remaining > 0) {
          remaining -= 1;
          timeTakenForCurrent += 1;
        } else {
          // time's up -> record zero and go next
          _recordScore(0);
        }
      });
    });
  }

  Future<void> _recordScore(int score) async {
    _timer?.cancel();
    scores.add(score);
    // store to DB answers when we have session created
    final db = Provider.of<DbService>(context, listen: false);
    // create a simple session
    final sessionId = await db.createSession(
        widget.childMap != null ? widget.childMap!['id'] as int : 0,
        widget.subtest);
    await db.insertAnswer({
      'sessionId': sessionId,
      'questionId': questions[idx].id,
      'score': score,
      'timeTaken': timeTakenForCurrent
    });

    if (idx < questions.length - 1) {
      setState(() {
        idx += 1;
      });
      _startTimer();
    } else {
      // finished
      _timer?.cancel();
      final rawTotal = scores.fold(0, (a, b) => a + b);
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('انتهى الـ Subtest'),
                content: Text('Raw score = \$rawTotal'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('تمام'))
                ],
              ));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final q = questions[idx];
    return Scaffold(
      appBar: AppBar(
          title:
              Text('${widget.subtest} - سؤال ${idx + 1}/${questions.length}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(q.text, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text('الوقت المتبقي: \$remaining ثانية',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: List.generate(q.maxScore + 1, (i) {
                return ElevatedButton(
                  onPressed: () => _recordScore(i),
                  child: Text(i.toString()),
                );
              }),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () => _recordScore(0),
                child: const Text('تخطي / صفر'))
          ],
        ),
      ),
    );
  }
}
