import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../databases/task_database.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskDatabase _database = TaskDatabase();
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();
  List<Task> get incompleteTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  // Load all tasks from database
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _database.getAllTasks();
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new task
  Future<bool> addTask(Task task) async {
    try {
      final id = await _database.insertTask(task);
      if (id > 0) {
        await loadTasks(); // Reload tasks to update the UI
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error adding task: $e');
      return false;
    }
  }

  // Update an existing task
  Future<bool> updateTask(Task task) async {
    try {
      final result = await _database.updateTask(task);
      if (result > 0) {
        await loadTasks(); // Reload tasks to update the UI
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating task: $e');
      return false;
    }
  }

  // Delete a task
  Future<bool> deleteTask(int id) async {
    try {
      final result = await _database.deleteTask(id);
      if (result > 0) {
        await loadTasks(); // Reload tasks to update the UI
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting task: $e');
      return false;
    }
  }

  // Toggle task completion status
  Future<bool> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    return await updateTask(updatedTask);
  }

  // Get task by id
  Future<Task?> getTaskById(int id) async {
    try {
      return await _database.getTask(id);
    } catch (e) {
      debugPrint('Error getting task: $e');
      return null;
    }
  }

  // Filter tasks by priority
  List<Task> getTasksByPriority(String priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  // Search tasks by title or description
  List<Task> searchTasks(String query) {
    if (query.isEmpty) return _tasks;

    return _tasks.where((task) {
      return task.title.toLowerCase().contains(query.toLowerCase()) ||
          task.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Get tasks for today
  List<Task> getTodayTasks() {
    final today = DateTime.now();
    return _tasks.where((task) {
      return task.date.year == today.year &&
          task.date.month == today.month &&
          task.date.day == today.day;
    }).toList();
  }

  // Get overdue tasks
  List<Task> getOverdueTasks() {
    final now = DateTime.now();
    return _tasks.where((task) {
      return task.date.isBefore(now) && !task.isCompleted;
    }).toList();
  }
}
