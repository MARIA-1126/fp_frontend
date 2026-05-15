import 'dart:developer';

import 'package:flutter/material.dart';
import '../models/task_models.dart';
import '../services/task_storage_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskStorageService _storageService = TaskStorageService();
  List<TaskModel> _tasks = [];
  bool _isLoading = false;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;

  // Initialize and load tasks
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    await _storageService.init();
    _tasks = _storageService.getAllTasks();
    
    _isLoading = false;
    notifyListeners();
  }

  // Get tasks for a specific quadrant
  List<TaskModel> getTasksByQuadrant(QuadrantType quadrant) {
    return _tasks
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

  // Add a new task
  Future<void> addTask(TaskModel task) async {
    try {
      await _storageService.addTask(task);
      await loadTasks();
    } catch (e) {
      log("Error adding task: $e");
    }
  }

  // Update an existing task
  Future<void> updateTask(String taskId, TaskModel updatedTask) async {
    try {
      await _storageService.updateTask(taskId, updatedTask);
      await loadTasks();
    } catch (e) {
      log("Error updating task: $e");
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await _storageService.deleteTask(taskId);
      await loadTasks();
    } catch (e) {
      log("Error deleting task: $e");
    }
  }

  // Toggle task completion
  Future<void> toggleTaskComplete(String taskId, bool completed) async {
    try {
      await _storageService.toggleTaskComplete(taskId, completed);
      await loadTasks();
    } catch (e) {
      log("Error toggling task: $e");
    }
  }

  // Reorder tasks within a quadrant
  Future<void> reorderTasks(QuadrantType quadrant, int oldIndex, int newIndex) async {
    try {
      // Get all tasks for this quadrant
      final quadrantTasks = getTasksByQuadrant(quadrant);
      
      // Make sure indices are valid
      if (oldIndex < 0 || oldIndex >= quadrantTasks.length || 
          newIndex < 0 || newIndex >= quadrantTasks.length) {
        return;
      }
      
      // Remove the task from its old position
      final task = quadrantTasks.removeAt(oldIndex);
      
      // Insert the task at its new position
      quadrantTasks.insert(newIndex, task);
      
      // Update the order field for all tasks in this quadrant
      for (int i = 0; i < quadrantTasks.length; i++) {
        quadrantTasks[i] = quadrantTasks[i].copyWith(order: i);
      }
      
      // Save all updated tasks to storage
      for (final updatedTask in quadrantTasks) {
        await _storageService.updateTask(updatedTask.id, updatedTask);
      }
      
      // Reload tasks
      await loadTasks();
    } catch (e) {
      log("Error reordering tasks: $e");
    }
  }

  // Get pending task count (for notifications)
  int getPendingTaskCount() {
    return _tasks.where((task) => !task.isCompleted).length;
  }
}