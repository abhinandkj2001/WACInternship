import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'View/LoginPage.dart';
import 'View/TodoListScreen.dart';
import 'ViewModel/TodoProvider.dart';


void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoViewModel(),
      child: MaterialApp(
        title: 'Todo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthCheck(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<TodoViewModel>(context, listen: false).checkLoginState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data == true) {
          return TodoListScreen();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
