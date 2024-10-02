import 'dart:ui';

import 'package:canvas_drawable/zoomed_in_view.dart';
import 'package:flutter/material.dart';

enum CanvasState { pan, draw }

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  List<Offset?> points = [];
  CanvasState canvasState = CanvasState.draw;

  //add the offset variable to keep track of the current offset
  Offset offset = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            canvasState == CanvasState.draw ? Colors.red : Colors.blue,
        onPressed: () {
          setState(() {
            canvasState = canvasState == CanvasState.draw
                ? CanvasState.pan
                : CanvasState.draw;
          });
        },
        child: Text(
          canvasState == CanvasState.draw ? "Draw" : "Pan",
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onPanDown: (details) {
              setState(() {
                if (canvasState == CanvasState.draw) {
                  points.add(details.localPosition - offset);
                }
              });
            },
            onPanUpdate: (details) {
              setState(() {
                if (canvasState == CanvasState.pan) {
                  offset += details.delta;
                } else {
                  points.add(details.localPosition - offset);
                }
              });
            },
            onPanEnd: (details) {
              setState(() {
                if (canvasState == CanvasState.draw) {
                  points.add(null);
                }
              });
            },
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 10,
              height: MediaQuery.sizeOf(context).height * 10,
              child: ClipRRect(
                child: CustomPaint(
                  painter: CanvasCustomPainter(
                    points: points,
                    offset: offset,
                  ),
                ),
              ),
            ),
          ),
          if (canvasState == CanvasState.draw && points.isNotEmpty)
            ZoomedInView(
              currentPoint: points.last ?? Offset.zero,
              points: points,
            ),
        ],
      ),
    );
  }
}

class CanvasCustomPainter extends CustomPainter {
  List<Offset?> points;
  Offset offset;

  CanvasCustomPainter({
    required this.points,
    required this.offset,
  });
  @override
  void paint(Canvas canvas, Size size) {
    // Определение цвета фона и заливка холста
    Paint background = Paint()..color = Colors.white;
    canvas.drawPaint(background);

    // Отрисовка бесконечной сетки
    drawGrid(canvas, size);

    // Применяем смещение к холсту
    canvas.translate(offset.dx, offset.dy);

    // Определение свойств рисования
    Paint drawingPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..color = Colors.black
      ..strokeWidth = 1.5;

    // Отрисовка линий
    for (int x = 0; x < points.length - 1; x++) {
      if (points[x] != null && points[x + 1] != null) {
        canvas.drawLine(points[x]!, points[x + 1]!, drawingPaint);
      } else if (points[x] != null && points[x + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[x]!], drawingPaint);
      }
    }

    // Восстанавливаем состояние холста
    canvas.translate(-offset.dx, -offset.dy);
  }

  void drawGrid(Canvas canvas, Size size) {
    double gridSize = 20.0; // Размер каждой ячейки сетки
    Paint gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5;

    // Корректируем смещение для начала сетки
    double startX = offset.dx % gridSize;
    double startY = offset.dy % gridSize;

    // Рисование вертикальных линий
    for (double x = startX; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, startY), Offset(x, size.height), gridPaint);
    }

    // Рисование горизонтальных линий
    for (double y = startY; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(startX, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(CanvasCustomPainter oldDelegate) {
    return true;
  }
}
