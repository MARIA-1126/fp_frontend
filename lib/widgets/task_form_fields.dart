import 'package:flutter/material.dart';

import '../models/task_models.dart';

class TaskFormFields extends StatelessWidget {
  const TaskFormFields({
    super.key,
    required this.titleController,
    required this.noteController,
    required this.selectedQuadrant,
    required this.onQuadrantChanged,
    required this.dueDate,
    required this.onPickDueDate,
    required this.dateEnabled,
  });

  final TextEditingController titleController;
  final TextEditingController noteController;

  final QuadrantType selectedQuadrant;
  final ValueChanged<QuadrantType?> onQuadrantChanged;

  final DateTime? dueDate;
  final VoidCallback onPickDueDate;

  /// Allows disabling date picker UI if desired.
  final bool dateEnabled;

  @override
  Widget build(BuildContext context) {
    final dateText = dueDate == null
        ? 'No date selected'
        : '${dueDate!.year}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: titleController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Task title',
            hintText: 'e.g., Study Flutter',
            prefixIcon: Icon(Icons.title_outlined),
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'Title is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: noteController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Note (optional)',
            hintText: 'Add details, steps, or reminders',
            alignLabelWithHint: true,
            prefixIcon: Icon(Icons.notes_outlined),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<QuadrantType>(
          // value: selectedQuadrant,
          initialValue: selectedQuadrant,
          decoration: const InputDecoration(
            labelText: 'Quadrant',
            prefixIcon: Icon(Icons.grid_4x4_outlined),
          ),
          items: QuadrantType.values
              .map((q) => DropdownMenuItem(value: q, child: Text(q.title)))
              .toList(),
          onChanged: onQuadrantChanged,
        ),
        const SizedBox(height: 12),
        if (dateEnabled)
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onPickDueDate,
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.6),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      dateText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
