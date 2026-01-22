import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import '../../core/failures.dart';
import '../models/iss_position_model.dart';
import '../models/apod_model.dart';

abstract class IssRemoteDataSource {
  Future<IssPositionModel> getIssPosition();
  Future<ApodModel> getApod();
}

class IssRemoteDataSourceImpl implements IssRemoteDataSource {
  final Dio client;

  IssRemoteDataSourceImpl({required this.client});

  @override
  Future<IssPositionModel> getIssPosition() async {
    try {
      final response = await client.get('http://api.open-notify.org/iss-now.json');
      
      if (response.statusCode == 200) {
        return IssPositionModel.fromJson(response.data);
      } else {
        throw ServerFailure();
      }
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<ApodModel> getApod() async {
    try {
      final apiKey = dotenv.env['NASA_API_KEY'] ?? 'DEMO_KEY';
      
      final response = await client.get(
        'https://api.nasa.gov/planetary/apod?api_key=$apiKey'
      );

      if (response.statusCode == 200) {
        return ApodModel.fromJson(response.data);
      } else {
        throw ServerFailure();
      }
    } catch (e) {
      throw ServerFailure();
    }
  }
}