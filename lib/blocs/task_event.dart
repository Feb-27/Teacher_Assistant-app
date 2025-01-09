abstract class TaskEvent {}

class FetchTasks extends TaskEvent {}

class CreateTask extends TaskEvent {
  final String judul;
  final String deskripsi;
  final int kategori_id;

  CreateTask(this.judul, this.deskripsi, this.kategori_id);
}
