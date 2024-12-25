import 'package:hive/hive.dart';

part 'history_model.g.dart';

@HiveType(typeId: 1)
class HistoryModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? posterPath;

  @HiveField(3)
  final String? overview;

  @HiveField(4)
  final double? rating;

  @HiveField(5)
  final bool isMovie;

  HistoryModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.overview,
    this.rating,
    required this.isMovie,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json, bool isMovie) {
    return HistoryModel(
      id: json['id'],
      title: isMovie ? json['title'] : json['name'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      rating: json['vote_average']?.toDouble(),
      isMovie: isMovie,
    );
  }
}
