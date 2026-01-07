import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TestLottie extends StatelessWidget {
  const TestLottie({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/bee.json',
          width: 180,
        ),
      ),
    );
  }
}
