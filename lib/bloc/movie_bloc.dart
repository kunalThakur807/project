import 'package:bloc/bloc.dart';
import 'package:project/services/api_services.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final ApiService apiService;

  MovieBloc(this.apiService) : super(MovieInitial()) {
    on<FetchMovies>(_onFetchMovies);
    on<LoadMoreMovies>(_onLoadMoreMovies);
    on<ClearMovies>(_onClearMovies);
  }

  void _onFetchMovies(FetchMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final movies = await apiService.fetchMovies(event.query, event.page);
      emit(MovieLoaded(movies: movies, currentPage: event.page));
    } catch (e) {
      emit(MovieError(error: e.toString()));
    }
  }

  void _onLoadMoreMovies(LoadMoreMovies event, Emitter<MovieState> emit) async {
    final currentState = state;
    if (currentState is MovieLoaded) {
      try {
        final newMovies = await apiService.fetchMovies(event.query, event.page);
        emit(MovieLoaded(
          movies: currentState.movies + newMovies,
          currentPage: event.page,
        ));
      } catch (e) {
        emit(MovieError(error: e.toString()));
      }
    }
  }

  void _onClearMovies(ClearMovies event, Emitter<MovieState> emit) {
    emit(MovieInitial());
  }
}
