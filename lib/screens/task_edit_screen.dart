import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task_bloc.dart';
import '../blocs/task_event.dart';
import '../blocs/task_state.dart';
import '../models/task.dart';
import '../repositories/api_service.dart';
import '../models/category.dart';

class TaskEditScreen extends StatefulWidget {
  final Tugas task;

  const TaskEditScreen({super.key, required this.task});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final TextEditingController _judulCtrl = TextEditingController();
  final TextEditingController _deskripsiCtrl = TextEditingController();
  int? _kategori_id;
  List<Kategori> _categories = [];

  @override
  void initState() {
    super.initState();
    _judulCtrl.text = widget.task.judul;
    _deskripsiCtrl.text = widget.task.deskripsi;
    _kategori_id = widget.task.kategori_id;
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final categories = await ApiService.fetchKategoris();
    setState(() {
      _categories = categories;
    });
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _deskripsiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _judulCtrl,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _deskripsiCtrl,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            const SizedBox(height: 10),
            DropdownButton<int>(
              value: _kategori_id,
              hint: const Text('Pilih Kategori'),
              onChanged: (value) {
                setState(() {
                  _kategori_id = value;
                });
              },
              items: _categories.map((category) {
                return DropdownMenuItem<int>(
                  value: category.id,
                  child: Text(category.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_judulCtrl.text.isEmpty ||
                    _deskripsiCtrl.text.isEmpty ||
                    _kategori_id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields are required')),
                  );
                  return;
                }

                ApiService.updateTask(
                  widget.task.id,
                  _judulCtrl.text,
                  _deskripsiCtrl.text,
                  _kategori_id!,
                );

                Navigator.pop(context);
                context.read<TaskBloc>().add(FetchTasks()); // Refresh task list
              },
              child: const Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
