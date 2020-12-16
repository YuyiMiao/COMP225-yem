import 'package:cupertino_date_textbox/cupertino_date_textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../model/emotion_list_model.dart';
import '../model/emotion.dart';
import '../ui_ux/clipper_painter.dart';

final List<String> imgList = [
  'assets/emotions/1.png',
  'assets/emotions/2.png',
  'assets/emotions/3.png',
  'assets/emotions/4.png',
  'assets/emotions/angry.png',
  'assets/emotions/anxious.png',
  'assets/emotions/confused.png',
  'assets/emotions/happy.png',
  'assets/emotions/meh.png',
  'assets/emotions/sad.png'
];

final List<String> emotionCorr = [
  'Tired',
  'Neural',
  'Happy',
  'Sad',
  'Angry',
  'Anxious',
  'Confused',
  'Happy',
  'Meh',
  'Sad'
];

class MyForm extends StatefulWidget {
  const MyForm({Key key, this.id, this.emotions, this.animationController}) : super(key: key);
  final AnimationController animationController;
  final EmotionListModel emotions;
  final int id;

  @override
  _MyFormState createState() => new _MyFormState(id: id, emotions: emotions);
}

class _MyFormState extends State<MyForm> {
  _MyFormState({Key key, this.id, this.emotions});
  DateTime _date = DateTime.now();
  CarouselController buttonCarouselController = CarouselController();
  double _imageNo;
  int _emotionNo = 0;

  String _description = emotionCorr[0];
  final formKey = GlobalKey<FormState>();
  final EmotionListModel emotions;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final int id;
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void _submit() {
    this._description = myController.text;
    this._imageNo = this._emotionNo.toDouble() + 1.0;
    if (this.id <=   emotions.items.last.id ) {
      emotions.update(Emotion(this.id, this._imageNo, this._date, this._description));
    } else {
      emotions.add(
          Emotion(this.id, this._imageNo, this._date, this._description));
    }
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    final recordFeeling = new Material(
      color: Colors.transparent,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center (
            child: const Text('Record how you feel:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                )),
          ),
          CarouselSlider(
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              viewportFraction: 0.5,
              enableInfiniteScroll: true,
              autoPlay: false,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                _emotionNo = index;
              },
            ),
            items: imageSliders,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                    minWidth: 30.0,
                    height: 10.0,
                    child: RaisedButton(
                      onPressed: () => buttonCarouselController.previousPage(
                          duration: Duration(milliseconds: 300), curve: Curves.linear),
                      child: Text("<-"),
                      color: Colors.brown,
                      textColor: Colors.white,
                    )
                ),
                ButtonTheme(
                    minWidth: 30.0,
                    height: 10.0,
                    child: RaisedButton(
                      onPressed: () => buttonCarouselController.nextPage(
                          duration: Duration(milliseconds: 300), curve: Curves.linear),
                      child: Text("->"),
                      color: Colors.brown,
                      textColor: Colors.white,
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final recordDate = new Material(
      color: Colors.transparent,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: const Text('Date of entry:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                )),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 5.0),
          ),
          CupertinoDateTextBox(
              initialValue: _date,
              // maximumDate: DateTime.now(),
              onDateChange: (recordDate) {
                setState(() {
                  _date = recordDate;
                });
              },
              hintText: DateFormat.yMd().format(_date)),
        ],
      ),
    );

    final recordNote = new Material(
      color: Colors.transparent,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 5.0),
          ),
          Center(
            child: const Text('Extra note:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                )),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 5.0),
          ),
          Center(
            child: Form(
              child: TextFormField(
                controller: myController,
              ),
            ),
          ),
        ],
      ),
    );

    final enterButton = new Material(
      color: Colors.transparent,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 5.0),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 30.0,
                  height: 10.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Return'),
                  ),
                ),
                ButtonTheme(
                  minWidth: 30.0,
                  height: 10.0,
                  child: ElevatedButton(
                    onPressed: () {
                      _submit();
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return new Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: <Widget>[
          StripsWidget(
            color1:Colors.green[100],
            color2:Colors.green[50],
            gap: 100,
            noOfStrips: 12,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
            child: Column(children: <Widget>[
              recordFeeling,
              recordDate,
              recordNote,
              enterButton
            ]
            ),
          ),
        ]
        )
    );
  }
}

final List<Widget> imageSliders = imgList.map((item) => Container(
  child: Container(
    margin: EdgeInsets.all(16.0),
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Image.asset(item, fit: BoxFit.cover, width: 100.0),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: Text(
                  '${emotionCorr[imgList.indexOf(item)]}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )
    ),
  ),
)).toList();
