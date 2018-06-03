import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/drawing/constants.dart';


class O extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => OState();
}
class OState extends State<O> with SingleTickerProviderStateMixin{
  double _animationPosition;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    var controller = new AnimationController(duration: Duration(milliseconds: 300),
    vsync: this);
    _animation = new Tween(begin: 0.0,end: 1.0).animate(controller)
    ..addListener((){
      setState(() {
        _animationPosition = _animation.value;
      });
    });
    controller.forward();
  }

  Widget build(BuildContext context) {
    return new Container(
        width: ELEMENT_SIZE,
        height: ELEMENT_SIZE,
        child: CustomPaint(painter: OPainter(_animationPosition)));
  }
}

class OPainter extends CustomPainter{
  Paint _paint;
  double _animationPosition;

  OPainter(this._animationPosition){
    _paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
//    print("size: $size, animation offset: $_animationPosition");
    var rect = new Offset(0.0,0.0) & size;
    double position = _animationPosition ?? 0.0;
    double startAngle =  -pi / 2.0;
    double sweepAngle = pi * 2.0 * position;
    canvas.drawArc(rect,startAngle, sweepAngle, false, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}
