import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key, required this.size});

  final Size size;

  @override
  DrawingPageState createState() => DrawingPageState();
}

class DrawingPageState extends State<DrawingPage> {
  List<Offset?> points = [];
  Offset _canvasOffset = Offset.zero;
  Offset? _previousOffset;

  @override
  void initState() {
    super.initState();

    _canvasOffset = Offset(
      -widget.size.width * 5,
      -widget.size.height * 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            points.add(details.localPosition - _canvasOffset);
          });
        },
        onPanEnd: (details) {
          points.add(null);
        },
        onScaleUpdate: (details) {
          // Only pan the canvas if two fingers are used
          if (details.pointerCount == 2) {
            setState(() {
              _canvasOffset += details.focalPointDelta;
            });
          }
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: DrawingPainter(points, _canvasOffset),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Offset canvasOffset;

  DrawingPainter(this.points, this.canvasOffset);

  @override
  void paint(Canvas canvas, Size size) {
    // Apply canvas offset for panning
    canvas.translate(canvasOffset.dx, canvasOffset.dy);

    // Draw the grid
    _drawGrid(canvas, size * 10);

    // Draw the user's drawing
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    double gridSize = 20.0; // Size of each square in the grid
    Paint gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
