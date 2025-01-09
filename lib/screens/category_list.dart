import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/category_bloc.dart';
import '../blocs/category_event.dart';
import '../blocs/category_state.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCategoryDialog(context, isEdit: false);
            },
          ),
        ],
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoaded) {
            final categories = state.categories;

            // Jika kategori kosong, tampilkan pesan default
            if (categories.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada kategori yang tersedia.',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              );
            }

            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context
                          .read<CategoryBloc>()
                          .add(DeleteCategory(category.id));
                    },
                  ),
                  onTap: () {
                    _showCategoryDialog(context,
                        isEdit: true, categoryId: category.id, name: category.name);
                  },
                );
              },
            );
          } else if (state is CategoryError) {
            // Jika terjadi error, tampilkan pesan error
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }

          // Tampilan default saat state belum dimuat
          return const Center(
            child: Text(
              'Belum ada kategori yang tersedia.',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        },
      ),
    );
  }

  void _showCategoryDialog(BuildContext context,
      {required bool isEdit, int? categoryId, String? name}) {
    final nameController = TextEditingController(text: name ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Category' : 'Create Category'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (isEdit && categoryId != null) {
                  context
                      .read<CategoryBloc>()
                      .add(UpdateCategory(categoryId, newName));
                } else {
                  context.read<CategoryBloc>().add(CreateCategory(newName));
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
