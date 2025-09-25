import 'package:flutter/material.dart';

class buildRow2 extends StatelessWidget {
  const buildRow2({super.key});

  @override
  Widget build(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset('assets/img/humidity.png', height: 80),
          Image.asset('assets/img/Component.png', height: 80),
        ],
      );
  }
}
