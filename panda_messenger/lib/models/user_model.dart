import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    this.id,
    this.email,
    this.joinDate,
  });

  String? id;
  String? email;
  String? joinDate;

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
        id: data?['id'], email: data?['email'], joinDate: data?['joinDate']);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      joinDate: json['joinDate'],
    );
  }

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'email': email,
        'joinDate': joinDate,
      };
}
