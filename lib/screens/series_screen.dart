import 'package:flutter/material.dart';
import 'package:m0viewer/services/api_service.dart';
import 'package:m0viewer/screens/show_details_screen.dart';
import 'package:m0viewer/services/theme_service.dart';
import 'package:provider/provider.dart';

class SeriesScreen extends StatefulWidget {
  const SeriesScreen({super.key});

  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  late Future<List<dynamic>> _seriesFuture;

  @override
  void initState() {
    super.initState();
    _seriesFuture = APIService.getPopularShows(ShowType.tv);
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV Series'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _seriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No TV series available'));
          }

          final series = snapshot.data!;

          switch (themeService.displayStyle) {
            case DisplayStyle.listTile:
              return ListView.builder(
                itemCount: series.length,
                itemBuilder: (context, index) {
                  final show = series[index];
                  return ListTile(
                    leading: Image.network(
                      'https://image.tmdb.org/t/p/w92${show['poster_path']}',
                      width: 56,
                      height: 84,
                      fit: BoxFit.cover,
                    ),
                    title: Text(show['name']),
                    subtitle: Text(show['first_air_date']),
                    onTap: () => _navigateToDetails(show),
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
                itemCount: series.length,
                itemBuilder: (context, index) {
                  final show = series[index];
                  return GestureDetector(
                    onTap: () => _navigateToDetails(show),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w185${show['poster_path']}',
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
                itemCount: series.length,
                itemBuilder: (context, index) {
                  final show = series[index];
                  return GestureDetector(
                    onTap: () => _navigateToDetails(show),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w185${show['poster_path']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          show['name'],
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

  void _navigateToDetails(dynamic show) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowDetailsScreen(
          showId: show['id'],
          showType: ShowType.tv,
        ),
      ),
    );
  }
}
