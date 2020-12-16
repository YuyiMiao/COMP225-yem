import 'dart:collection';
import 'package:scoped_model/scoped_model.dart';
import '../model/emotion.dart';
import '../sqlite_db_provider.dart';

class EmotionListModel extends Model {
  EmotionListModel() {
    this.load();
  }
  final List<Emotion> _items = [];
  UnmodifiableListView<Emotion> get items => UnmodifiableListView(_items);

  void load() {
    Future<List<Emotion>> list = SQLiteDbProvider.db.getAllEmotions();
    list.then((dbItems) {
      for(var i = 0; i < dbItems.length; i++) {
        _items.add(dbItems[i]);
      }
      notifyListeners();
    });
  }

  Emotion byId(int id) {
    for(var i = 0; i < _items.length; i++) {
      if(_items[i].id == id) {
        return _items[i];
      }
    }
    return null;
  }

  void add(Emotion item) {
    SQLiteDbProvider.db.insert(item).then((val) {
      _items.add(val);
      notifyListeners();
    });
  }

  void update(Emotion item) {
    bool found = false;
    for(var i = 0; i < _items.length; i++) {
      if(_items[i].id == item.id) {
        _items[i] = item;
        found = true;
        SQLiteDbProvider.db.update(item);
        break;
      }
    }
    if(found) notifyListeners();
  }

  void delete(Emotion item) {
    bool found = false;
    for(var i = 0; i < _items.length; i++) {
      if(_items[i].id == item.id) {
        found = true;
        SQLiteDbProvider.db.delete(item.id);
        _items.removeAt(i);
        break;
      }
    }
    if(found) notifyListeners();
  }
}