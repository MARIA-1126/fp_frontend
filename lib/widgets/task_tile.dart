import 'package:flutter/material.dart';

import '../models/task_models.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggleCompleted,
    required this.onEdit,
    required this.onDelete,
  });

  final TaskModel task;
  final ValueChanged<bool> onToggleCompleted;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.isCompleted;

    final titleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: isCompleted
          ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45)
          : Theme.of(context).colorScheme.onSurface,
      decoration: isCompleted ? TextDecoration.lineThrough : null,
      decorationColor: Theme.of(
        context,
      ).colorScheme.onSurface.withValues(alpha: 0.35),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onLongPress: () {
          showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            builder: (context) {
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit_outlined),
                      title: const Text('Edit'),
                      onTap: () {
                        Navigator.of(context).pop();
                        onEdit();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete_outline),
                      title: const Text('Delete'),
                      onTap: () {
                        Navigator.of(context).pop();
                        onDelete();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: isCompleted,
                onChanged: (v) {
                  if (v == null) return;
                  onToggleCompleted(v);
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: titleStyle,
                    ),
                    if (task.note != null && task.note!.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          task.note!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: isCompleted
                                    ? Theme.of(context).colorScheme.onSurface
                                          .withValues(alpha: 0.35)
                                    : Theme.of(context).colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                              ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
