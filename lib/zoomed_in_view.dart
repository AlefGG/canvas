import 'package:canvas_drawable/drawing_canvas.dart';
import 'package:flutter/material.dart';

class ZoomedInView extends StatelessWidget {
  final Offset currentPoint;
  final List<Offset?> points;

  const ZoomedInView({required this.currentPoint, required this.points});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      top: 10,
      width: 100,
      height: 100,
      child: ClipOval(
        child: Container(
          color: Colors.white,
          child: Transform.scale(
            scale: 2.0,
            origin: currentPoint,
            child: CustomPaint(
              painter: CanvasCustomPainter(
                points: points,
                offset: Offset.zero,
                // zoom: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
