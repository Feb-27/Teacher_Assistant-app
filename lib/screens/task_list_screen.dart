import 'package:Teacher_Assistant/repositories/api_service.dart';
import 'package:Teacher_Assistant/screens/task_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task_bloc.dart';
import '../blocs/task_event.dart';
import '../blocs/task_state.dart';
import 'task_create_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaskCreateScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoaded) {
            final tasks = state.tasks;

            // Tampilkan pesan default jika tidak ada tugas
            if (tasks.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada tugas yang tersedia.',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              );
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final tugas = tasks[index];
                return ListTile(
                  title: Text(tugas.judul),
                  subtitle: Text(tugas.deskripsi),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Tampilkan konfirmasi hapus tugas
                      _showDeleteConfirmation(context, tugas.id);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskEditScreen(task: tugas),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is TaskError) {
            // Tampilkan pesan error jika terjadi kesalahan
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }

          // Tampilan default jika state belum dimuat
          return const Center(
            child: Text(
              'Belum ada tugas yang tersedia.',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int tugasId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Panggil API untuk menghapus tugas
              await ApiService.deleteTask(tugasId);
              context.read<TaskBloc>().add(FetchTasks()); // Perbarui daftar tugas
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
