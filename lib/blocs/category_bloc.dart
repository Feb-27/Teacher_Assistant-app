import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/api_service.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryLoading()) {
    on<FetchCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = await ApiService.fetchKategoris();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError('Failed to fetch categories'));
      }
    });

    on<CreateCategory>((event, emit) async {
      try {
        await ApiService.createKategori(event.name);
        add(FetchCategories()); // Refresh data
      } catch (e) {
        emit(CategoryError('Failed to create category'));
      }
    });

    on<UpdateCategory>((event, emit) async {
      try {
        await ApiService.updateKategori(event.id, event.name);
        add(FetchCategories()); // Refresh data
      } catch (e) {
        emit(CategoryError('Failed to update category'));
      }
    });

    on<DeleteCategory>((event, emit) async {
      try {
        await ApiService.deleteKategori(event.id);
        add(FetchCategories()); // Refresh data
      } catch (e) {
        emit(CategoryError('Failed to delete category'));
      }
    });
  }
}
