import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../Model/Todo.dart';

class TodoViewModel extends ChangeNotifier {
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  Future<void> loadTodos() async {
    // Load todos from persistent storage if needed
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void editTodo(int index, Todo newTodo) {
    _todos[index] = newTodo;
    notifyListeners();
  }

  void deleteTodo(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }

  Future<bool> checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> login(String username, String password) async {
    if (username == 'abhi' && password == '12345') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
  }
}
