import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import '../utils/id_utils.dart';
import '../models/task_models.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';

class QuadrantTasksScreen extends StatelessWidget {
  const QuadrantTasksScreen({
    super.key,
    required this.quadrant,
    required this.onToggleTask,
    required this.onEditTask,
    required this.onDeleteTask,
  });

  final QuadrantType quadrant;
  final void Function(TaskModel task, bool completed) onToggleTask;
  final void Function(TaskModel task) onEditTask;
  final void Function(TaskModel task) onDeleteTask;

  // ✅ Fix: Pass context as a parameter
  Future<void> _openAddTask(BuildContext context) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(
          initialQuadrant: quadrant,
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
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Task added')));
                }
              },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.getTasksByQuadrant(quadrant);

    return Scaffold(
      appBar: AppBar(title: Text(quadrant.title), centerTitle: true),
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks in this quadrant',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            )
          : ReorderableListView(
              padding: const EdgeInsets.all(16),
              // Remove buildDefaultDragHandles if it's causing issues
              onReorder: (oldIndex, newIndex) {
                int adjustedOldIndex = oldIndex;
                int adjustedNewIndex = newIndex;

                if (oldIndex < newIndex) {
                  adjustedNewIndex = newIndex - 1;
                }

                taskProvider.reorderTasks(
                  quadrant,
                  adjustedOldIndex,
                  adjustedNewIndex,
                );
              },
              children: tasks.asMap().entries.map((entry) {
                final task = entry.value;
                return Padding(
                  key: Key(task.id),
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TaskTile(
                    task: task,
                    onToggleCompleted: (v) {
                      onToggleTask(task, v);
                    },
                    onEdit: () {
                      onEditTask(task);
                    },
                    onDelete: () {
                      onDeleteTask(task);
                    },
                  ),
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTask(context), // ✅ Pass context here
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
