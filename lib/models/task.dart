class Tugas {
  final int id;
  final String judul;
  final String deskripsi;
  final int kategori_id;

  Tugas({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.kategori_id,
  });

  factory Tugas.fromJson(Map<String, dynamic> json) {
    return Tugas(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      kategori_id: json['kategori_id'],
    );
  }
}
