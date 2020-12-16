import 'package:flutter/material.dart';
import 'form_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/emotion_list_model.dart';
import '../ui_ux/emotion_box.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';


class MyRewind extends StatefulWidget {
  MyRewind({Key key, this.animationController}) : super(key: key);
  final AnimationController animationController;

  @override
  _MyRewindState createState() => _MyRewindState();
}

class _MyRewindState extends State<MyRewind> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[120],
        body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 70),
              child: ScopedModelDescendant<EmotionListModel>(
              builder: (context, child, emotions) {
                return DraggableScrollbar.arrows(
                  controller: controller,
                  backgroundColor: Colors.brown,
                  alwaysVisibleScrollThumb: true,
                  child: ListView.separated(
                    controller: controller,
                    itemCount: emotions.items == null ? 1: emotions.items.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Center(child: Text("Your Recorded Emotion!",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),));
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
                                  builder: (context) => MyForm(
                                    id: emotions.items[index].id, emotions: emotions,
                                  )
                              ));
                            },
                                title: EmotionBox(
                                  date: emotions.items[index].formattedDate,
                                  description: emotions.items[index].description,
                                  image: emotions.items[index].imageNo.toInt(),
                                ))
                        );
                      }
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                );
              },
            ),
        ),
    );


  }
}
