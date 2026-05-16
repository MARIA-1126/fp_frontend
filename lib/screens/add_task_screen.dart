import 'package:flutter/material.dart';

import '../models/task_models.dart';
import '../widgets/task_form_fields.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({
    super.key, 
    required this.onSave,
    this.initialQuadrant
    });

final QuadrantType? initialQuadrant; 
  final void Function({
    required String title,
    required String? note,
    required QuadrantType quadrant,
    DateTime? dueDate,
  })
  onSave;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  QuadrantType _selectedQuadrant = QuadrantType.importantUrgent;
  DateTime? _dueDate;

@override
  void initState() {
    super.initState();
    _selectedQuadrant = widget.initialQuadrant ?? QuadrantType.importantUrgent;
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
      appBar: AppBar(title: const Text('Add Task')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create a task and place it into the right quadrant.',
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
