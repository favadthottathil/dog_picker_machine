import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dog_picker/Controller/database_controller.dart';
import 'package:dog_picker/Model/dog_image_model.dart';

part 'db_event.dart';
part 'db_state.dart';

class DbBloc extends Bloc<DbEvent, DbState> {
  DbBloc() : super(DbInitial()) {
    on<DbSaveImage>(_dbSaveImage);

    on<DbLoadImages>(_dbLoadImages);
  }

  _dbLoadImages(DbLoadImages event, Emitter<DbState> emit) async {
    emit(DbImageLoading());

    try {
      List<DogImageModel> imageUrls = await DatabaseController().getDogImages();

      emit(DbImageLoaded(imageUrls: imageUrls));
    } catch (e) {
      emit(DbImageError(error: e.toString()));
    }
  }

  Future<void> _dbSaveImage(DbSaveImage event, Emitter<DbState> emit) async {
    try {
      await DatabaseController().saveDogImages(event.imageUrl);
    } catch (e) {
      emit(DbImageError(error: e.toString()));
    }
  }
}
