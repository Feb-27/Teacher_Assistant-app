import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';
import '../models/category.dart';

class ApiService {
  static const baseUrl = 'http://192.168.43.8:8000/api'; 

  // Fetch all tasks
  static Future<List<Tugas>> fetchTugas() async {
  final response = await http.get(Uri.parse('$baseUrl/task'));
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final List data = jsonResponse['data']; // Ambil data dari objek 'data'
    
    return data.map((e) => Tugas.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load task');
  }
}

  // Fetch categories
  static Future<List<Kategori>> fetchKategoris() async {
  final response = await http.get(Uri.parse('$baseUrl/kategoris'));
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final List data = jsonResponse['data']; // Ambil data dari objek 'data'
    
    return data.map((e) => Kategori.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load categories');
  }
}

static Future<bool> createKategori(String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/kategoris'),
      body: {'name': name},
    );
    return response.statusCode == 201;
  }

  // Update a category
  static Future<bool> updateKategori(int id, String name) async {
    final response = await http.put(
      Uri.parse('$baseUrl/kategoris/$id'),
      body: {'name': name},
    );
    return response.statusCode == 200;
  }

  // Delete a category
  static Future<bool> deleteKategori(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/kategoris/$id'));
    return response.statusCode == 200;
  }

  // Create a task
  static Future<bool> createTask(String judul, String deskripsi, int kategori_id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/task'),
      body: {
        'judul': judul,
        'deskripsi': deskripsi,
        'kategori_id': kategori_id.toString(),
      },
    );
    return response.statusCode == 201;
  }

  // Update a task
  static Future<bool> updateTask(int id, String judul, String deskripsi, int kategori_id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/task/$id'),
      body: {
        'judul': judul,
        'deskripsi': deskripsi,
        'kategori_id': kategori_id.toString(),
      },
    );
    return response.statusCode == 200;
  }

  // Delete a task
  static Future<bool> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/task/$id'));
    return response.statusCode == 200;
  }
}
