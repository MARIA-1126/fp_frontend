import 'package:flutter/material.dart';

import '../models/task_models.dart';
import '../widgets/task_form_fields.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({
    super.key,
    required this.initialTask,
    required this.onSave,
  });

  final TaskModel initialTask;
  final void Function({
    required String title,
    required String? note,
    required QuadrantType quadrant,
    DateTime? dueDate,
  })
  onSave;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _noteController;

  late QuadrantType _selectedQuadrant;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _selectedQuadrant = widget.initialTask.quadrant;
    _dueDate = widget.initialTask.dueDate;

    _titleController = TextEditingController(text: widget.initialTask.title);
    _noteController = TextEditingController(
      text: widget.initialTask.note ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final initial = _dueDate ?? now;

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
      initialDate: initial,
    );

    if (!mounted) return;
    if (picked == null) return;

    setState(() {
      _dueDate = picked;
    });
  }

  void _submit() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final title = _titleController.text.trim();
    final noteRaw = _noteController.text;
    final note = noteRaw.trim().isEmpty ? null : noteRaw.trim();

    widget.onSave(
      title: title,
      note: note,
      quadrant: _selectedQuadrant,
      dueDate: _dueDate,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Update the task details and quadrant.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                TaskFormFields(
                  titleController: _titleController,
                  noteController: _noteController,
                  selectedQuadrant: _selectedQuadrant,
                  onQuadrantChanged: (v) {
                    if (v == null) return;
                    setState(() => _selectedQuadrant = v);
                  },
                  dueDate: _dueDate,
                  onPickDueDate: _pickDueDate,
                  dateEnabled: true,
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Save Task'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
