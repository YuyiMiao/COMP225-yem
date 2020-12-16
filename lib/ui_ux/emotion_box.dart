import 'package:flutter/material.dart';
import '../helper.dart';

class EmotionBox extends StatelessWidget {
  EmotionBox({Key key, this.date, this.description, this.image, this.color}) :
        super(key: key);
  final String date;
  final String description;
  final int image;
  final Color color;

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2),
        height: 120,
        child: Card(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(MyHelper.emotionPath[image-1]),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(this.date, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text(this.description, style: TextStyle(fontSize: 18),),
                            ],
                          )
                      )
                  )
                ]
            ),
          color: color,
        )
    );
  }
}