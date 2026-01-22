import 'package:hive/hive.dart';
import '../../core/failures.dart';
import '../models/iss_position_model.dart';

abstract class IssLocalDataSource {
  Future<void> savePosition(IssPositionModel position);
  Future<List<IssPositionModel>> getSavedPositions();
}

class IssLocalDataSourceImpl implements IssLocalDataSource {
  final Box box;

  IssLocalDataSourceImpl({required this.box});

  @override
  Future<void> savePosition(IssPositionModel position) async {
    try {
      await box.put(DateTime.now().toString(), position);
    } catch (e) {
      throw CacheFailure();
    }
  }

  @override
  Future<List<IssPositionModel>> getSavedPositions() async {
    try {
      return box.values.toList().cast<IssPositionModel>();
    } catch (e) {
      throw CacheFailure();
    }
  }
}