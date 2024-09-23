import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project/bloc/movie_bloc.dart';
import 'package:project/bloc/movie_event.dart';
import 'package:project/bloc/movie_state.dart';
import 'package:project/screens/movie_card.dart';
import 'package:project/screens/search_screen.dart';
import 'package:project/services/api_services.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The MovieDb',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Now Playing Section
            Section(
              title: 'Now Playing',
              event: FetchMovies(query: 'upcoming'),
            ),
            // Upcoming Section
            Section(
              title: 'Upcoming',
              event: FetchMovies(query: 'upcoming'),
            ),
            // Top Rated Section
            Section(
              title: 'Top Rated',
              event: FetchMovies(query: 'upcoming'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        onTap: (index) {
          // Navigate based on selected index if needed

          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final MovieEvent event;

  const Section({required this.title, required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 220, // Height for movie cards
          child: BlocProvider(
            create: (context) => MovieBloc(ApiService())..add(event),
            child: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state is MovieLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MovieLoaded) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: MovieCard(movie: movie),
                      );
                    },
                  );
                } else if (state is MovieError) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                return Center(child: Text('No movies found.'));
              },
            ),
          ),
        ),
      ],
    );
  }
}
