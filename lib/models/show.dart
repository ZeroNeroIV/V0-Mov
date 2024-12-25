import 'package:m0viewer/services/api_service.dart';

class Show {
  final int id;
  final String title;
  final String? posterPath;
  final ShowType showType;

  Show({
    required this.id,
    required this.title,
    this.posterPath,
    required this.showType,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      showType: ShowType.values[json['show_type']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'show_type': showType.index,
    };
  }
}
