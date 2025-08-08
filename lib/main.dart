import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/db_service.dart';

void main() {
  runApp(const WiscApp());
}

class WiscApp extends StatelessWidget {
  const WiscApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => DbService(),
      child: MaterialApp(
        title: 'WISC-IV Test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
