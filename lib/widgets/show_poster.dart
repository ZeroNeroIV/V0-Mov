import 'package:flutter/material.dart';
import 'package:m0viewer/services/api_service.dart';

class ShowPoster extends StatelessWidget {
  final String posterPath;
  final VoidCallback onTap;

  const ShowPoster({super.key, required this.posterPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            APIService.getImageUrl(posterPath, size: 'w185'),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: Icon(
                  Icons.error,
                  color: Colors.grey[600],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
