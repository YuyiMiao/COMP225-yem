import 'package:intl/intl.dart';

class Emotion {
  final int id;
  final double imageNo;
  final DateTime date;
  final String description;

  String get formattedDate {
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(this.date);
  }

  static final columns = ['id', 'imageNo', 'date', 'description'];

  Emotion(this.id, this.imageNo, this.date, this.description);

  factory Emotion.fromMap (Map<String, dynamic> data) {
    return Emotion(data['id'],
        data['imageNo'],
        DateTime.parse(data['date']),
        data['description']);
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "imageNo": imageNo,
    "date": date.toString(),
    "description": description
  };
}