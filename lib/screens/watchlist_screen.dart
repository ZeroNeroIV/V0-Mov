import 'package:flutter/material.dart';
import 'package:m0viewer/services/watchlist_service.dart';
import 'package:m0viewer/models/show.dart';
import 'package:m0viewer/screens/show_details_screen.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  late Future<List<Show>> _watchlistFuture;

  @override
  void initState() {
    super.initState();
    _watchlistFuture = WatchlistService.getWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: FutureBuilder<List<Show>>(
        future: _watchlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Your watchlist is empty'));
          }

          final watchlist = snapshot.data!;
          return ListView.builder(
            itemCount: watchlist.length,
            itemBuilder: (context, index) {
              final show = watchlist[index];
              return ListTile(
                leading: show.posterPath != null
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w92${show.posterPath}',
                        width: 50,
                        height: 75,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.movie),
                title: Text(show.title),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await WatchlistService.removeFromWatchlist(show.id);
                    setState(() {
                      _watchlistFuture = WatchlistService.getWatchlist();
                    });
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowDetailsScreen(
                        showId: show.id,
                        showType: show.showType,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
