import 'package:bloc/bloc.dart';
import 'package:dog_picker/Controller/image_pick_controller.dart';
import 'package:flutter/material.dart';

part 'image_pick_event.dart';
part 'image_pick_state.dart';

class ImagePickBloc extends Bloc<ImagePickEvent, ImagePickState> {
  ImagePickBloc() : super(ImagePickInitial()) {
    on<FetchImage>(_fetchImage);
  }

  _fetchImage(FetchImage event, Emitter<ImagePickState> emit) async {
    try {
      emit(ImageLoading());

      String imageUrl = await ImagePickController().getImage();

      if (imageUrl.isNotEmpty) {
        emit(ImageLoaded(imageUrl: imageUrl));
      } else {
        emit(ImageError(errorMessage: 'Failed To Fetch Image'));
      }
    } catch (e) {
      emit(ImageError(errorMessage: e.toString()));
    }
  }
}
