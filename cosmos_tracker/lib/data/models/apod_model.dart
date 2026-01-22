import '../../domain/entities/apod.dart';

class ApodModel extends Apod {
  const ApodModel({
    required super.title,
    required super.explanation,
    required super.imageUrl,
    required super.date,
  });

  factory ApodModel.fromJson(Map<String, dynamic> json) {
    return ApodModel(
      title: json['title'] ?? 'No Title',
      explanation: json['explanation'] ?? 'No description available.',
      imageUrl: json['url'] ?? '',
      date: json['date'] ?? '',
    );
  }
}