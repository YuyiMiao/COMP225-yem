import 'package:flutter/material.dart';

class NavPainter extends CustomClipper<Path> {
  NavPainter({this.radius = 15.0});

  final double radius;

  Paint paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth=1.0
    ..color = Colors.black;


  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(NavPainter oldClipper) => true;
}

class CurvePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Color colorZero = Colors.green[300];
    Color colorOne = Colors.green[200];
    Color colorTwo = Colors.green[100];
    Color colorThree = Colors.green[50];

    Path path = Path();
    Paint paint = Paint();


    path.lineTo(0, size.height *0.75);
    path.quadraticBezierTo(size.width* 0.10, size.height*0.70,   size.width*0.17, size.height*0.90);
    path.quadraticBezierTo(size.width*0.20, size.height, size.width*0.25, size.height*0.90);
    path.quadraticBezierTo(size.width*0.40, size.height*0.40, size.width*0.50, size.height*0.70);
    path.quadraticBezierTo(size.width*0.60, size.height*0.85, size.width*0.65, size.height*0.65);
    path.quadraticBezierTo(size.width*0.70, size.height*0.90, size.width, 0);
    path.close();

    paint.color = colorThree;
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height*0.50);
    path.quadraticBezierTo(size.width*0.10, size.height*0.80, size.width*0.15, size.height*0.60);
    path.quadraticBezierTo(size.width*0.20, size.height*0.45, size.width*0.27, size.height*0.60);
    path.quadraticBezierTo(size.width*0.45, size.height, size.width*0.50, size.height*0.80);
    path.quadraticBezierTo(size.width*0.55, size.height*0.45, size.width*0.75, size.height*0.75);
    path.quadraticBezierTo(size.width*0.85, size.height*0.93, size.width, size.height*0.60);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = colorTwo;
    canvas.drawPath(path, paint);

    path =Path();
    path.lineTo(0, size.height*0.75);
    path.quadraticBezierTo(size.width*0.10, size.height*0.55, size.width*0.22, size.height*0.70);
    path.quadraticBezierTo(size.width*0.30, size.height*0.90, size.width*0.40, size.height*0.75);
    path.quadraticBezierTo(size.width*0.52, size.height*0.50, size.width*0.65, size.height*0.70);
    path.quadraticBezierTo(size.width*0.75, size.height*0.85, size.width, size.height*0.60);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = colorOne;
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height*0.75);
    path.quadraticBezierTo(size.width*0.10, size.height*0.55, size.width*0.22, size.height*0.50);
    path.quadraticBezierTo(size.width*0.30, size.height*0.90, size.width*0.40, size.height*0.55);
    path.quadraticBezierTo(size.width*0.52, size.height*0.50, size.width*0.65, size.height*0.40);
    path.quadraticBezierTo(size.width*0.75, size.height*0.85, size.width, size.height*0.30);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = colorZero;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        height: 300.0,
      ),
      painter: CurvePainter(),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  final double extent;

  MyCustomClipper({this.extent});

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, extent);
    path.lineTo(extent, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class StripsWidget extends StatelessWidget {
  final Color color1;
  final Color color2;
  final double gap;
  final noOfStrips;

  const StripsWidget(
      {Key key, this.color1, this.color2, this.gap, this.noOfStrips})
      : super(key: key);

  List<Widget> getListOfStripes() {
    List<Widget> stripes = [];
    for (var i = 0; i < noOfStrips; i++) {
      stripes.add(
        ClipPath(
          child: Container(color: (i%2==0)?color1:color2),
          clipper: MyCustomClipper(extent: i*gap),
        ),
      );
    }
    return stripes;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: getListOfStripes());
  }
}