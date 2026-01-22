import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/iss_repository.dart';
import 'apod_state.dart';

class ApodCubit extends Cubit<ApodState> {
  final IssRepository repository;

  ApodCubit({required this.repository}) : super(ApodInitial());

  Future<void> loadApod() async {
    emit(ApodLoading());
    try {
      final apod = await repository.getApod();
      emit(ApodLoaded(apod));
    } catch (e) {
      emit(ApodError("Failed to load NASA Picture of the Day."));
    }
  }
}