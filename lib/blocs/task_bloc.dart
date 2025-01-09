import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/api_service.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskLoading()) {
    on<FetchTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tugas = await ApiService.fetchTugas();
        emit(TaskLoaded(tugas));
      } catch (e) {
        emit(TaskError('Failed to fetch task'));
      }
    });

    on<CreateTask>((event, emit) async {
      try {
        await ApiService.createTask(event.judul, event.deskripsi, event.kategori_id);
        add(FetchTasks()); // Refresh data
      } catch (e) {
        emit(TaskError('Failed to create task'));
      }
    });
  }
}
