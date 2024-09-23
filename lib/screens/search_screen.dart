import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/bloc/movie_bloc.dart';
import 'package:project/bloc/movie_event.dart';
import 'package:project/bloc/movie_state.dart';
import 'package:project/screens/movie_detail_screen.dart';
import 'package:project/services/api_services.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late MovieBloc _movieBloc;

  @override
  void initState() {
    super.initState();
    _movieBloc = MovieBloc(ApiService());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _movieBloc.close();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      _movieBloc.add(FetchMovies(query: query, page: 1));
    } else {
      _movieBloc.add(ClearMovies()); // Clears the search results
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: _onSearchChanged,
            ),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => _movieBloc,
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MovieLoaded) {
              if (state.movies.isEmpty) {
                return Center(child: Text('No results found.'));
              }
              return ListView.builder(
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return ListTile(
                    title: Text(movie['title'] ?? 'No Title'),
                    subtitle: Text(movie['release_date']?.split('-').first ??
                        'Unknown Year'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(movie: movie),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is MovieError) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return Center(child: Text('Start searching for movies.'));
          },
        ),
      ),
    );
  }
}
