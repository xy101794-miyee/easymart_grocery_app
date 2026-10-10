import 'package:flutter/material.dart';

class UserModel {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String passwordHash;
  final String role;
  final String? createdAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.passwordHash,
    required this.role,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      passwordHash: map['password_hash'] as String? ?? '',
      role: map['role'] as String? ?? 'User',
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password_hash': passwordHash,
      'role': role,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
    };
  }
}
