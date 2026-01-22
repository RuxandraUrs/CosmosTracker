abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = 'Failed to connect to the server.']);
}

class CacheFailure extends Failure {
  CacheFailure([super.message = 'Failed to load or save local data.']);
}