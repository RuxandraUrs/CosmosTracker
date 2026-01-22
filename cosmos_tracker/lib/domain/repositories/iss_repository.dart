import '../entities/iss_position.dart';
import '../entities/apod.dart'; 

abstract class IssRepository {
  Future<IssPosition> getIssPosition();
  Future<void> savePosition(IssPosition position);
  Future<List<IssPosition>> getSavedPositions();

  Future<Apod> getApod();
}