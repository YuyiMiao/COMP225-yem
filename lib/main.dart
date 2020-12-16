import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'screen/rewind_screen.dart';
import 'ui_ux/emotion_box.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/emotion_list_model.dart';
import 'model/emotion.dart';
import 'screen/form_screen.dart';
import 'screen/general_screen.dart';
import 'ui_ux/nav_bar.dart';
import 'helper.dart';
import 'ui_ux/page_icon.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      title: 'Emotion',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome>
    with TickerProviderStateMixin {
  AnimationController animationController;
  bool multiple = true;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  int id = 0;
  Widget tabBody = Container(
    color: Colors.white,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    tabBody =  MyGeneral(animationController : animationController,);


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  void enterForm() {
    tabIconsList[0].isSelected = true;
    for(var i = 1; i <= 3; i++){
      tabIconsList[i].isSelected = false;
    }
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            animationController.reverse().then<dynamic>((data) {
              if (!mounted) {
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)
                => ScopedModelDescendant<EmotionListModel>(
                    builder: (context, child, emotions) {
                      return MyForm(id: id, emotions: emotions,);
                    }
                    )
                ),
              );
           //   enterForm();
            });
          },

          changeIndex: (int index) {
            if (index == 0) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MyGeneral(animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MyRewind(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}

