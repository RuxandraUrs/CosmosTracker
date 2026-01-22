import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/iss_position.dart';
import '../../domain/repositories/iss_repository.dart';

// --- STĂRILE ---
abstract class FavoritesState {}
class FavoritesLoading extends FavoritesState {}
class FavoritesLoaded extends FavoritesState {
  final List<IssPosition> positions;
  FavoritesLoaded(this.positions);
}
class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}

class FavoritesCubit extends Cubit<FavoritesState> {
  final IssRepository repository;

  FavoritesCubit({required this.repository}) : super(FavoritesLoading());

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    try {
      final positions = await repository.getSavedPositions();
      emit(FavoritesLoaded(positions));
    } catch (e) {
      emit(FavoritesError("Nu s-a putut încărca istoricul."));
    }
  }
}