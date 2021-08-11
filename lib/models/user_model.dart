import 'dart:convert';

class UserModel {
  final String uuid;
  final String name;
  final String email;
  UserModel({
    required this.uuid,
    required this.name,
    required this.email,
  });

  UserModel copyWith({
    String? name,
    String? email,
  }) {
    return UserModel(
      uuid: this.uuid,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uuid: map['uuid'],
      name: map['name'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserModel(uuid: $uuid, name: $name, email: $email)';
}
