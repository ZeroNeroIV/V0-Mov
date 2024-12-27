import 'package:flutter/material.dart';
import 'package:m0viewer/services/api_service.dart';

class ShowPoster extends StatelessWidget {
  final String posterPath;
  final VoidCallback onTap;

  const ShowPoster({
    super.key,
    required this.posterPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.network(
        APIService.getImageUrl(posterPath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(child: Icon(Icons.error));
        },
      ),
    );
  }
}
