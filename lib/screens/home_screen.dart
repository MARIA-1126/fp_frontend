import 'package:flutter/material.dart';

import '../models/task_models.dart';
import '../utils/id_utils.dart';
import '../widgets/task_quadrant_tile.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onToggleDarkMode;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TaskModel> _tasks = [
    TaskModel(
      id: '1',
      title: 'Finish assignment',
      note: 'Complete the final draft and submit.',
      quadrant: QuadrantType.importantUrgent,
      isCompleted: false,
    ),
    TaskModel(
      id: '2',
      title: 'Buy groceries',
      note: 'Milk, eggs, and vegetables.',
      quadrant: QuadrantType.importantUrgent,
      isCompleted: true,
    ),
    TaskModel(
      id: '3',
      title: 'Gym workout',
      note: '45 minutes - strength + cardio.',
      quadrant: QuadrantType.notImportantUrgent,
      isCompleted: false,
    ),
    TaskModel(
      id: '4',
      title: 'Study Flutter',
      note: 'Practice widgets + state management concepts.',
      quadrant: QuadrantType.importantNotUrgent,
      isCompleted: false,
    ),
  ];

  bool _notificationsEnabled = true;

  List<TaskModel> _tasksFor(QuadrantType q) {
    return _tasks.where((t) => t.quadrant == q).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  void _toggleTaskCompleted(TaskModel task, bool completed) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index == -1) return;
      _tasks[index] = _tasks[index].copyWith(isCompleted: completed);
    });
  }

  void _deleteTask(TaskModel task) {
    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task deleted')));
    }
  }

  Future<void> _openEditTask(TaskModel task) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditTaskScreen(
          initialTask: task,
          onSave:
              ({required title, required note, required quadrant, dueDate}) {
                setState(() {
                  final index = _tasks.indexWhere((t) => t.id == task.id);
                  if (index == -1) return;
                  final updated = _tasks[index].copyWith(
                    title: title,
                    note: note,
                    quadrant: quadrant,
                    dueDate: dueDate,
                  );
                  _tasks[index] = updated;
                });

                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Task updated')));
                }
              },
        ),
      ),
    );
  }

  Future<void> _openAddTask() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(
          onSave:
              ({required title, required note, required quadrant, dueDate}) {
                setState(() {
                  _tasks.add(
                    TaskModel(
                      id: IdUtils.generateId(),
                      title: title,
                      note: note,
                      quadrant: quadrant,
                      dueDate: dueDate,
                    ),
                  );
                });

                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Task added')));
                }
              },
        ),
      ),
    );
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          isDarkMode: widget.isDarkMode,
          onDarkModeChanged: (v) => widget.onToggleDarkMode(v),
          notificationsEnabled: _notificationsEnabled,
          onNotificationsChanged: (v) {
            setState(() => _notificationsEnabled = v);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eisenhower Matrix'),
        actions: [
          IconButton(
            onPressed: _openSettings,
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTask,
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive: use 2 columns always, but spacing adapts.
            final padding = constraints.maxWidth < 380 ? 10.0 : 16.0;

            return Padding(
              padding: EdgeInsets.all(padding),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: constraints.maxHeight > 800 ? 0.95 : 0.92,
                children: [
                  TaskQuadrantTile(
                    quadrant: QuadrantType.importantUrgent,
                    tasks: _tasksFor(QuadrantType.importantUrgent),
                    onToggleTask: _toggleTaskCompleted,
                    onEditTask: _openEditTask,
                    onDeleteTask: _deleteTask,
                  ),
                  TaskQuadrantTile(
                    quadrant: QuadrantType.importantNotUrgent,
                    tasks: _tasksFor(QuadrantType.importantNotUrgent),
                    onToggleTask: _toggleTaskCompleted,
                    onEditTask: _openEditTask,
                    onDeleteTask: _deleteTask,
                  ),
                  TaskQuadrantTile(
                    quadrant: QuadrantType.notImportantUrgent,
                    tasks: _tasksFor(QuadrantType.notImportantUrgent),
                    onToggleTask: _toggleTaskCompleted,
                    onEditTask: _openEditTask,
                    onDeleteTask: _deleteTask,
                  ),
                  TaskQuadrantTile(
                    quadrant: QuadrantType.notImportantNotUrgent,
                    tasks: _tasksFor(QuadrantType.notImportantNotUrgent),
                    onToggleTask: _toggleTaskCompleted,
                    onEditTask: _openEditTask,
                    onDeleteTask: _deleteTask,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
