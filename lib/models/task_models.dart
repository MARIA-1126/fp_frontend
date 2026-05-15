import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'task_models.g.dart';

@HiveType(typeId: 1)
enum QuadrantType {
  @HiveField(0)
  importantUrgent,
  
  @HiveField(1)
  importantNotUrgent,
  
  @HiveField(2)
  notImportantUrgent,
  
  @HiveField(3)
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

@HiveType(typeId: 0)
class TaskModel {
  TaskModel({
    required this.id,
    required this.title,
    this.note,
    required this.quadrant,
    this.dueDate,
    this.isCompleted = false,
    DateTime? createdAt,
    this.order = 0, // Add order field with default 0
  }) : createdAt = createdAt ?? DateTime.now();

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? note;

  @HiveField(3)
  final QuadrantType quadrant;

  @HiveField(4)
  final DateTime? dueDate;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final int order; // Add order field

  TaskModel copyWith({
    String? id,
    String? title,
    String? note,
    QuadrantType? quadrant,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
    int? order,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      quadrant: quadrant ?? this.quadrant,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      order: order ?? this.order,
    );
  }
}