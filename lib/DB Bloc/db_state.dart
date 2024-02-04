part of 'db_bloc.dart';

sealed class DbState {}

final class DbInitial extends DbState {}

final class DbImageLoaded extends DbState {
  final List<DogImageModel> imageUrls;

  DbImageLoaded({required this.imageUrls});
}

final class DbImageLoading extends DbState {} 

final class DbImageError extends DbState {
  final String error;

  DbImageError({required this.error});
}
