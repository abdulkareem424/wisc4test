import 'package:flutter/material.dart';
import 'question_screen.dart';

class SubtestScreen extends StatelessWidget {
  final Map<String, dynamic>? childMap;
  const SubtestScreen({super.key, this.childMap});

  @override
  Widget build(BuildContext context) {
    final subtests = ['Vocabulary'];
    return Scaffold(
      appBar: AppBar(title: const Text('اختر Subtest')),
      body: ListView.builder(
        itemCount: subtests.length,
        itemBuilder: (c, i) => ListTile(
          title: Text(subtests[i]),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuestionScreen(subtest: subtests[i], childMap: childMap))),
        ),
      ),
    );
  }
}