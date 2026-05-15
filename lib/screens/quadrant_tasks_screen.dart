import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

import '../models/task_models.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

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

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.getTasksByQuadrant(quadrant);

    return Scaffold(
      appBar: AppBar(
        title: Text(quadrant.title),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks in this quadrant',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            )
          : ReorderableListView(
              padding: const EdgeInsets.all(16),
              onReorder: (oldIndex, newIndex) {
                // Adjust indices for ReorderableListView
                // When dragging down, the target index is reduced by 1
                int adjustedOldIndex = oldIndex;
                int adjustedNewIndex = newIndex;
                
                if (oldIndex < newIndex) {
                  adjustedNewIndex = newIndex - 1;
                }
                
                // Call the reorder method on the provider
                taskProvider.reorderTasks(quadrant, adjustedOldIndex, adjustedNewIndex);
              },
              children: tasks.asMap().entries.map((entry) {
                final index = entry.key;
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
    );
  }
}