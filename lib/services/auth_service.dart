import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';
import '../models/user_model.dart';

class AuthService {
  static Future<UserModel?> login(String email, String password) async {
    final user = await DatabaseHelper.instance.loginUser(email.trim(), password);
    if (user == null) return null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('logged_in_user_id', user.id ?? 0);
    await prefs.setString('logged_in_user_role', user.role);
    return user;
  }

  static Future<UserModel?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final normalizedEmail = email.trim();
    final hashed = sha256.convert(utf8.encode(password)).toString();

    final newUser = UserModel(
      name: name.trim(),
      email: normalizedEmail,
      phone: phone.trim(),
      passwordHash: hashed,
      role: 'User',
    );

    final id = await DatabaseHelper.instance.registerUser(newUser);
    final user = UserModel(
      id: id,
      name: name.trim(),
      email: normalizedEmail,
      phone: phone.trim(),
      passwordHash: hashed,
      role: 'User',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('logged_in_user_id', id);
    await prefs.setString('logged_in_user_role', 'User');
    return user;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_user_id');
    await prefs.remove('logged_in_user_role');
  }

  static Future<int?> getLoggedInUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('logged_in_user_id');
  }

  static Future<String> getLoggedInRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('logged_in_user_role') ?? 'User';
  }
}
