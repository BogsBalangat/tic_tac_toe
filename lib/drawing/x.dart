import 'package:flutter/material.dart';
import 'package:tic_tac_toe/drawing/constants.dart';

class X extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => XState();
}

class XState extends State<X> with SingleTickerProviderStateMixin{
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
//          print(_animationPosition);
        });
      });
    controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: ELEMENT_SIZE,
      height: ELEMENT_SIZE,
      child: CustomPaint(painter: XPainter(_animationPosition)));
  }
}

class XPainter extends CustomPainter{
  Paint _paint;
  double _animationPosition;

  XPainter(this._animationPosition){
    _paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
//    print("size: $size, animation offset: $_animationPosition");
    double position = _animationPosition ?? 0.0;
    double height = size.height  * position;
    double width = size.width * position;
    if(position <= 0.5){
      drawFirstLeg(canvas, size, height * 2.0, width * 2.0);
    } else {
      drawFirstLeg(canvas, size, size.height, size.width);
      drawSecondLeg(canvas, size, (height-(size.height/2)) * 2.0,
          (width-(size.width/2.0)) * 2.0);
    }
  }

  drawFirstLeg(Canvas canvas, Size size, double height, double width){
    double variable = size.width - width;
//    print("first leg - height: $height width: $variable");
    canvas.drawLine(new Offset(size.width, 0.0),
        new Offset(variable, height), _paint);
  }

  drawSecondLeg(Canvas canvas, Size size, double height, double width){
//    print("second leg - height: $height width: $width");
    canvas.drawLine(new Offset(0.0, 0.0),
        new Offset(width, height), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}