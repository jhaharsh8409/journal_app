import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:journal/api/global_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class auth_backend {
  bool state = false;
  bool loading = false;
  var selected_user;

  List<Map<String, dynamic>> js_data = [];

  Future<void> fetch_user_details(user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final userMap =
    js_data.firstWhere((u) => u["name"] == user, orElse: () => {});

    print("Selected User ID = ${userMap["id"]} & Selected User name = ${userMap["name"]}");
    prefs.setString('selected_user', userMap["name"]);
    prefs.setString('selected_user_id', userMap["id"]);
    prefs.setBool('logged', true);
    global_data.username = userMap["name"];
    global_data.userId = userMap["id"];

    await Future.delayed(Duration(seconds: 2)); // simulate server delay
  }

  Future<Object> fetch_username() async {
    js_data.clear();

    QuerySnapshot usersSnapshot =
    await FirebaseFirestore.instance.collection('users').get();

    for (var doc in usersSnapshot.docs) {
      js_data.add({
        "id": doc.id,
        "name": doc['name'],
      });
    }

    return '';
  }
}
