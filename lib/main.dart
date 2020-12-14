// import 'dart:html';

import 'EmotionBox.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'EmotionListModel.dart';
import 'Emotion.dart';

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

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      if (this.id == 0) emotions.add(Emotion(0, _imageNo, _date, _description));
      else emotions.update(Emotion(this.id, _imageNo, _date, _description));
      Navigator.pop(context);
    }
  }

  void _setAngry() {
    emotions.update(Emotion(this.id, 1, _date, _description));
  }
  void _setAnxious() {
    emotions.update(Emotion(this.id, 2, _date, _description));
  }
  void _setConfused() {
    emotions.update(Emotion(this.id, 3, _date, _description));
  }
  void _setHappy() {
    emotions.update(Emotion(this.id, 4, _date, _description));
  }
  void _setMeh() {
    emotions.update(Emotion(this.id, 5, _date, _description));
  }
  void _setSad() {
    emotions.update(Emotion(this.id, 6, _date, _description));
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
            TextFormField(
              style: TextStyle(fontSize: 22),
              decoration: const InputDecoration(
                  icon: const Icon(Icons.image),
                  labelText: 'Number of the emoji',
                  labelStyle: TextStyle(fontSize: 18)
              ),
              initialValue: id == 0 ? ''
                  : emotions.byId(id).imageNo.toString(),
              onSaved: (val) => _imageNo = double.parse(val),
            ),
            TextFormField(
              style: TextStyle(fontSize: 22),
              decoration: const InputDecoration(
                icon: const Icon(Icons.calendar_today),
                hintText: 'Enter date',
                labelText: 'Date',
                labelStyle: TextStyle(fontSize: 18),
              ),
              validator: (val) {
                Pattern pattern = r'^((?:19|20)\d\d)[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(val)) return 'Enter a valid date';
                else return null;
              },
              onSaved: (val) => _date = DateTime.parse(val),
              initialValue: id == 0 ? '' : emotions.byId(id).formattedDate,
              keyboardType: TextInputType.datetime,
            ),
            TextFormField(
              style: TextStyle(fontSize: 22),
              decoration: const InputDecoration(
                  icon: const Icon(Icons.book),
                  labelText: 'Words',
                  labelStyle: TextStyle(fontSize: 18)
              ),
              onSaved: (val) => _description = val,
              initialValue: id == 0 ? '' : emotions.byId(id).description.toString(),
            ),
            IconButton(
              icon: Image.asset('assets/appimages/happy.png'),
              iconSize: 75,
              onPressed: _setHappy,
            ),
            IconButton(
              icon: Image.asset('assets/appimages/confused.png'),
              iconSize: 75,
              onPressed: _setConfused,
            ),
            IconButton(
              icon: Image.asset('assets/appimages/anxious.png'),
              iconSize: 75,
              onPressed: _setAnxious,
            ),
            IconButton(
              icon: Image.asset('assets/appimages/meh.png'),
              iconSize: 75,
              onPressed: _setMeh,
            ),
            IconButton(
              icon: Image.asset('assets/appimages/sad.png'),
              iconSize: 75,
              onPressed: _setSad,
            ),
            IconButton(
              icon: Image.asset('assets/appimages/angry.png'),
              iconSize: 75,
              onPressed: _setAngry,
            ),
            RaisedButton(
              onPressed: _submit,
              child: new Text('Submit'),
            ),
          ],
    ),
    ),
    ),
    );
  }
}


