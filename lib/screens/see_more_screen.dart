// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:m0viewer/screens/show_details_screen.dart';
import 'package:m0viewer/services/api_service.dart';
import 'package:m0viewer/widgets/show_poster.dart';

class SeeMoreScreen extends StatefulWidget {
  final String title;
  final ShowType showType;
  final Future<List<dynamic>> Function(ShowType showType, {required int limit})
      fetchShows;

  const SeeMoreScreen({
    super.key,
    required this.title,
    required this.showType,
    required this.fetchShows,
  });

  @override
  State<SeeMoreScreen> createState() => _SeeMoreScreenState();
}

class _SeeMoreScreenState extends State<SeeMoreScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<dynamic> _shows = [];
  int _currentLimit = 6;
  bool _isLoading = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _fetchMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMoreData) {
        _fetchMoreData();
      }
    });
  }

  Future<void> _fetchMoreData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final newShows = await widget.fetchShows(
        widget.showType,
        limit: _currentLimit,
      );
      setState(() {
        _shows.addAll(newShows);
        _currentLimit += 6;
        _hasMoreData = newShows.isNotEmpty;
      });
    } catch (error) {
      // Handle error
      print('Error fetching shows: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _shows.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _shows.length) {
            return Center(child: CircularProgressIndicator());
          }
          final show = _shows[index];
          return ShowPoster(
            posterPath: show['posterPath'],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowDetailsScreen(
                    showId: show['id'],
                    showType: widget.showType,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
