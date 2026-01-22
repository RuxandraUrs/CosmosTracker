import '../../domain/entities/iss_position.dart';
import '../../domain/entities/apod.dart';
import '../../domain/repositories/iss_repository.dart';
import '../datasources/iss_remote_data_source.dart';
import '../datasources/iss_local_data_source.dart';
import '../models/iss_position_model.dart';

class IssRepositoryImpl implements IssRepository {
  final IssRemoteDataSource remoteDataSource;
  final IssLocalDataSource localDataSource;

  IssRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<IssPosition> getIssPosition() async {
    return await remoteDataSource.getIssPosition();
  }

  @override
  Future<void> savePosition(IssPosition position) async {
    final model = IssPositionModel(
      latitude: position.latitude, 
      longitude: position.longitude,
      locationName: position.locationName ?? "Unknown Location", 
      timestamp: DateTime.now(), 
    );
    await localDataSource.savePosition(model);
  }

  @override
  Future<List<IssPosition>> getSavedPositions() async {
    return await localDataSource.getSavedPositions();
  }

  @override
  Future<Apod> getApod() async {
    return await remoteDataSource.getApod();
  }
}