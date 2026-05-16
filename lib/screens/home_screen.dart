import 'package:flutter/material.dart';
// import 'package:fp_frontend/services/notification_service.dart';
import 'package:provider/provider.dart';

import '../models/task_models.dart';
import '../providers/task_provider.dart';
import '../utils/id_utils.dart';  // Add this import
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
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    // Load tasks when the screen first opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }

  Future<void> _openEditTask(TaskModel task) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditTaskScreen(
          initialTask: task,
          onSave: ({
            required title,
            required note,
            required quadrant,
            dueDate,
          }) async {
            final updated = task.copyWith(
              title: title,
              note: note,
              quadrant: quadrant,
              dueDate: dueDate,
            );
            await taskProvider.updateTask(task.id, updated);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task updated')),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _openAddTask() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(
          onSave: ({
            required title,
            required note,
            required quadrant,
            dueDate,
          }) async {
            final task = TaskModel(
              id: IdUtils.generateId(),
              title: title,
              note: note,
              quadrant: quadrant,
              dueDate: dueDate,
            );
            await taskProvider.addTask(task);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task added')),
              );
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
    // REMOVE THIS LINE: final tasks = taskProvider.tasks;
    final taskProvider = Provider.of<TaskProvider>(context);

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
            final padding = constraints.maxWidth < 380 ? 10.0 : 16.0;

            if (taskProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

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
                    tasks: taskProvider.getTasksByQuadrant(QuadrantType.importantUrgent),
                    onToggleTask: (task, completed) => 
                        taskProvider.toggleTaskComplete(task.id, completed),
                    onEditTask: _openEditTask,
                    onDeleteTask: (task) => taskProvider.deleteTask(task.id),
                  ),
                  TaskQuadrantTile(
                    quadrant: QuadrantType.importantNotUrgent,
                    tasks: taskProvider.getTasksByQuadrant(QuadrantType.importantNotUrgent),
                    onToggleTask: (task, completed) => 
                        taskProvider.toggleTaskComplete(task.id, completed),
                    onEditTask: _openEditTask,
                    onDeleteTask: (task) => taskProvider.deleteTask(task.id),
                  ),
                  TaskQuadrantTile(
                    quadrant: QuadrantType.notImportantUrgent,
                    tasks: taskProvider.getTasksByQuadrant(QuadrantType.notImportantUrgent),
                    onToggleTask: (task, completed) => 
                        taskProvider.toggleTaskComplete(task.id, completed),
                    onEditTask: _openEditTask,
                    onDeleteTask: (task) => taskProvider.deleteTask(task.id),
                  ),
                  TaskQuadrantTile(
                    quadrant: QuadrantType.notImportantNotUrgent,
                    tasks: taskProvider.getTasksByQuadrant(QuadrantType.notImportantNotUrgent),
                    onToggleTask: (task, completed) => 
                        taskProvider.toggleTaskComplete(task.id, completed),
                    onEditTask: _openEditTask,
                    onDeleteTask: (task) => taskProvider.deleteTask(task.id),
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