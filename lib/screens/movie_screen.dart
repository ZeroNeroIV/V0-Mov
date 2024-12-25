import 'package:flutter/material.dart';
import 'package:m0viewer/services/api_service.dart';
import 'package:m0viewer/screens/show_details_screen.dart';
import 'package:m0viewer/services/theme_service.dart';
import 'package:provider/provider.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late Future<List<dynamic>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = APIService.getPopularShows(ShowType.movie);
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No movies available'));
          }

          final movies = snapshot.data!;

          switch (themeService.displayStyle) {
            case DisplayStyle.listTile:
              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return ListTile(
                    leading: Image.network(
                      'https://image.tmdb.org/t/p/w92${movie['poster_path']}',
                      width: 56,
                      height: 84,
                      fit: BoxFit.cover,
                    ),
                    title: Text(movie['title']),
                    subtitle: Text(movie['release_date']),
                    onTap: () => _navigateToDetails(movie),
                  );
                },
              );
            case DisplayStyle.compact:
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return GestureDetector(
                    onTap: () => _navigateToDetails(movie),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w185${movie['poster_path']}',
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            case DisplayStyle.posterWithTitle:
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return GestureDetector(
                    onTap: () => _navigateToDetails(movie),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w185${movie['poster_path']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          movie['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }

  void _navigateToDetails(dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowDetailsScreen(
          showId: movie['id'],
          showType: ShowType.movie,
        ),
      ),
    );
  }
}
