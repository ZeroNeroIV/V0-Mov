import 'package:flutter/material.dart';
import 'package:m0viewer/services/api_service.dart';
import 'package:m0viewer/models/show_model.dart';
import 'package:m0viewer/services/favorites_service.dart';

class ShowDetailsScreen extends StatefulWidget {
  final int showId;
  final ShowType showType;

  const ShowDetailsScreen({
    super.key,
    required this.showId,
    required this.showType,
  });

  @override
  State<ShowDetailsScreen> createState() => _ShowDetailsScreenState();
}

class _ShowDetailsScreenState extends State<ShowDetailsScreen> {
  late Future<Map<String, dynamic>> _showDetailsFuture;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _showDetailsFuture =
        APIService.getShowDetails(widget.showId, widget.showType);
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() {
    _isFavorite = FavoritesService.isFavorite(widget.showId);
    setState(() {});
  }

  Future<void> _toggleFavorite(Map<String, dynamic> showDetails) async {
    if (_isFavorite) {
      await FavoritesService.removeFromFavorites(widget.showId);
    } else {
      final show = ShowModel.fromJson(
        showDetails,
        widget.showType == ShowType.movie,
      );
      await FavoritesService.addToFavorites(show);
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        actions: [
          FutureBuilder<Map<String, dynamic>>(
            future: _showDetailsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();
              return IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : null,
                ),
                onPressed: () => _toggleFavorite(snapshot.data!),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _showDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final showDetails = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showDetails['backdrop_path'] != null)
                  Image.network(
                    'https://image.tmdb.org/t/p/w500${showDetails['backdrop_path']}',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        showDetails['title'] ?? showDetails['name'],
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            '${(showDetails['vote_average'] as num).toStringAsFixed(1)}/10',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      Text(
                        showDetails['overview'] ?? 'No overview available',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
