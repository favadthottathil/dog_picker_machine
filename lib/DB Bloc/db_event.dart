part of 'db_bloc.dart';

sealed class DbEvent {}

final class DbLoadImages extends DbEvent {}

final class DbSaveImage extends DbEvent {
  final String imageUrl;

  DbSaveImage({required this.imageUrl});
}

