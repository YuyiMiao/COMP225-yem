import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_border.dart';

class MyHelper {
  MyHelper._();

  static final List<String> emotionPath = [
    'assets/emotions/1.png',
    'assets/emotions/2.png',
    'assets/emotions/3.png',
    'assets/emotions/4.png',
    'assets/emotions/angry.png',
    'assets/emotions/anxious.png',
    'assets/emotions/confused.png',
    'assets/emotions/happy.png',
    'assets/emotions/meh.png',
    'assets/emotions/sad.png'
  ];

  final List<String> emotionName = [
    'Tired',
    'Neural',
    'Happy',
    'Sad',
    'Angry',
    'Anxious',
    'Confused',
    'Happy',
    'Meh',
    'Sad'
  ];

  static const PolygonBorder PolyBut =  PolygonBorder(
      sides: 6,
      borderRadius: 5.0, // Default 0.0 degrees
      rotate: 0.0, // Default 0.0 degrees
      border: BorderSide.none, // Default BorderSide.none
  );

  static const BoxDecoration PolyDec = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.green,
          Colors.brown,],
    ),
  );
  
  static const Icon PlusIcon = Icon(
    Icons.add,
    color: Colors.white,
    size: 30,
  );

}
