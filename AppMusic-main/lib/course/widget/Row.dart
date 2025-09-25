import 'package:flutter/material.dart';

Row buildRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/img/Vector.png', height: 40),
      const SizedBox(width: 8),
      const Text(
        'HO CHI MINH City',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    ],
  );
}