import 'dart:developer';

import 'package:hive/hive.dart';
import '../models/task_models.dart';

class TaskStorageService {
  static final TaskStorageService _instance = TaskStorageService._internal();
  factory TaskStorageService() => _instance;
  TaskStorageService._internal();

  static const String _boxName = 'tasksBox';
  late Box<TaskModel> _taskBox;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) {
      log("DEBUG: Already initialized");
      return;
    }
    
    log("DEBUG: Initializing Hive box...");
    _taskBox = await Hive.openBox<TaskModel>(_boxName);
    _isInitialized = true;
    log("DEBUG: Hive box opened. Current tasks: ${_taskBox.length}");
  }

  // Get all tasks for a quadrant
  List<TaskModel> getTasksByQuadrant(QuadrantType quadrant) {
    if (!_isInitialized) return [];
    return _taskBox.values
        .where((task) => task.quadrant == quadrant)
        .toList()
      ..sort((a, b) {
        // Sort by order field first, then by due date if available
        if (a.order != b.order) {
          return a.order.compareTo(b.order);
        }
        if (a.dueDate != null && b.dueDate != null) {
          return a.dueDate!.compareTo(b.dueDate!);
        }
        if (a.dueDate != null) return -1;
        if (b.dueDate != null) return 1;
        return a.createdAt.compareTo(b.createdAt);
      });
  }

  // Get all tasks
  List<TaskModel> getAllTasks() {
    if (!_isInitialized) return [];
    return _taskBox.values.toList()
      ..sort((a, b) {
        // Sort by order field first, then by due date if available
        if (a.order != b.order) {
          return a.order.compareTo(b.order);
        }
        if (a.dueDate != null && b.dueDate != null) {
          return a.dueDate!.compareTo(b.dueDate!);
        }
        if (a.dueDate != null) return -1;
        if (b.dueDate != null) return 1;
        return a.createdAt.compareTo(b.createdAt);
      });
  }

  // Add task
  Future<void> addTask(TaskModel task) async {
    if (!_isInitialized) await init();
    log("DEBUG: Adding task: ${task.title}");
    await _taskBox.add(task);
    log("DEBUG: Task added. Box now has ${_taskBox.length} tasks");
  }

  // Update task by ID
  Future<void> updateTask(String taskId, TaskModel updatedTask) async {
    if (!_isInitialized) await init();
    final index = _taskBox.values.toList().indexWhere((t) => t.id == taskId);
    if (index != -1) {
      await _taskBox.putAt(index, updatedTask);
      log("DEBUG: Task updated at index $index");
    }
  }

  // Delete task by ID
  Future<void> deleteTask(String taskId) async {
    if (!_isInitialized) await init();
    final index = _taskBox.values.toList().indexWhere((t) => t.id == taskId);
    if (index != -1) {
      await _taskBox.deleteAt(index);
      log("DEBUG: Task deleted at index $index");
    }
  }

  // Toggle completion
  Future<void> toggleTaskComplete(String taskId, bool completed) async {
    if (!_isInitialized) await init();
    final index = _taskBox.values.toList().indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _taskBox.getAt(index);
      if (task != null) {
        final updated = task.copyWith(isCompleted: completed);
        await _taskBox.putAt(index, updated);
        log("DEBUG: Task toggled at index $index");
      }
    }
  }

  // Update task order for a quadrant
  Future<void> updateTaskOrder(QuadrantType quadrant, List<TaskModel> tasks) async {
    if (!_isInitialized) await init();
    
    // Update each task with its new order
    for (final task in tasks) {
      final index = _taskBox.values.toList().indexWhere((t) => t.id == task.id);
      if (index != -1) {
        await _taskBox.putAt(index, task);
        log("DEBUG: Task order updated for ${task.id} at index $index");
      }
    }
  }

  // Get pending task count (for notifications)
  int getPendingTaskCount() {
    if (!_isInitialized) return 0;
    return _taskBox.values.where((task) => !task.isCompleted).length;
  }

  // Clear all tasks (for testing)
  Future<void> clearAllTasks() async {
    if (!_isInitialized) await init();
    await _taskBox.clear();
    log("DEBUG: All tasks cleared");
  }
}