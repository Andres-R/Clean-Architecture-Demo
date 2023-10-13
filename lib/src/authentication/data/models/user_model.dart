import 'dart:convert';

import 'package:clean_arch_course/core/utils/typedef.dart';
import 'package:clean_arch_course/src/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.avatar,
  });

  const UserModel.empty()
      : this(
          id: "1",
          name: 'empty.name',
          createdAt: 'empty.createdAt',
          avatar: 'empty.avatar',
        );

  factory UserModel.fromJson(String source) {
    return UserModel.fromMap(jsonDecode(source) as DataMap);
  }

  UserModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          name: map['name'] as String,
          createdAt: map['createdAt'] as String,
          avatar: map['avatar'] as String,
        );

  UserModel copyWith({
    String? id,
    String? name,
    String? createdAt,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      avatar: avatar ?? this.avatar,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt,
      'avatar': avatar,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
