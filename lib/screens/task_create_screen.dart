import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task_bloc.dart';
import '../blocs/task_event.dart';
import '../blocs/task_state.dart';
import '../repositories/api_service.dart';
import '../models/category.dart';

class TaskCreateScreen extends StatefulWidget {
  const TaskCreateScreen({super.key});

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final TextEditingController _judulCtrl = TextEditingController();
  final TextEditingController _deskripsiCtrl = TextEditingController();
  int? _kategoris_id;
  List<Kategori> _kategoris = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final categories = await ApiService.fetchKategoris();
    setState(() {
      _kategoris = categories;
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
      appBar: AppBar(title: const Text('Tambah Tugas')),
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
              hint: const Text('Pilih Kategori'),
              value: _kategoris_id,
              onChanged: (value) {
                setState(() {
                  _kategoris_id = value;
                });
              },
              items: _kategoris.map((kategoris) {
                return DropdownMenuItem<int>(
                  value: kategoris.id,
                  child: Text(kategoris.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_judulCtrl.text.isEmpty ||
                    _deskripsiCtrl.text.isEmpty ||
                    _kategoris_id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields are required')),
                  );
                  return;
                }

                context.read<TaskBloc>().add(CreateTask(
                  _judulCtrl.text,
                  _deskripsiCtrl.text,
                  _kategoris_id!,
                ));

                Navigator.pop(context); // Go back after creating task
              },
              child: const Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
