import 'package:flutter/material.dart';

import '../models/task_models.dart';
import 'task_tile.dart';

class TaskQuadrantTile extends StatelessWidget {
  const TaskQuadrantTile({
    super.key,
    required this.quadrant,
    required this.tasks,
    required this.onToggleTask,
    required this.onEditTask,
    required this.onDeleteTask,
  });

  final QuadrantType quadrant;
  final List<TaskModel> tasks;

  final void Function(TaskModel task, bool completed) onToggleTask;
  final void Function(TaskModel task) onEditTask;
  final void Function(TaskModel task) onDeleteTask;

  @override
  Widget build(BuildContext context) {
    final base = quadrant.color;

    final cardBg = Color.alphaBlend(
      Theme.of(context).colorScheme.surface,
      base.withValues(alpha: 0.10),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.10),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: base.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: base,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    quadrant.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (tasks.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: base.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${tasks.length}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: tasks.isEmpty
                  ? _EmptyState(quadrant: quadrant)
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskTile(
                          task: task,
                          onToggleCompleted: (v) => onToggleTask(task, v),
                          onEdit: () => onEditTask(task),
                          onDelete: () => onDeleteTask(task),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.quadrant});

  final QuadrantType quadrant;

  @override
  Widget build(BuildContext context) {
    final base = quadrant.color;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 34,
              color: base.withValues(alpha: 0.55),
            ),
            const SizedBox(height: 10),
            Text(
              'No tasks yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add one to get started.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
