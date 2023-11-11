// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String email;
  final String password;
  final String uid;
  UserModel({
    required this.email,
    required this.password,
    required this.uid,
  });

  UserModel copyWith({
    String? email,
    String? password,
    String? uid,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      password: map['password'] as String,
      uid: map['uid'] as String,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory UserModel.fromJson(String source) =>
  //     UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserModel(email: $email, password: $password, uid: $uid)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.password == password &&
        other.uid == uid;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode ^ uid.hashCode;

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
