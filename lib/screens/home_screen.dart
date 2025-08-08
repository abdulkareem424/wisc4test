import 'package:flutter/material.dart';
import 'child_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WISC Prototype')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ChildSelectionScreen()));
          },
          child: const Text('ابدأ الاختبار'),
        ),
      ),
    );
  }
}
