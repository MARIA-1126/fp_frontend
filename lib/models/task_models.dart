import 'package:flutter/material.dart';

/// The 4 Eisenhower Matrix quadrants.
enum QuadrantType {
  importantUrgent,
  importantNotUrgent,
  notImportantUrgent,
  notImportantNotUrgent,
}

extension QuadrantTypeX on QuadrantType {
  String get title {
    switch (this) {
      case QuadrantType.importantUrgent:
        return 'Important & Urgent';
      case QuadrantType.importantNotUrgent:
        return 'Important & Not Urgent';
      case QuadrantType.notImportantUrgent:
        return 'Not Important & Urgent';
      case QuadrantType.notImportantNotUrgent:
        return 'Not Important & Not Urgent';
    }
  }

  /// A distinct base color for each quadrant.
  Color get color {
    switch (this) {
      case QuadrantType.importantUrgent:
        return const Color(0xFFD32F2F);
      case QuadrantType.importantNotUrgent:
        return const Color(0xFF8E24AA);
      case QuadrantType.notImportantUrgent:
        return const Color(0xFF1976D2);
      case QuadrantType.notImportantNotUrgent:
        return const Color(0xFF388E3C);
    }
  }
}

/// Simple task model used for UI-only mock state.
class TaskModel {
  TaskModel({
    required this.id,
    required this.title,
    this.note,
    required this.quadrant,
    this.dueDate,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String title;
  final String? note;
  final QuadrantType quadrant;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime createdAt;

  TaskModel copyWith({
    String? id,
    String? title,
    String? note,
    QuadrantType? quadrant,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      quadrant: quadrant ?? this.quadrant,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
