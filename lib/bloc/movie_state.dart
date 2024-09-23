import 'package:equatable/equatable.dart';

abstract class MovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<dynamic> movies;
  final int currentPage;

  MovieLoaded({required this.movies, required this.currentPage});

  @override
  List<Object?> get props => [movies, currentPage];
}

class MovieError extends MovieState {
  final String error;

  MovieError({required this.error});

  @override
  List<Object?> get props => [error];
}
