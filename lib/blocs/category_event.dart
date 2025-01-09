import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCategories extends CategoryEvent {}

class CreateCategory extends CategoryEvent {
  final String name;

  CreateCategory(this.name);

  @override
  List<Object> get props => [name];
}

class UpdateCategory extends CategoryEvent {
  final int id;
  final String name;

  UpdateCategory(this.id, this.name);

  @override
  List<Object> get props => [id, name];
}

class DeleteCategory extends CategoryEvent {
  final int id;

  DeleteCategory(this.id);

  @override
  List<Object> get props => [id];
}
