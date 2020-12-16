import 'dart:core';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import '../ui_ux/clipper_painter.dart';

class MyGeneral extends StatefulWidget {
  const MyGeneral({Key key,  this.animationController}) : super(key: key);
  final AnimationController animationController;
  //final bool visible;

  @override
  _MyGeneralState createState() => _MyGeneralState();
}

class _MyGeneralState extends State<MyGeneral>
        with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController animationController;

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: Container(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                bottom: 300,
                left: 0,
                right: 0,
                child: TopBar(),
              ),
              Positioned(
                top: -15,
                left: 0,
                right: 0,
                child: Image.asset('assets/images/header3.png'),
              ),
              Positioned(
                top: 50,
                left: 10,
                right: 0,
                child: Text("Welcome \n    Back!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      )
    );
  }
}

