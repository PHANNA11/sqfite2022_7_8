import 'dart:convert';

class User {
  late int id;
  late String name;
  User({required this.id, required this.name});
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];
}
