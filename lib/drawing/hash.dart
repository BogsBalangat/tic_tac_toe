import 'package:flutter/material.dart';


class Hash extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => HashState();
}

class HashState extends State<Hash> with SingleTickerProviderStateMixin{
  double _animationPosition;
  Animation<double> _animation;
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = new AnimationController(duration: Duration(milliseconds: 700),
        vsync: this);
    controller.reset();
    _animation = new Tween(begin: 0.0,end: 4.0).animate(controller)
      ..addListener((){
        setState(() {
          _animationPosition = _animation.value;
//          print(_animationPosition);
        });
      });

  }
  @override
  Widget build(BuildContext context) {
    controller.forward();
    return new Container(
        child: CustomPaint(painter: HashPainter(_animationPosition))
    );
  }
}

class HashPainter extends CustomPainter{
  Paint _paint;
  final double _animationPosition;

  HashPainter(this._animationPosition){
    _paint = Paint()
      ..color = Colors.grey[400]
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
//    print("size: $size, animation offset: $_animationPosition");
    double aThird = 1/3;
    double aTwoThird = 2/3;
    double position = _animationPosition ?? 0.0;
    if(position <= 1.0){
      canvas.drawLine(new Offset(size.width * aThird, 0.0),
          new Offset(size.width * aThird, size.height * position), _paint);
    } else if (position > 1.0 && position <= 2.0){
      position -= 1.0;
      canvas.drawLine(new Offset(size.width * aThird, 0.0),
          new Offset(size.width * aThird, size.height), _paint);
      canvas.drawLine(new Offset(size.width * aTwoThird, 0.0),
          new Offset(size.width * aTwoThird, size.height * position), _paint);
    } else if (position > 2.0 && position <= 3.0){
      position -= 2.0;
      canvas.drawLine(new Offset(size.width * aThird, 0.0),
          new Offset(size.width * aThird, size.height), _paint);
      canvas.drawLine(new Offset(size.width * aTwoThird, 0.0),
          new Offset(size.width * aTwoThird, size.height), _paint);
      canvas.drawLine(new Offset(0.0, size.height * aThird),
          new Offset(size.width * position, size.height * aThird), _paint);
    } else if (position > 3.0 && position <= 4.0){
      position -= 3.0;
      canvas.drawLine(new Offset(size.width * aThird, 0.0),
          new Offset(size.width * aThird, size.height), _paint);
      canvas.drawLine(new Offset(size.width * aTwoThird, 0.0),
          new Offset(size.width * aTwoThird, size.height), _paint);
      canvas.drawLine(new Offset(0.0, size.height * aThird),
          new Offset(size.width, size.height * aThird), _paint);
      canvas.drawLine(new Offset(0.0, size.height * aTwoThird),
          new Offset(size.width * position, size.height * aTwoThird), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

resetAnimation(AnimationController controller){
  controller.reset();
}