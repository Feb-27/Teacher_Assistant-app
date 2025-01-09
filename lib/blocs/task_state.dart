import 'package:Teacher_Assistant/models/task.dart';

abstract class TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Tugas> tasks;

  TaskLoaded(this.tasks);
}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);
}
