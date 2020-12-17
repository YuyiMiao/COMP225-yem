import 'package:intl/intl.dart';

import 'EmotionBox.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'EmotionListModel.dart';
import 'Emotion.dart';
import 'package:flutter/cupertino.dart';

void main() {
  final emotions = EmotionListModel();
  runApp(
      ScopedModel<EmotionListModel>(
        model: emotions, child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emotion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Emotion tracker'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(this.title)),
        body: ScopedModelDescendant<EmotionListModel>(
          builder: (context, child, emotions) {
            return ListView.separated(
              itemCount: emotions.items == null ? 1: emotions.items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(title: Text("Please record your emotion!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),));
                } else {
                  index = index - 1;
                  return Dismissible(key: Key(emotions.items[index].id.toString()),
                      onDismissed: (direction) {
                        emotions.delete(emotions.items[index]);
                        Scaffold.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Item with id, " +
                                    emotions.items[index].id.toString() +
                                    "is dismissed")
                            )
                        );
                      },
                      child: ListTile( onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => FormPage(
                              id: emotions.items[index].id, emotions: emotions,
                            )
                        ));
                      },
                          title: EmotionBox(
                            date: emotions.items[index].formattedDate,
                            description: emotions.items[index].description,
                            image: emotions.items[index].imageNo,
                          ))
                  );
                }
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            );
          },
        ),
        floatingActionButton: ScopedModelDescendant<EmotionListModel> (
            builder: (context, child, emotion) {
              return FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context)
                      => ScopedModelDescendant<EmotionListModel>(
                          builder: (context, child, emotions) {
                            return FormPage(id: 0, emotions: emotions,);
                          }
                      )
                  )
                  );
                },
                tooltip: 'Increment', child: Icon(Icons.add),
              );
            }
        )
    );
  }
}

class FormPage extends StatefulWidget {
  FormPage({Key key, this.id, this.emotions}) : super(key:key);
  final int id;
  final EmotionListModel emotions;

  @override
  _FormPageState createState() => _FormPageState(id: id, emotions: emotions);
}

class _FormPageState extends State<FormPage> {
  _FormPageState({Key key, this.id, this.emotions});
  final int id;
  final EmotionListModel emotions;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  double _imageNo;
  DateTime _date;
  String _description;
  List<bool> _buttonState = List.generate(6, (index) => false);

  DateTime selectedDate = DateTime.now();

  void _submit() {
    final form = formKey.currentState;
    int num = 0;
    for(int i = 0; i < 6; i++){
      if(_buttonState[i] == true){
        num = i + 1;
      }
    }
    if (form.validate()) {
      form.save();
      if (this.id == 0) emotions.add(Emotion(0, num.toDouble(), selectedDate, _description));
      else emotions.update(Emotion(this.id, num.toDouble(), selectedDate, _description));
      Navigator.pop(context);
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, appBar: AppBar(
      title: Text('Enter emotion details'),
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey, child: Column(
          children: [
            ToggleButtons(
              children: [
                Image.asset("assets/appimages/1.png", height:55, width:55),
                Image.asset("assets/appimages/2.png", height:55, width:55),
                Image.asset("assets/appimages/3.png", height:55, width:55),
                Image.asset("assets/appimages/4.png", height:55, width:55),
                Image.asset("assets/appimages/5.png", height:55, width:55),
                Image.asset("assets/appimages/6.png", height:55, width:55)
              ],
              isSelected: _buttonState,
              selectedColor: Colors.greenAccent,
              splashColor: Colors.teal,
              selectedBorderColor: Colors.greenAccent,
              borderWidth: 5,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              onPressed: (int index) => {
                setState(() {
                  _buttonState[index] = !_buttonState[index];
                  for(var i = 0; i <= 5;i++){
                    if(i != index){_buttonState[i] = false;}
                  }
                })
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                'Select The Date',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30),
              ),
              color: Colors.blue,
            ),
            TextFormField(
              style: TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                  icon: const Icon(Icons.book),
                  labelText: 'Words',
                  labelStyle: TextStyle(fontSize: 20)
              ),
              onSaved: (val) => _description = val,
              initialValue: id == 0 ? '' : emotions.byId(id).description.toString(),
            ),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: _submit,
              child:
              new Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30)),
              color: Colors.blue,
            ),
          ],
        ),
        ),
      ),
    );
  }
}


