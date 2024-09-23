import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String apiKey = 'ec70314aa918d68a83ab1a3b668d4773'; // Your TMDb API key

  // Fetch movies using the search query
  Future<List<dynamic>> fetchMovies(String query, int page) async {
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/search/movie',
        queryParameters: {
          'api_key': apiKey,
          'query': query,
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        return response.data['results'] ?? [];
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      print('Error fetching movies: $e'); // Log the error for debugging
      throw Exception('Failed to fetch movies');
    }
  }
}
