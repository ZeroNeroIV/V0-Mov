import 'package:flutter/material.dart';
import 'package:m0viewer/services/api_service.dart';
import 'package:m0viewer/screens/favorites_screen.dart';
import 'package:m0viewer/screens/show_details_screen.dart';
import 'package:m0viewer/screens/movie_screen.dart';
import 'package:m0viewer/screens/see_more_screen.dart';
import 'package:m0viewer/screens/series_screen.dart';
import 'package:m0viewer/screens/settings_screen.dart';
import 'package:m0viewer/services/theme_service.dart';
import 'package:m0viewer/widgets/show_poster.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    _HomeContent(),
    MoviesScreen(),
    SeriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeService>(context);

    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectedIndex = 0;
          _onItemTapped(0);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: Icon(
          Icons.home,
          size: 26,
          color:
              (_selectedIndex == 0) ? ThemeService().accentColor : Colors.grey,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        height: 56,
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.movie),
              color: _selectedIndex == 1
                  ? ThemeService().accentColor
                  : Colors.grey,
              onPressed: () => _onItemTapped(1),
            ),
            IconButton(
              icon: const Icon(Icons.tv),
              color: _selectedIndex == 2
                  ? ThemeService().accentColor
                  : Colors.grey,
              onPressed: () => _onItemTapped(2),
            ),
            const SizedBox(width: 48), // Space for the FAB
            IconButton(
              icon: const Icon(Icons.favorite),
              color: _selectedIndex == 3
                  ? ThemeService().accentColor
                  : Colors.grey,
              onPressed: () => _onItemTapped(3),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              color: _selectedIndex == 4
                  ? ThemeService().accentColor
                  : Colors.grey,
              onPressed: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('m0viewer'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(context, 'Most Recent Movies',
                APIService.getMostRecentShows(ShowType.movie)),
            _buildSection(context, 'Most Recent Series',
                APIService.getMostRecentShows(ShowType.tv)),
            _buildSection(context, 'Most Trending Movies',
                APIService.getMostTrendingShows(ShowType.movie)),
            _buildSection(context, 'Most Trending Series',
                APIService.getMostTrendingShows(ShowType.tv)),
            _buildSection(context, 'Recently Reviewed Movies',
                APIService.getRecentlyReviewedShows(ShowType.movie)),
            _buildSection(context, 'Recently Reviewed Series',
                APIService.getRecentlyReviewedShows(ShowType.tv)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, Future<List<dynamic>> future) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        SizedBox(
          height: 200,
          child: FutureBuilder<List<dynamic>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerEffect();
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No data available'));
              }

              final shows = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: shows.length + 1,
                itemBuilder: (context, index) {
                  if (index == shows.length) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(Icons.arrow_circle_right_outlined),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeeMoreScreen(
                                  title: title,
                                  showType: title.contains('Movies')
                                      ? ShowType.movie
                                      : ShowType.tv,
                                  fetchShows: (ShowType showType,
                                      {int page = 1, int limit = 9}) {
                                    switch (title) {
                                      case 'Most Recent Movies':
                                        return APIService.getMostRecentShows(
                                          showType,
                                        );
                                      case 'Most Recent Series':
                                        return APIService.getMostRecentShows(
                                          showType,
                                        );
                                      case 'Most Trending Movies':
                                        return APIService.getMostTrendingShows(
                                          showType,
                                        );
                                      case 'Most Trending Series':
                                        return APIService.getMostTrendingShows(
                                          showType,
                                        );
                                      case 'Recently Reviewed Movies':
                                        return APIService
                                            .getRecentlyReviewedShows(
                                          showType,
                                        );
                                      case 'Recently Reviewed Series':
                                        return APIService
                                            .getRecentlyReviewedShows(
                                          showType,
                                        );
                                      default:
                                        return Future.value([]);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                  final show = shows[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShowPoster(
                      posterPath: show['poster_path'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowDetailsScreen(
                              showId: show['id'],
                              showType: show['media_type'] == 'movie'
                                  ? ShowType.movie
                                  : ShowType.tv,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 120,
            height: 180,
            margin: const EdgeInsets.all(8.0),
            color: Colors.white,
          ),
        );
      },
    );
  }
}
