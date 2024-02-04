part of 'image_pick_bloc.dart';

@immutable
abstract class ImagePickState {}

final class ImagePickInitial extends ImagePickState {}

final class ImageLoading extends ImagePickState {}

final class ImageLoaded extends ImagePickState {
  final String imageUrl;

  ImageLoaded({required this.imageUrl});
}

final class ImageError extends ImagePickState {
  final String errorMessage;

  ImageError({required this.errorMessage});
}
