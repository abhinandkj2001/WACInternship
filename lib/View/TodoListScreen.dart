import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Model/Todo.dart';
import '../ViewModel/TodoProvider.dart';
import 'LoginPage.dart';


class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<TodoViewModel>(context, listen: false).logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<TodoViewModel>(
        builder: (context, todoViewModel, child) {
          return ListView.builder(
            itemCount: todoViewModel.todos.length,
            itemBuilder: (context, index) {
              final todo = todoViewModel.todos[index];
              return ListTile(
                title: Text(todo.task),
                subtitle: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(todo.createdAt)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editTodoItem(context, todoViewModel, index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteTodoItem(context, todoViewModel, index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodoItem(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTodoItem(BuildContext context) async {
    final newTodo = await showDialog<Todo>(
      context: context,
      builder: (context) {
        final TextEditingController taskController = TextEditingController();
        DateTime? selectedDate;
        TimeOfDay? selectedTime;
        final _formKey = GlobalKey<FormState>();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Todo'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: taskController,
                      decoration: InputDecoration(hintText: 'Enter your todo'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a task';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      title: Text("Date: ${selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : 'Select Date'}"),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text("Time: ${selectedTime != null ? selectedTime?.format(context) : 'Select Time'}"),
                      trailing: Icon(Icons.access_time),
                      onTap: () async {
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime ?? TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && selectedDate != null && selectedTime != null) {
                      final task = taskController.text;
                      final createdAt = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );
                      Navigator.of(context).pop(Todo(
                        task: task,
                        createdAt: createdAt,
                      ));
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
    if (newTodo != null) {
      Provider.of<TodoViewModel>(context, listen: false).addTodo(newTodo);
    }
  }

  void _editTodoItem(BuildContext context, TodoViewModel todoViewModel, int index) async {
    final TextEditingController taskController = TextEditingController(text: todoViewModel.todos[index].task);
    DateTime selectedDate = todoViewModel.todos[index].createdAt;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectedDate);
    final _formKey = GlobalKey<FormState>();

    final newTodo = await showDialog<Todo>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Todo'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: taskController,
                      decoration: InputDecoration(hintText: 'Edit your todo'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a task';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      title: Text("Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text("Time: ${selectedTime.format(context)}"),
                      trailing: Icon(Icons.access_time),
                      onTap: () async {
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null && picked != selectedTime) {
                          setState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final task = taskController.text;
                      final createdAt = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                      Navigator.of(context).pop(Todo(
                        task: task,
                        createdAt: createdAt,
                      ));
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
    if (newTodo != null) {
      todoViewModel.editTodo(index, newTodo);
    }
  }

  void _deleteTodoItem(BuildContext context, TodoViewModel todoViewModel, int index) {
    todoViewModel.deleteTodo(index);
  }
}
