// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'danh sach cong viec',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskList(),
    );
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> _tasks = [
    Task(
        title: 'lam bai tap',
        deadline: DateTime.now().subtract(Duration(days: 1))),
    Task(title: 'di tap gym', deadline: DateTime.now().add(Duration(days: 2))),
    Task(title: 'don nha', deadline: DateTime.now().add(Duration(days: 3))),
  ];

  void _addTask() async {
    final task = await showDialog<Task>(
      context: context,
      builder: (context) => AddTaskDialog(),
    );
    if (task != null) {
      setState(() {
        _tasks.add(task);
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Danh sách công việc')),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          final isOverdue = DateTime.now().isAfter(task.deadline);
          return ListTile(
            title: Text(task.title),
            subtitle:
            Text('Deadline: ${DateFormat.yMd().format(task.deadline)}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteTask(index),
            ),
            tileColor: isOverdue ? Colors.red[100] : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime _deadline = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thêm công việc'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'chu thich'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'nhap tieu de';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final newDeadline = await showDatePicker(
                  context: context,
                  initialDate: _deadline,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (newDeadline != null) {
                  setState(() {
                    _deadline = newDeadline;
                  });
                }
              },
              child: Row(
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 8),
                  Text(DateFormat.yMd().format(_deadline)),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: ()=> Navigator.of(context).pop(),
            child: Text('Thoát',style: TextStyle(color: Colors.white),)
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final task = Task(
                title: _titleController.text,
                deadline: _deadline,
              );
              Navigator.of(context).pop(task);
            }
          },
          child: Text('Lưu'),
        ),
      ],
    );
  }
}

class Task {
  final String title;
  final DateTime deadline;
  bool isCompleted = false;

  Task({
    required this.title,
    required this.deadline,
  });
}
