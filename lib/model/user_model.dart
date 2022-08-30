import 'dart:convert';

class User {
  late int id;
  late String name;
  late String sex;
  late String profileImage;
  late String address;
  late String userDOB;
  User(
      {required this.id,
      required this.name,
      required this.sex,
      required this.address,
      required this.profileImage,
      required this.userDOB});
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];
}
