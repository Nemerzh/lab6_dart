import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/calculator_view_model.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(const Pw3App());
}

class Pw3App extends StatelessWidget {
  const Pw3App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculatorViewModel(),
      child: MaterialApp(
        title: "Калькулятор електричних навантажень",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const CalculatorScreen(),
      ),
    );
  }
}
