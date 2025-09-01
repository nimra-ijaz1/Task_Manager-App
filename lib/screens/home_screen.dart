import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import 'add_task_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('tasks');
    if (data != null) {
      List decoded = jsonDecode(data);
      setState(() {
        tasks = decoded.map((e) => Task.fromMap(e)).toList();
      });
    }
  }

  void saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', jsonEncode(tasks.map((e) => e.toMap()).toList()));
  }

  void addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
    });
    saveTasks();
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    saveTasks();
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
    saveTasks();
  }

  void navigateToAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddTaskScreen()),
    );
    if (result != null) {
      addTask(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Manager',
          style: GoogleFonts.pacifico(),
        ),
        backgroundColor: Colors.pink[300],
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddTask,
          )
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/home_bg.jpg', // Add your home screen bg image here
              fit: BoxFit.cover,
            ),
          ),
          // Optional overlay for readability
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          // Task List
          tasks.isEmpty
              ? Center(
            child: Text(
              'No tasks yet! 🌸',
              style: GoogleFonts.pacifico(
                  fontSize: 22, color: Colors.pink[900]),
            ),
          )
              : ListView.builder(
            itemCount: tasks.length,
            padding: EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                color: Colors.pink[100]?.withOpacity(0.8),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    task.title,
                    style: GoogleFonts.pacifico(
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : null,
                      fontSize: 18,
                      color: Colors.pink[900],
                    ),
                  ),
                  leading: IconButton(
                    icon: Icon(
                      task.isDone
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: Colors.pink[800],
                    ),
                    onPressed: () => toggleTask(index),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red[400]),
                    onPressed: () => deleteTask(index),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
