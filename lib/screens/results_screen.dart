import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final int rawScore;
  final String subtest;
  const ResultsScreen({super.key, required this.rawScore, required this.subtest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('النتيجة')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Subtest: \$subtest'),
            Text('Raw Score: \$rawScore'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('خلاص'))
          ],
        ),
      ),
    );
  }
}