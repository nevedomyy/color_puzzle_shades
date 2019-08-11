import 'package:flutter/material.dart';
import 'dart:math';

class AppColors{
  final List<Color> _list = [
    Color(0xFFFFE401),
    Color(0xFFE7640A),
    Color(0xFFD7031A),
    Color(0xFFE2006C),
    Color(0xFFA80C5D),
    Color(0xFF7D3889),
    Color(0xFF503A8D),
    Color(0xFF006BB3),
    Color(0xFF14ACDE),
    Color(0xFF06A199),
    Color(0xFF32A42B),
    Color(0xFFB4CB01),
  ];

  Color get() => _list[Random().nextInt(_list.length)];
}