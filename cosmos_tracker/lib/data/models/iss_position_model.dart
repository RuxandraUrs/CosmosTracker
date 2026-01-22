import 'package:hive/hive.dart';
import '../../domain/entities/iss_position.dart';
part 'iss_position_model.g.dart'; 

@HiveType(typeId: 0)
class IssPositionModel extends IssPosition {
  @override 
  @HiveField(0)
  final double latitude;

  @override 
  @HiveField(1)
  final double longitude;

  @override
  @HiveField(2)
  final String? locationName;

  @override
  @HiveField(3)
  final DateTime? timestamp;

  const IssPositionModel({
    required this.latitude,
    required this.longitude,
    this.locationName,
    this.timestamp,
  }) : super(
          latitude: latitude, 
          longitude: longitude,
          locationName: locationName,
          timestamp: timestamp,
        );

  factory IssPositionModel.fromJson(Map<String, dynamic> json) {
    final positionData = json['iss_position'];
    return IssPositionModel(
      latitude: double.parse(positionData['latitude']),
      longitude: double.parse(positionData['longitude']),
      locationName: null, 
      timestamp: null,
    );
  }
}