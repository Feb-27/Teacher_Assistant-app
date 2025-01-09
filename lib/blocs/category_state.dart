import 'package:equatable/equatable.dart';
import '../models/category.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Kategori> categories;

  CategoryLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);

  @override
  List<Object> get props => [message];
}
