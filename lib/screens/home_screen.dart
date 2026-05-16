import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task_models.dart';
import '../providers/task_provider.dart';
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
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
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
          onSave:
              ({
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
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(
          onSave:
              ({
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
    final taskProvider = Provider.of<TaskProvider>(context);
    final pendingCount = taskProvider.getPendingTaskCount();

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
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Add Pending Tasks Widget at the top
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.pending_actions,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pending Tasks',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$pendingCount task${pendingCount == 1 ? '' : 's'} pending completion',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (pendingCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        pendingCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ✅ Matrix Grid
            Expanded(
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
                      childAspectRatio: constraints.maxHeight > 800
                          ? 0.75
                          : 0.72,
                      children: [
                        TaskQuadrantTile(
                          quadrant: QuadrantType.importantUrgent,
                          tasks: taskProvider.getTasksByQuadrant(
                            QuadrantType.importantUrgent,
                          ),
                          onToggleTask: (task, completed) => taskProvider
                              .toggleTaskComplete(task.id, completed),
                          onEditTask: _openEditTask,
                          onDeleteTask: (task) =>
                              taskProvider.deleteTask(task.id),
                        ),
                        TaskQuadrantTile(
                          quadrant: QuadrantType.importantNotUrgent,
                          tasks: taskProvider.getTasksByQuadrant(
                            QuadrantType.importantNotUrgent,
                          ),
                          onToggleTask: (task, completed) => taskProvider
                              .toggleTaskComplete(task.id, completed),
                          onEditTask: _openEditTask,
                          onDeleteTask: (task) =>
                              taskProvider.deleteTask(task.id),
                        ),
                        TaskQuadrantTile(
                          quadrant: QuadrantType.notImportantUrgent,
                          tasks: taskProvider.getTasksByQuadrant(
                            QuadrantType.notImportantUrgent,
                          ),
                          onToggleTask: (task, completed) => taskProvider
                              .toggleTaskComplete(task.id, completed),
                          onEditTask: _openEditTask,
                          onDeleteTask: (task) =>
                              taskProvider.deleteTask(task.id),
                        ),
                        TaskQuadrantTile(
                          quadrant: QuadrantType.notImportantNotUrgent,
                          tasks: taskProvider.getTasksByQuadrant(
                            QuadrantType.notImportantNotUrgent,
                          ),
                          onToggleTask: (task, completed) => taskProvider
                              .toggleTaskComplete(task.id, completed),
                          onEditTask: _openEditTask,
                          onDeleteTask: (task) =>
                              taskProvider.deleteTask(task.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTask,
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
