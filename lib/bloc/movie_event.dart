import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMovies extends MovieEvent {
  final String query;
  final int page;

  FetchMovies({required this.query, this.page = 1});

  @override
  List<Object?> get props => [query, page];
}

class LoadMoreMovies extends MovieEvent {
  final String query;
  final int page;

  LoadMoreMovies({required this.query, required this.page});

  @override
  List<Object?> get props => [query, page];
}

class ClearMovies extends MovieEvent {}
