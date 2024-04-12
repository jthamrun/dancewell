import 'dart:convert';

class BodyHistory {
  String name;
  DateTime date;

  BodyHistory({required this.name, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date.toString(),
    };
  }

  factory BodyHistory.fromMap(Map<String, dynamic> map) {
    return BodyHistory(
      name: map['name'],
      date: DateTime.parse(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BodyHistory.fromJson(String source) =>
      BodyHistory.fromMap(json.decode(source));
}
