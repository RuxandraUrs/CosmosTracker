import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart'; 
import '../../domain/entities/iss_position.dart';
import '../../domain/repositories/iss_repository.dart';
import 'iss_state.dart';

class IssCubit extends Cubit<IssState> {
  final IssRepository repository;

  IssCubit({required this.repository}) : super(IssInitial());

  Future<void> loadIssLocation() async {
    emit(IssLoading());
    try {
      final position = await repository.getIssPosition();
      
      String locationName = "Orbiting over Open Ocean / Remote Area";
      
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, 
          position.longitude
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          locationName = "${place.country ?? ''} ${place.administrativeArea ?? ''}".trim();
          if (locationName.isEmpty) locationName = "Orbiting over Open Ocean";
        }
      } catch (e) {
        //if reverse geocoding fails, we keep the default locationName
      }

      emit(IssLoaded(position, locationName: locationName));

    } catch (e) {
      emit(const IssError('Failed to load ISS location. Please check internet connection.'));
    }
  }

  Future<void> saveLocation(IssPosition position, String locationName) async {
    try {
      final positionToSave = IssPosition(
        latitude: position.latitude, 
        longitude: position.longitude,
        locationName: locationName, 
      );

      await repository.savePosition(positionToSave);
    } catch (e) {
      emit(const IssError('Failed to save location locally.'));
    }
  }
}