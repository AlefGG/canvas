import 'dart:ui';

import 'package:flutter/material.dart';

class UsefulMethods {
  void drawGrid(Canvas canvas, Size size) {
    double gridSize = 20.0; // Размер каждой ячейки сетки
    Paint gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5;

    // Рисование вертикальных линий
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Рисование горизонтальных линий
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }
}
